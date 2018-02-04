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
using SqlNotebook.Errors;
using SqlNotebook.Interpreter.Tokens;
using SqlNotebook.Utils;

namespace SqlNotebook.Interpreter.Tokens {
    public class TokenQueue : Object {
        private const int SNIPPET_MAX_TOKEN_COUNT = 5;

        private ArrayList<Token> _tokens;
        private int _peek_index;
        private Token _eof_token;

        public TokenQueue(ArrayList<Token> tokens) {
            _tokens = tokens;
            _peek_index = 0;

            uint64 eof_offset;
            if (tokens.size > 0) {
                var last_token = tokens.last();
                eof_offset = last_token.span_offset + last_token.span_length;
            } else {
                eof_offset = 0;
            }

            _eof_token = Token.for_eof(eof_offset);
        }

        public Token get_current_token() {
            return peek_token(0);
        }

        public int current_token_index {
            get {
                return _peek_index;
            }
        }

        public bool eof {
            get {
                return _peek_index >= _tokens.size;
            }
        }

        public Token peek_token(int skip = 0) {
            var n = _peek_index + skip;
            return n < _tokens.size ? _tokens[n] : _eof_token;
        }

        public string peek(int skip = 0) {
            return peek_token(skip).text.down();
        }

        public void jump(int token_index) {
            _peek_index = token_index;
        }

        public Token take() {
            if (_peek_index < _tokens.size) {
                return _tokens[_peek_index++];
            } else {
                return _eof_token;
            }
        }

        public Token take_expected(string expected_text) throws CompileError {
            var text = get_current_token().text;
            var lowercase_text = text.down();

            if (expected_text.down() == lowercase_text) {
                return take();
            }

            throw get_unexpected_token_error(text, new string[] { expected_text });
        }

        public Token take_expected_many(string[] expected_texts) throws CompileError {
            var text = get_current_token().text;
            var lowercase_text = text.down();

            foreach (var expected_text in expected_texts) {
                if (expected_text.down() == lowercase_text) {
                    return take();
                }
            }

            throw get_unexpected_token_error(text, expected_texts);
        }

        private CompileError get_unexpected_token_error(string unexpected_text, string[] expected_texts) {
            var expected_texts_list = ArrayUtil.to_list(expected_texts);
            var expected_texts_str = StringUtil.join_strings(", ", expected_texts_list);
            var message = @"Token \"$unexpected_text\" was unexpected.  Expected: $expected_texts_str";
            return new CompileError.UNEXPECTED_TOKEN(message);
        }

        public bool try_eat_expected(string expected_text) {
            var text = get_current_token().text;
            var lowercase_text = text.down();

            if (expected_text.down() == lowercase_text) {
                take();
                return true;
            }

            return false;
        }

        public bool try_eat_expected_many(string[] expected_texts) {
            var text = get_current_token().text;
            var lowercase_text = text.down();

            foreach (var expected_text in expected_texts) {
                if (expected_text.down() == lowercase_text) {
                    take();
                    return true;
                }
            }

            return false;
        }

        public string to_string() {
            return StringUtil.join_strings(" ", _tokens.map<string>(x => x.text).chop(_peek_index));
        }

        public Traversable<Token> get_remaining_tokens() {
            return _tokens.chop(_peek_index);
        }

        // get some (not all) tokens at the current cursor location
        public string get_snippet() {
            return substring(_peek_index, SNIPPET_MAX_TOKEN_COUNT);
        }

        public string substring(int start_token_index, int max_tokens) {
            var token_texts =
                _tokens
                .chop(_peek_index, max_tokens)
                .map<string>(x => x.text);
            return StringUtil.join_strings(" ", token_texts);
        }
    }
}
