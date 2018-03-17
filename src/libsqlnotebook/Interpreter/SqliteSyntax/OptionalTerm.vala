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

using SqlNotebook.Interpreter.Tokens;

namespace SqlNotebook.Interpreter.SqliteSyntax {
    public class OptionalTerm : SpecTerm {
        public SpecProd prod { get; set; }

        public override string get_expected() {
            var x = prod.get_expected();
            return @"[ $x ]";
        }

        public override MatchResult? match_step(MatchStack stack, MatchFrame frame, TokenQueue q,
                SqliteGrammar grammar) {
            if (frame.optional_state == OptionalTermState.START) {
                // try to match the sub-production
                stack.push(prod);
                frame.optional_state = OptionalTermState.MATCH;
                frame.optional_start_loc = q.current_token_index;
                return null;
            } else { // MATCH
                // done matching the sub-production
                var result = frame.sub_result;
                if (result.is_match) {
                    // the optional term is indeed present.
                    return MatchResult.for_match();
                } else if (result.error_message == null) {
                    // it didn't match but wasn't an error.  this is fine, but we do have to walk the cursor back to
                    // where it started since we effectively "matched" zero tokens.
                    q.jump(frame.optional_start_loc);
                    return MatchResult.for_match();
                } else {
                    // it started to match but then mismatched past the point of no return.  that's an error.
                    return result;
                }
            }
        }
    }
}
