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
    public class KeyTokenTerm : SpecTerm {
        public TokenKind token_kind;

        public override string get_expected() {
            switch (token_kind) {
                case TokenKind.SEMI: return ";";
                case TokenKind.LP: return "(";
                case TokenKind.RP: return ")";
                case TokenKind.COMMA: return ",";
                case TokenKind.NE: return "!=";
                case TokenKind.EQ: return "=";
                case TokenKind.GT: return ">";
                case TokenKind.LE: return "<=";
                case TokenKind.LT: return "<";
                case TokenKind.GE: return ">=";
                case TokenKind.PLUS: return "+";
                case TokenKind.MINUS: return "-";
                case TokenKind.STAR: return "*";
                case TokenKind.SLASH: return "/";
                case TokenKind.DOT: return ".";
                case TokenKind.UMINUS: return "-";
                case TokenKind.UPLUS: return "+";
                case TokenKind.ASTERISK: return "*";
                default: return token_kind.to_string();
            }
        }

        public override MatchResult? match_step(MatchStack stack, MatchFrame frame, TokenQueue q,
                SqliteGrammar grammar) {
            return q.take().token_kind == token_kind ? MatchResult.for_match() : MatchResult.for_no_match();
        }
    }
}
