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
    public class TokenSetTerm : SpecTerm {
        private bool[] _bitmap = new bool[200];

        public ArrayList<TokenKind> token_kinds { get; private set; }

        public TokenSetTerm(ArrayList<TokenKind> token_kinds) {
            foreach (var token_kind in token_kinds) {
                _bitmap[(int)token_kind] = true;
            }
            this.token_kinds = token_kinds;
        }

        public override string get_expected() {
            var list = StringUtil.join_strings("|", token_kinds.map<string>(x => x.to_string()));
            return @"($list)";
        }

        public override MatchResult? match_step(MatchStack stack, MatchFrame frame, TokenQueue q) {
            var index = (int)q.take().token_kind;
            var match = index >= 0 && index < _bitmap.length && _bitmap[index];
            return match ? MatchResult.for_match() : MatchResult.for_no_match();
        }
    }
}
