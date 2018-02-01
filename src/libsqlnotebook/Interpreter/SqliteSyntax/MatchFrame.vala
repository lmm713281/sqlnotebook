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

namespace SqlNotebook.Interpreter.SqliteSyntax {
    public class MatchFrame {
        // which production and term are we working on?
        public int prod_start_loc;
        public SpecProd? prod;
        public int term_index;
        public SqliteSyntaxProductionNode? ast_prod;

        // OptionalTerm
        public OptionalTermState optional_state;
        public int optional_start_loc;

        // OrTerm
        public OrTermState or_state;
        public int or_prod_index;
        public int or_start_loc;

        // ProdTerm
        public bool prod_matched;

        // ListTerm
        public ListTermState list_state;
        public int list_count;
        public int list_separator_start_loc; // set before transitioning into MATCH_SEPARATOR state

        // when a sub-frame returns, the result goes here
        public MatchResult? sub_result;

        public void clear(bool all = true) {
            if (all) {
                prod_start_loc = 0;
                prod = null;
                term_index = 0;
                ast_prod = null;
            }
            optional_state = OptionalTermState.START;
            optional_start_loc = 0;
            or_state = OrTermState.START;
            or_prod_index = 0;
            or_start_loc = 0;
            prod_matched = false;
            list_state = ListTermState.START;
            list_count = 0;
            list_separator_start_loc = 0;
            sub_result = null;
        }

        public string to_string() {
            if (prod != null) {
                return prod.get_expected();
            } else {
                return "(unused)";
            }
        }
    }
}
