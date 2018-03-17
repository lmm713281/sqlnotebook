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
    public class OrTerm : SpecTerm {
        public ArrayList<SpecProd> prods { get; set; }

        public override string get_expected() {
            var prod_strings = prods.map<string>(x => "(" + x.get_expected() + ")");
            return StringUtil.join_strings(" | ", prod_strings);
        }

        public override MatchResult? match_step(MatchStack stack, MatchFrame frame, TokenQueue q,
                SqliteGrammar grammar) {
            if (frame.or_state == OrTermState.START) {
                // try to match the first sub-production
                stack.push(prods[0]);
                frame.or_state = OrTermState.MATCH;
                frame.or_prod_index = 0;
                frame.or_start_loc = q.current_token_index;
                return null;
            } else { // MATCH
                // we have finished matching one of the productions.  if it matched, then we're done.  if not, move on
                // to the next production.
                var result = frame.sub_result;
                if (result.is_match) {
                    return MatchResult.for_match();
                } else if (result.error_message == null) {
                    // no match.  rewind to the beginning and retry with the next one.
                    q.jump(frame.or_start_loc);
                    frame.or_prod_index++;
                    if (frame.or_prod_index >= prods.size) {
                        // we have exhausted all of the possibilities and none of them matched.
                        return MatchResult.for_no_match();
                    }
                    stack.push(prods[frame.or_prod_index]);
                    return null;
                } else {
                    // started to match but mismatched past the point of no return.
                    return result;
                }
            }
        }
    }
}
