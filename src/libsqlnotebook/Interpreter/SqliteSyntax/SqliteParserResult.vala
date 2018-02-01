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

namespace SqlNotebook.Interpreter.SqliteSyntax {
    public class SqliteParserResult : Object {
        public bool is_valid { get; set; }
        public int num_valid_tokens { get; set; }

        // if invalid
        public string? invalid_message { get; set; }

        public static SqliteParserResult for_valid(int num_valid_tokens) {
            var x = new SqliteParserResult() {
                is_valid = true,
                num_valid_tokens = num_valid_tokens
            };
            return x;
        }

        public static SqliteParserResult for_invalid(string message, int num_valid_tokens) {
            var x = new SqliteParserResult() {
                is_valid = false,
                num_valid_tokens = num_valid_tokens,
                invalid_message = message
            };
            return x;
        }
    }
}
