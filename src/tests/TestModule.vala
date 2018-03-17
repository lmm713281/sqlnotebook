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

namespace SqlNotebook.Tests {
    public abstract class TestModule : Object {
        public abstract void go() throws Error;

        protected static void fail(string message) {
            Test.message("%s", message);
            Test.fail();
        }

        protected static bool assert_true(bool actual, string description) {
            if (actual == true) {
                return true;
            } else {
                fail(@"$description, actual=false, expected=true");
                return false;
            }
        }

        protected static bool assert_false(bool actual, string description) {
            if (actual == false) {
                return true;
            } else {
                fail(@"$description, actual=true, expected=false");
                return false;
            }
        }

        protected static bool assert_eq_int(int actual, int expected, string description) {
            if (actual == expected) {
                return true;
            } else {
                fail(@"$description, actual=$actual, expected=$expected");
                return false;
            }
        }
    }
}
