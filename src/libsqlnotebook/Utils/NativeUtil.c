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

#ifdef _WIN32
    #include <windows.h>
    #ifndef UNICODE
        #error Must be built with Unicode enabled.
    #endif
#else
    #include <errno.h>
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <signal.h>
#endif

#include "NativeUtil.h"

#ifdef _WIN32
static LPTSTR utf8_to_utf16(const char* utf8) {
    int utf16_length = 0;
    WCHAR* utf16 = NULL;

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

#endif

/* 1 = success, 0 = failure */
int create_directory(const char* path) {
#ifdef _WIN32
    WCHAR* utf16_path = NULL;
    BOOL create_directory_result;

    utf16_path = utf8_to_utf16(path);
    create_directory_result = CreateDirectory(utf16_path, NULL);
    free(utf16_path);

    return create_directory_result == 0 ? 0 : 1;
#else
    mode_t mode = ACCESSPERMS;

    if (mkdir(path, mode) != 0) {
        if (errno != EEXIST) {
            return 0;
        }
    }

    return 1;
#endif
}

/* 1 = exists, 0 = does not exist */
int does_process_exist(int pid) {
#ifdef _WIN32
    HANDLE process_handle = OpenProcess(SYNCHRONIZE, FALSE, (DWORD)pid);
    if (process_handle == NULL) {
        return 0;
    }

    DWORD wait_result = WaitForSingleObject(process_handle, 0);

    CloseHandle(process_handle);

    return wait_result == WAIT_TIMEOUT ? 1 : 0;
#else
    int kill_result = kill((pid_t)pid, 0);
    return kill_result == 0 ? 1 : 0;
#endif
}
