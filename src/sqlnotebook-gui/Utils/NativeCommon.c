/* SQL Notebook
 * Copyright (C) 2018 Brian Luft
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include "NativeCommon.h"

#ifdef _WIN32
LPWSTR utf8_to_utf16(const char* utf8) {
    int utf16_length = 0;
    LPWSTR utf16 = NULL;

    utf16_length = MultiByteToWideChar(
            /* CodePage */ CP_UTF8,
            /* dwFlags */ MB_PRECOMPOSED,
            /* lpMultiByteStr */ utf8,
            /* cbMultiByte */ -1,
            /* lpWideCharStr */ NULL,
            /* cchWideChar */ 0);

    utf16 = calloc(utf16_length + 1, sizeof(WCHAR));

    MultiByteToWideChar(
            /* CodePage */ CP_UTF8,
            /* dwFlags */ MB_PRECOMPOSED,
            /* lpMultiByteStr */ utf8,
            /* cbMultiByte */ -1,
            /* lpWideCharStr */ utf16,
            /* cchWideChar */ utf16_length);

    return utf16;
}

char* utf16_to_utf8(LPCWSTR utf16) {
    int utf8_length = 0;
    char* utf8 = NULL;

    utf8_length = WideCharToMultiByte(
            /* CodePage */ CP_UTF8,
            /* dwFlags */ 0,
            /* lpWideCharStr */ utf16,
            /* cchWideChar */ -1,
            /* lpMultiByteStr */ NULL,
            /* cbMultiByte */ 0,
            /* lpDefaultChar */ NULL,
            /* lpUsedDefaultChar*/ NULL);

    utf8 = calloc(utf8_length + 1, sizeof(char));

    WideCharToMultiByte(
            /* CodePage */ CP_UTF8,
            /* dwFlags */ 0,
            /* lpWideCharStr */ utf16,
            /* cchWideChar */ -1,
            /* lpMultiByteStr */ utf8,
            /* cbMultiByte */ utf8_length,
            /* lpDefaultChar */ NULL,
            /* lpUsedDefaultChar*/ NULL);

    return utf8;
}

#endif
