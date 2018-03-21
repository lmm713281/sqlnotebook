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

namespace SqlNotebook.Tests {
    public class Test_TokenQueue : TestModule {
        private TokenQueue _target;

        public override string get_name() {
            return "TokenQueue";
        }

        public override void test_pre() throws Error {
            var tokens = new ArrayList<Token>();
            tokens.add(Token.for_token(TokenKind.SELECT, "SELECT", 0, 6));
            tokens.add(Token.for_token(TokenKind.STAR, "*", 7, 1));
            tokens.add(Token.for_token(TokenKind.FROM, "FROM", 9, 4));
            _target = new TokenQueue(tokens);
        }

        public override void test_post() {
            _target = null;
        }

        public override void go() {
            test("substring", () => {
                assert_eq_string(_target.substring(0, 1), "SELECT", "substring(0, 1)");
                assert_eq_string(_target.substring(1, 1), "*", "substring(1, 1)");
                assert_eq_string(_target.substring(2, 1), "FROM", "substring(2, 1)");
                assert_eq_string(_target.substring(1, 3), "* FROM", "substring(1, 3)");
                assert_eq_string(_target.substring(0, 3), "SELECT * FROM", "substring(0, 3)");
                assert_eq_string(_target.substring(3, 1), "", "substring(3, 1)");

                _target.take(); // should not impact the substring results

                assert_eq_string(_target.substring(0, 1), "SELECT", "substring(0, 1)");
                assert_eq_string(_target.substring(1, 1), "*", "substring(1, 1)");
                assert_eq_string(_target.substring(2, 1), "FROM", "substring(2, 1)");
                assert_eq_string(_target.substring(1, 3), "* FROM", "substring(1, 3)");
                assert_eq_string(_target.substring(0, 3), "SELECT * FROM", "substring(0, 3)");
                assert_eq_string(_target.substring(3, 1), "", "substring(3, 1)");
            });
        }
    }
}
