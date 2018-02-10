// SQL Notebook
// Copyright (C) 2018 Brian Luft
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using Gee;
using SqlNotebook.Errors;
using SqlNotebook.Interpreter.Ast;
using SqlNotebook.Interpreter.SqliteSyntax;
using SqlNotebook.Interpreter.Tokens;

namespace SqlNotebook.Interpreter {
    public class ScriptParser : Object {
        private Tokenizer _tokenizer;
        private SqliteParser _sqlite_parser;

        private Regex _variable_name_regex;

        public ScriptParser(Tokenizer tokenizer, SqliteParser sqlite_parser) {
            _tokenizer = tokenizer;
            _sqlite_parser = sqlite_parser;

            try {
                _variable_name_regex = new Regex("^[:@$][A-Za-z_][A-Za-z0-9_]*$", RegexCompileFlags.OPTIMIZE);
            } catch (RegexError e) {
                assert(false);
            }
        }

        public ScriptNode parse(string input) throws CompileError {
            var token_list = _tokenizer.tokenize(input);
            var token_queue = new TokenQueue(token_list);
            return parse_script(token_queue);
        }

        private ScriptNode parse_script(TokenQueue q) throws CompileError {
            var script = new ScriptNode() {
                source_token = q.get_current_token(),
                block = new BlockNode() {
                    source_token = q.get_current_token()
                }
            };

            while (!q.eof) {
                var node = parse_statement(q);
                if (node != null) {
                    script.block.statements.add(node);
                }
            }

            return script;
        }

        private StatementNode? parse_statement(TokenQueue q) throws CompileError {
            switch (q.peek()) {
                case ";": q.take_expected(";"); return null;
                case "declare": return parse_declare_statement(q);
                case "while": return parse_while_statement(q);
                case "break": return parse_break_statement(q);
                case "continue": return parse_continue_statement(q);
                case "print": return parse_print_statement(q);
                case "exec": case "execute": return parse_execute_statement(q);
                case "return": return parse_return_statement(q);
                case "throw": return parse_throw_statement(q);
                case "set": return parse_set_statement(q);
                case "if": return parse_if_statement(q);
                case "begin": return q.peek(1) == "try" ? parse_try_catch_statement(q) : parse_sql_statement(q);
                case "import": return parse_import_statement(q);
                case "export": return parse_export_statement(q);
                case "for": return parse_for_statement(q);
                default: return parse_sql_statement(q);
            }
        }

        private StatementNode parse_declare_statement(TokenQueue q) throws CompileError {
            var node = new DeclareAssignmentStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("declare");

            if (q.try_eat_expected("parameter")) {
                node.is_parameter = true;
            }

            parse_assignment_statement_core(q, node);

            return node;
        }

        private StatementNode parse_set_statement(TokenQueue q) throws CompileError {
            var node = new SetAssignmentStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("set");

            parse_assignment_statement_core(q, node);

            return node;
        }

        private void parse_assignment_statement_core(TokenQueue q, AssignmentStatementNode node) throws CompileError {
            node.variable_name = parse_variable_name(q);

            if (q.try_eat_expected("=")) {
                node.initial_value = parse_expression(q);
            }

            eat_semicolon(q);
        }

