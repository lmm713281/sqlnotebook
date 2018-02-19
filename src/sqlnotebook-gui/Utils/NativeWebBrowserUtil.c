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
#include "NativeWebBrowserUtil.h"

/* 1 = browser was opened, 0 = did not open browser */
int open_web_browser(const char* url) {
#ifdef _WIN32
    LPTSTR url_utf16 = NULL;
    HINSTANCE shell_execute_result = 0;

    url_utf16 = utf8_to_utf16(url);

    shell_execute_result = ShellExecute(
            /* hwnd */ NULL,
            /* lpOperation */ L"open",
            /* lpFile */ url_utf16,
            /* lpParameters */ NULL,
            /* lpDirectory */ NULL,
            /* nShowCmd */ SW_SHOW);

    free(url_utf16);

    /* this pointer-to-int cast is blessed, and indeed mandated, by the MSDN ShellExecute doc */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
    return (int)shell_execute_result > 32;
#pragma GCC diagnostic pop

#else
    /* fall back to GTK method to open uri */
    return 0;
#endif
}
