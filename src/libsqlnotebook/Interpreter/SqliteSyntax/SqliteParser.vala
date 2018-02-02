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
            return read(q, "sql-stmt", out ast);
        }

        private SqliteParserResult read(TokenQueue q, string root_prod_name, out SqliteSyntaxProductionNode ast) {
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

        private MatchResult match(TokenQueue q, string root_prod_name, out SqliteSyntaxProductionNode? ast) {
            // we use an explicit stack rather than function call recursion because our BNF grammar is deeply nested,
            // particularly the productions for 'expr'.
            var stack = new MatchStack(q);
            stack.push(_grammar.prods.@get(root_prod_name));
            MatchResult? root_result = null;
            SqliteSyntaxProductionNode? root_ast = null;

            // trampoline loop
            while (root_result == null && stack.any()) {
                var frame = stack.peek();
                var result = frame.prod.terms[frame.term_index].match_step(stack, frame, q);
                if (result != null) {
                    // we are done matching this term
                    if (result.is_match) {
                        // move to the next term in the production.
                        frame.clear(false);
                        frame.term_index++;
                        if (frame.term_index >= frame.prod.terms.size) {
                            // we have matched this full production
                            var prod_end_loc = q.current_token_index;
                            frame.ast_prod.token_span_start_index = frame.prod_start_loc;
                            frame.ast_prod.token_span_length = prod_end_loc - frame.prod_start_loc;
                            frame.ast_prod.text = q.substring(frame.prod_start_loc, prod_end_loc - frame.prod_start_loc);
                            match_internal_finish_frame(stack, MatchResult.for_match(), frame.ast_prod, ref root_result, ref root_ast);
                        }
                    } else {
                        // we needed a match and didn't find one.  we have to abandon this production.
                        match_internal_finish_frame(stack, MatchResult.for_no_match(), null, ref root_result, ref root_ast);
                    }
                }
            }

            ast = root_ast;
            assert(root_result != null);
            return root_result;
        }

        private void match_internal_finish_frame(MatchStack stack, MatchResult frame_result,
                SqliteSyntaxProductionNode? frame_ast_prod, ref MatchResult? root_result,
                ref SqliteSyntaxProductionNode? root_ast) {
            stack.pop();
            var parent_frame = stack.peek();
            if (parent_frame == null) {
                root_result = frame_result;
                root_ast = frame_ast_prod;
            } else {
                parent_frame.sub_result = frame_result;
                if (frame_result.is_match) {
                    parent_frame.ast_prod.items.add(frame_ast_prod);
                }
            }
        }
    }
}
