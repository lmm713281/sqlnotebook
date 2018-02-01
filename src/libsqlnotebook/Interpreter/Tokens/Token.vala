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

using SqlNotebook.Utils;

namespace SqlNotebook.Interpreter.Tokens {
    public class Token : Object {
        public TokenKind token_kind { get; set; }
        public string text { get; set; }
        public uint64 span_offset { get; set; }
        public uint64 span_length { get; set; }

        public static Token for_token(TokenKind token_kind, string text, uint64 span_offset, uint64 span_length) {
            var token = new Token();
            token.token_kind = token_kind;
            token.text = text;
            token.span_offset = span_offset;
            token.span_length = span_length;
            return token;
        }

        public static Token for_eof(uint64 span_offset) {
            return for_token(TokenKind.END_OF_FILE, "", span_offset, 0);
        }

        public string to_string() {
            return @"$token_kind: $text";
        }
    }
}
