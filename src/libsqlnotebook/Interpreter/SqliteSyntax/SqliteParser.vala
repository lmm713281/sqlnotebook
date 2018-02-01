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

using SqlNotebook.Interpreter.Ast;
using SqlNotebook.Interpreter.Tokens;

namespace SqlNotebook.Interpreter.SqliteSyntax {
    public class SqliteParser : Object {
        private SqliteGrammar _grammar;

        public SqliteParser(SqliteGrammar grammar) {
            _grammar = grammar;
        }

        public SqliteParserResult read_expression(TokenQueue q, out SqliteSyntaxProductionNode ast) {
            return read(q, "expr", out ast);
        }

        public SqliteParserResult read_sql_statement(TokenQueue q, out SqliteSyntaxProductionNode ast) {
            return read(q, "sql-stmt")
        }

        private SqliteParserResult read(TokenQueue q, string rood_prod_name, out SqliteSyntaxProductionNode ast) {
            var starting_location = q.current_token_index;
            var match_result = match(q, root_prod_name, out ast);
            var num_valid_tokens = q.current_token_index - starting_location;
            if (match_result.is_match) {
                return SqliteParserResult.for_valid(num_valid_tokens);
            } else {
                var error_message = match_result.error_message ?? "Not a statement";
                return SqliteParserResult.for_invalid(error_message, num_valid_tokens);
            }
        }

        private MatchResult match(TokenQueue q, string rood_prod_name, out SqliteSyntaxProductionNode ast) {
            // we use an explicit stack rather than function call recursion because our BNF grammar is deeply nested,
            // particularly the productions for 'expr'.
            var stack = new MatchStack(q);
            stack.push(_grammar.prods.@get(root_prod_name));

            // trampoline loop
            
        }
    }
}
