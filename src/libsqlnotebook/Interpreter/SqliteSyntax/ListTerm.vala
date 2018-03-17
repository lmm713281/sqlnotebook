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
    public class ListTerm : SpecTerm {
        public int min { get; set; }
        public SpecProd item_prod { get; set; }
        public SpecProd? separator_prod { get; set; }

        public override string get_expected() {
            var sb = new StringBuilder();
            if (min > 0) {
                sb.append(item_prod.get_expected());
                sb.append(" ");
            }
            sb.append("[ ");
            if (separator_prod != null) {
                sb.append(separator_prod.get_expected());
                sb.append(" ");
            }
            sb.append(item_prod.get_expected());
            sb.append(" ]*");
            return sb.str;
        }

        public override MatchResult? match_step(MatchStack stack, MatchFrame frame, TokenQueue q,
                SqliteGrammar grammar) {
            if (frame.list_state == ListTermState.START) {
                frame.list_state = ListTermState.MATCH_ITEM;
                stack.push(item_prod);
                return null; // -> MatchItem
            } else if (frame.list_state == ListTermState.MATCH_SEPARATOR) {
                var result = frame.sub_result;
                if (result.is_match) {
                    // we have a separator.  now try to match the item following it.
                    frame.list_state = ListTermState.MATCH_ITEM;
                    stack.push(item_prod);
                    return null; // -> MatchItem
                } else if (result.error_message == null) {
                    // we didn't find a separator.  this list is done.  back up to the beginning of where
                    // the not-separator started and we're done.
                    q.jump(frame.list_separator_start_loc);
                    if (frame.list_count < min) {
                        var count = frame.list_count;
                        var expected = item_prod.get_expected();
                        var message = @"$min+ list items required, but only $count provided. Expected: $expected";
                        return MatchResult.for_error(message);
                    } else {
                        return MatchResult.for_match();
                    }
                } else {
                    return result; // error
                }
            } else { // MATCH_ITEM
                var result = frame.sub_result;
                if (result.is_match) {
                    // we have an item.  is there another?
                    frame.list_count++;
                    if (separator_prod == null) {
                        // there is no separator, so match the next item
                        frame.list_state = ListTermState.MATCH_ITEM;
                        frame.list_separator_start_loc = q.current_token_index;
                        stack.push(item_prod);
                        return null; // -> MATCH_ITEM
                    } else {
                        // match separator + item
                        frame.list_state = ListTermState.MATCH_SEPARATOR;
                        frame.list_separator_start_loc = q.current_token_index;
                        stack.push(separator_prod);
                        return null; // -> MATCH_SEPARATOR
                    }
                } else if (result.error_message == null) {
                    if (frame.list_count == 0) {
                        // the first item might be missing because the list can potentially be optional.
                        return min == 0 ? MatchResult.for_match() : MatchResult.for_no_match();
                    } else if (separator_prod == null) {
                        // there's no separator, so eventually we'll end up here when the list ends.
                        q.jump(frame.list_separator_start_loc);
                        if (frame.list_count < min) {
                            var count = frame.list_count;
                            var expected = item_prod.get_expected();
                            var message = @"$min+ list items required, but only $count provided. Expected: $expected";
                            return MatchResult.for_error(message);
                        } else {
                            return MatchResult.for_match();
                        }
                    } else {
                        // subsequent items must be present because, in the MatchItem state, we've already consumed a
                        // separator so there must be an item following it.
                        var expected = item_prod.get_expected();
                        return MatchResult.for_error(@"Expected list item: $expected");
                    }
                } else {
                    return result; // error
                }
            }
        }
    }
}
