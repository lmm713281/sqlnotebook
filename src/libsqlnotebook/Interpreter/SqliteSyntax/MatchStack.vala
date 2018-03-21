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
using SqlNotebook.Interpreter.Ast;
using SqlNotebook.Interpreter.Tokens;

namespace SqlNotebook.Interpreter.SqliteSyntax {
    public class MatchStack {
        private ArrayList<MatchFrame> _frames = new ArrayList<MatchFrame>();
        private int _top_index = -1; // zero-based index of the top frame, -1 if the stack is empty

        public int count {
            get {
                return _top_index + 1;
            }
        }

        public TokenQueue token_queue { get; private set; }

        public MatchStack(TokenQueue token_queue) {
            this.token_queue = token_queue;
        }

        public bool any() {
            return _top_index >= 0;
        }

        public MatchFrame push(SpecProd prod) {
            _top_index++;

            if (_top_index == _frames.size) {
                _frames.add(new MatchFrame());
            }

            var frame = _frames[_top_index];
            frame.prod = prod;
            frame.prod_start_loc = token_queue.current_token_index;
            frame.ast_prod = new SqliteSyntaxProductionNode() {
                name = prod.name
            };
            assert(frame.ast_prod.items != null);
            return frame;
        }

        public bool pop() {
            if (_top_index == -1) {
                return false;
            }

            _frames[_top_index].clear();
            _top_index--;
            return true;
        }

        public MatchFrame? peek() {
            return _top_index < 0 ? null : _frames[_top_index];
        }
    }
}
