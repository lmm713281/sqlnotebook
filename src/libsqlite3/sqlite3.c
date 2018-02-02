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

#ifdef __cplusplus
#error This file should be compiled as C.
#endif

#define SQLITE_ENABLE_FTS5 1
#define SQLITE_ENABLE_API_ARMOR 1
#define SQLITE_SOUNDEX 1
#define SQLITE_ENABLE_JSON1 1
#define SQLITE_ENABLE_DBSTAT_VTAB 1
#define SQLITE_DEFAULT_FOREIGN_KEYS 1
#define SQLITE_THREADSAFE 2
#define SQLITE_OMIT_TCL_VARIABLE 1
#include "../../ext/sqlite/sqlite3.c"

static char * s_text;
static int s_len;
static int s_token_type;
static int s_old_pos;
static int s_pos;

void sqlite3_tokenizer_start(const char * z) {
    s_text = strdup(z);
    s_len = strlen(z);
    s_token_type = 0;
    s_old_pos = 0;
    s_pos = 0;
}

int sqlite3_tokenizer_next() {
    int token_type = TK_SPACE;

    while (token_type == TK_SPACE && s_pos < s_len) {
        int token_len = sqlite3GetToken((const unsigned char *)&s_text[s_pos], &token_type);
        s_old_pos = s_pos;
        s_pos += token_len;
    }

    s_token_type = token_type == TK_SPACE ? 0 : token_type;
    return s_token_type;
}

int sqlite3_tokenizer_get_token_type() {
    return s_token_type;
}

int sqlite3_tokenizer_get_token_char_offset() {
    return s_old_pos;
}

int sqlite3_tokenizer_get_token_char_length() {
    return s_pos - s_old_pos;
}

void sqlite3_tokenizer_end() {
    free(s_text);
    s_text = NULL;
    s_len = 0;
    s_token_type = 0;
    s_old_pos = 0;
    s_pos = 0;
}