        private StatementNode parse_while_statement(TokenQueue q) throws CompileError {
            var node = new WhileStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("while");

            node.condition = parse_expression(q);
            node.block = parse_block(q);

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_for_statement(TokenQueue q) throws CompileError {
            var node = new ForStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("for");
            node.variable_name = parse_variable_name(q);
            q.take_expected("=");
            node.first_number = parse_expression(q);
            q.take_expected("to");
            node.last_number = parse_expression(q);

            if (q.try_eat_expected("step")) {
                node.step = parse_expression(q);
            }

            node.block = parse_block(q);

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_break_statement(TokenQueue q) throws CompileError {
            var node = new BreakStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("break");

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_continue_statement(TokenQueue q) throws CompileError {
            var node = new ContinueStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("continue");

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_print_statement(TokenQueue q) throws CompileError {
            var node = new PrintStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("print");
            node.value = parse_expression(q);

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_execute_statement(TokenQueue q) throws CompileError {
            var node = new ExecuteStatementNode() {
                source_token = q.get_current_token(),
                arguments = new ArrayList<ArgumentPairNode>()
            };

            q.take_expected_many(new string[] { "exec", "execute" });

            if (q.peek(1) == "=") {
                node.return_variable_name = parse_variable_name(q);
                q.take_expected("=");
            }

            var script_name_token_type = q.peek_token().token_kind;
            var has_script_name = script_name_token_type == TokenKind.STRING || script_name_token_type == TokenKind.ID;
            if (has_script_name) {
                node.script_name = get_unescaped_token_text(q.take().text);
            } else {
                var snippet = q.get_snippet();
                var message = @"Invalid syntax at \"$snippet\".  Expected: string, identifier";
                throw new CompileError.INVALID_SYNTAX(message);
            }

            var has_first_argument_name = is_variable_name(get_unescaped_token_text(q.peek_token().text));
            var has_first_argument_equals = q.peek(1) == "=";
            var has_arguments = has_first_argument_name && has_first_argument_equals;
            if (has_arguments) {
                while (true) {
                    var arg = new ArgumentPairNode() {
                        name = parse_variable_name(q)
                    };

                    q.take_expected("=");

                    if (q.peek() == "default") {
                        q.take();
                    } else {
                        arg.value = parse_expression(q);
                    }

                    node.arguments.add(arg);

                    if (!q.try_eat_expected(",")) {
                        break;
                    }
                }
            }

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_return_statement(TokenQueue q) throws CompileError {
            var node = new ReturnStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("return");

            if (peek_expression(q)) {
                node.value = parse_expression(q);
            }

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_throw_statement(TokenQueue q) throws CompileError {
            var node = new ThrowStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("throw");

            if (peek_expression(q)) {
                node.message = parse_expression(q);
            }

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_if_statement(TokenQueue q) throws CompileError {
            var node = new IfStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("if");

            node.condition = parse_expression(q);
            node.block = parse_block(q);

            if (q.try_eat_expected("else")) {
                node.else_block = parse_block(q);
            }

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_try_catch_statement(TokenQueue q) throws CompileError {
            var node = new TryCatchStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("begin");
            q.take_expected("try");

            node.try_block = new BlockNode() {
                source_token = q.get_current_token(),
                statements = new ArrayList<StatementNode>()
            };

            while (q.peek() != "end") {
                var try_block_statement = parse_statement(q);
                if (try_block_statement != null) {
                    node.try_block.statements.add(try_block_statement);
                }
            }

            q.take_expected("end");
            q.take_expected("try");

            q.take_expected("begin");
            q.take_expected("catch");

            node.catch_block = new BlockNode() {
                source_token = q.get_current_token(),
                statements = new ArrayList<StatementNode>()
            };

            while (q.peek() != "end") {
                var catch_block_statement = parse_statement(q);
                if (catch_block_statement != null) {
                    node.catch_block.statements.add(catch_block_statement);
                }
            }

            q.take_expected("end");
            q.take_expected("catch");

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_import_statement(TokenQueue q) throws CompileError {
            var import_type = q.peek(1);
            switch (import_type) {
                case "csv": return parse_import_csv_statement(q);
                case "txt": case "text": return parse_import_txt_statement(q);
                case "xls": case "xlsx": return parse_import_xls_statement(q);
                default: throw new CompileError.INVALID_SYNTAX(@"Unknown import type: \"$import_type\".");
            }
        }

        private StatementNode parse_import_csv_statement(TokenQueue q) throws CompileError {
            var node = new ImportCsvStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("import");
            q.take_expected("csv");
            node.file_path = parse_expression(q);
            q.take_expected("into");
            node.import_table = parse_import_table(q);
            if (q.try_eat_expected("options")) {
                node.options_list = parse_options_list(q);
            }

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_import_txt_statement(TokenQueue q) throws CompileError {
            var node = new ImportTxtStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("import");
            q.take_expected_many(new string[] { "txt", "text" });
            node.file_path = parse_expression(q);
            q.take_expected("into");
            node.table_name = parse_identifier_or_expression(q);

            if (q.try_eat_expected("(")) {
                node.line_number_column_name = parse_identifier_or_expression(q);
                q.take_expected(",");
                node.text_column_name = parse_identifier_or_expression(q);
                q.take_expected(")");
            }

            if (q.try_eat_expected("options")) {
                node.options_list = parse_options_list(q);
            }

            eat_semicolon(q);
            return node;
        }

        private StatementNode parse_import_xls_statement(TokenQueue q) throws CompileError {
            var node = new ImportXlsStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("import");
            q.take_expected_many(new string[] { "xls", "xlsx" });
            node.file_path = parse_expression(q);

            if (q.try_eat_expected("worksheet")) {
                node.which_sheet = parse_expression(q);
            }

            q.take_expected("into");

            node.import_table = parse_import_table(q);
            if (q.try_eat_expected("options")) {
                node.options_list = parse_options_list(q);
            }

            eat_semicolon(q);
            return node;
        }

        private ImportTableNode parse_import_table(TokenQueue q) throws CompileError {
            var node = new ImportTableNode() {
                source_token = q.get_current_token()
            };

            node.table_name = parse_identifier_or_expression(q);

            node.import_columns = new ArrayList<ImportColumnNode>();
            if (q.try_eat_expected("(")) {
                do {
                    var import_column = parse_import_column(q);
                    node.import_columns.add(import_column);
                } while (q.try_eat_expected(","));

                q.take_expected(")");
            }

            return node;
        }

        private ImportColumnNode parse_import_column(TokenQueue q) throws CompileError {
            var node = new ImportColumnNode() {
                source_token = q.get_current_token()
            };

            node.column_name = parse_identifier_or_expression(q);

            if (q.try_eat_expected("as")) {
                node.alias = parse_identifier_or_expression(q);
            }

            switch (q.peek()) {
                case "text":
                    q.take();
                    node.type_conversion = TypeConversion.TEXT;
                    break;

                case "integer":
                    q.take();
                    node.type_conversion = TypeConversion.INTEGER;
                    break;

                case "real":
                    q.take();
                    node.type_conversion = TypeConversion.REAL;
                    break;

                case "date":
                    q.take();
                    node.type_conversion = TypeConversion.DATE;
                    break;

                case "datetime":
                    q.take();
                    node.type_conversion = TypeConversion.DATETIME;
                    break;

                case "datetimeoffset":
                    q.take();
                    node.type_conversion = TypeConversion.DATETIMEOFFSET;
                    break;
            }

            return node;
        }

        private StatementNode parse_export_statement(TokenQueue q) throws CompileError {
            var export_type = q.peek(1);
            switch (export_type) {
                case "txt": case "text": return parse_export_txt_statement(q);
                default: throw new CompileError.INVALID_SYNTAX(@"Unknown export type: \"$export_type\".");
            }
        }

        private StatementNode parse_export_txt_statement(TokenQueue q) throws CompileError {
            var node = new ExportTxtStatementNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("export");
            q.take_expected_many(new string[] { "txt", "text" });
            node.file_path = parse_expression(q);
            q.take_expected("from");
            q.take_expected("(");
            node.select_statement = parse_sql_statement(q, "select-stmt");
            q.take_expected(")");

            if (q.try_eat_expected("options")) {
                node.options_list = parse_options_list(q);
            }

            eat_semicolon(q);
            return node;
        }

        private OptionsListNode parse_options_list(TokenQueue q) throws CompileError {
            var node = new OptionsListNode() {
                source_token = q.get_current_token()
            };

            q.take_expected("(");

            node.options = new HashMap<string, ExpressionNode>();
            do {
                var key = parse_identifier(q).down();
                q.take_expected(":");
                var value = parse_expression(q);
                node.options.set(key, value);
            } while (q.try_eat_expected(","));

            q.take_expected(")");

            return node;
        }

        private SqlStatementNode parse_sql_statement(TokenQueue q, string root_prod_name = "sql-stmt") throws CompileError {
            var start = q.current_token_index;
            var tok = q.get_current_token();

            SqliteSyntaxProductionNode syntax_node;
            var result = _sqlite_parser.read(q, root_prod_name, out syntax_node);
            if (result.is_valid) {
                var node = new SqlStatementNode() {
                    source_token = tok,
                    sql = q.substring(start, result.num_valid_tokens),
                    sqlite_syntax = syntax_node,
                    pre_statements = new ArrayList<StatementNode>(),
                    post_statements = new ArrayList<StatementNode>()
                };
                // TODO: call macro preprocessor here
                return node;
            } else if (result.invalid_message != null) {
                throw new CompileError.INVALID_SYNTAX(result.invalid_message);
            } else {
                var snippet = q.get_snippet();
                var message = @"Invalid syntax at \"$snippet\".";
                throw new CompileError.INVALID_SYNTAX(message);
            }
        }

        private ExpressionNode parse_expression(TokenQueue q) throws CompileError {
            var start = q.current_token_index;
            var tok = q.get_current_token();

            SqliteSyntaxProductionNode syntax_node;
            var result = _sqlite_parser.read_expression(q, out syntax_node);
            if (result.is_valid) {
                var node = new ExpressionNode() {
                    source_token = tok,
                    sql = q.substring(start, result.num_valid_tokens),
                    sqlite_syntax = syntax_node
                };
                return node;
            } else if (result.invalid_message != null) {
                throw new CompileError.INVALID_SYNTAX(result.invalid_message);
            } else {
                var snippet = q.get_snippet();
                var message = @"Invalid syntax at \"$snippet\".";
                throw new CompileError.INVALID_SYNTAX(message);
            }
        }

        private BlockNode parse_block(TokenQueue q) throws CompileError {
            var node = new BlockNode() {
                source_token = q.get_current_token(),
                statements = new ArrayList<StatementNode>()
            };

            if (q.try_eat_expected("begin")) {
                while (q.peek() != "end") {
                    var block_statement = parse_statement(q);
                    if (block_statement != null) {
                        node.statements.add(block_statement);
                    }
                }
                q.take_expected("end");
            } else {
                var block_statement = parse_statement(q);
                if (block_statement != null) {
                    node.statements.add(block_statement);
                }
            }

            return node;
        }

        private string parse_identifier(TokenQueue q) throws CompileError {
            if (q.peek_token().token_kind == TokenKind.ID) {
                return get_unescaped_token_text(q.take().text);
            } else {
                var snippet = q.get_snippet();
                var message = @"Expected identifier at \"$snippet\".";
                throw new CompileError.INVALID_SYNTAX(message);
            }
        }

        private IdentifierOrExpressionNode parse_identifier_or_expression(TokenQueue q) throws CompileError {
            var node = new IdentifierOrExpressionNode() {
                source_token = q.get_current_token()
            };

            var kind = q.peek_token().token_kind;
            if (kind == TokenKind.ID) {
                var token = q.take();
                node.identifier = get_unescaped_token_text(token.text);
            } else if (peek_expression(q)) {
                node.expression = parse_expression(q);
            } else {
                var snippet = q.get_snippet();
                var message = @"Expected identifier or expression at \"$snippet\".";
                throw new CompileError.INVALID_SYNTAX(message);
            }

            return node;
        }

        private string parse_variable_name(TokenQueue q) throws CompileError {
            var token = q.peek_token();
            var name = get_unescaped_token_text(token.text);
            if (token.token_kind == TokenKind.VARIABLE && is_variable_name(name)) {
                q.take();
                return name;
            } else {
                var snippet = q.get_snippet();
                var message = @"Expected variable name starting with @ $$ : at \"$snippet\".";
                throw new CompileError.INVALID_SYNTAX(message);
            }
        }

        private bool is_variable_name(string token_text) {
            return _variable_name_regex.match(token_text);
        }

        private string get_unescaped_token_text(string token_text) {
            if (token_text.length < 2) {
                return token_text;
            }

            var first = token_text.get(0);
            var last = token_text.get(token_text.length - 1);

            if (first == '"' && last == '"') {
                return token_text.substring(1, token_text.length - 2).replace("\"\"", "\"");
            } else if (first == '\'' && last == '\'') {
                return token_text.substring(1, token_text.length - 2).replace("''", "'");
            } else if (first == '`' && last == '`') {
                return token_text.substring(1, token_text.length - 2).replace("``", "`");
            } else if (first == '[' && last == ']') {
                return token_text.substring(1, token_text.length - 2).replace("]]", "]");
            } else {
                return token_text;
            }
        }

        private void eat_semicolon(TokenQueue q) {
            q.try_eat_expected(";");
        }

        private bool peek_expression(TokenQueue q) {
            var start = q.current_token_index;
            SqliteSyntaxProductionNode ast;
            var result = _sqlite_parser.read_expression(q, out ast);
            q.jump(start);
            return result.is_valid;
        }
    }
}
