// result = ("%" + int64.FORMAT_MODIFIER).printf(data_value.integer_value);
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
using SqlNotebook;
using SqlNotebook.Collections;
using SqlNotebook.Interpreter;
using SqlNotebook.Utils;

namespace SqlNotebook.Tests {
    /**
     * Tests for things which are not part of SQL Notebook, but we want to verify how they work.
     */
    public class Test_Sanity : TestModule {
        public override string get_name() {
            return "Sanity";
        }

        public override void go() {
            test("string.printf1", () => {
                int64 a = 1;
                var actual = ("%" + int64.FORMAT_MODIFIER + "d").printf(a);
                assert_eq_string(actual, "1", "string");
            });
        }
    }
}
