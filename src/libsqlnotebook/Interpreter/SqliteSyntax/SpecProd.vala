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
using SqlNotebook.Interpreter.Tokens;
using SqlNotebook.Utils;

namespace SqlNotebook.Interpreter.SqliteSyntax {
    public class SpecProd : Object {
        public string? name { get; set; }

        // number of terms that must be present for the production to be chosen.  if further input terms
        // don't match the production, then it's an error rather than just not matching this production.
        public int num_required_terms { get; set; }

        public ArrayList<SpecTerm> terms { get; set; }

        public SpecProd(string? name, int num_required_terms, ArrayList<SpecTerm> terms) {
            this.name = name;
            this.num_required_terms = num_required_terms;
            this.terms = terms;
        }

        public string get_expected() {
            return StringUtil.join_strings(" ", terms.map<string>(x => x.get_expected()));
        }
    }
}
