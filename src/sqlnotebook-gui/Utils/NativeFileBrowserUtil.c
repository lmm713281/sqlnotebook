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

#include <stdlib.h>
#include "NativeCommon.h"
#include "NativeFileBrowserUtil.h"

#ifdef _WIN32
typedef struct {
    HWND handle;
    DWORD process_id;
} MainWindowHandleContext;

static BOOL CALLBACK get_main_window_handle_callback(HWND hwnd, LPARAM lParam) {
    MainWindowHandleContext* context = (MainWindowHandleContext*)lParam;
    LPWSTR class_name = NULL;
    int max_len = 1000;
    BOOL keep_looping = TRUE;
    DWORD process_id = 0;

    class_name = calloc(max_len, sizeof(WCHAR));
    GetClassName(hwnd, class_name, max_len);
    if (wcscmp(class_name, L"gdkWindowToplevel") != 0) {
        goto finish;
    }

    GetWindowThreadProcessId(hwnd, &process_id);
    if (process_id != context->process_id) {
        goto finish;
    }

    /* found it! */
    context->handle = hwnd;
    keep_looping = FALSE;

finish:
    free(class_name);
    return keep_looping;
}

static HWND get_main_window_handle() {
    MainWindowHandleContext context;

    context.handle = NULL;
    context.process_id = GetCurrentProcessId();

    EnumWindows(get_main_window_handle_callback, (LPARAM)&context);

    return context.handle;
}

#endif

/* 1 = user selected a file, 0 = user canceled, -1 = no native impl, caller should fall back to gtk */
int run_open_file_dialog(const char* title, const char* filter_name, const char* filter_extensions, char** file_path) {
#ifdef _WIN32
    OPENFILENAME ofn = { 0 };
    BOOL result = FALSE;
    LPWSTR filter_name_utf16 = NULL, filter_extensions_utf16 = NULL, filter_utf16 = NULL, title_utf16 = NULL;
    size_t cch_filter_name = 0, cch_filter_extensions = 0;

    filter_name_utf16 = utf8_to_utf16(filter_name);
    filter_extensions_utf16 = utf8_to_utf16(filter_extensions);
    cch_filter_name = wcslen(filter_name_utf16);
    cch_filter_extensions = wcslen(filter_extensions_utf16);
    /* {filter_name}\0{filter_extensions}\0\0 */
    filter_utf16 = calloc(cch_filter_name + 1 + cch_filter_extensions + 2, sizeof(WCHAR));
    memcpy(filter_utf16, filter_name_utf16, cch_filter_name * sizeof(WCHAR));
    memcpy(&filter_utf16[cch_filter_name + 1], filter_extensions_utf16, cch_filter_extensions * sizeof(WCHAR));

    free(filter_name_utf16);
    free(filter_extensions_utf16);

    ofn.lStructSize = sizeof(OPENFILENAME);
    ofn.hwndOwner = get_main_window_handle();
    ofn.lpstrFilter = filter_utf16;
    ofn.lpstrFile = calloc(MAX_PATH, sizeof(WCHAR));
    ofn.nMaxFile = MAX_PATH;
    title_utf16 = utf8_to_utf16(title);
    ofn.lpstrTitle = title_utf16;
    ofn.Flags = OFN_EXPLORER | OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;

    result = GetOpenFileName(&ofn);

    free(filter_utf16);
    free(title_utf16);

    if (result != 0) {
        *file_path = utf16_to_utf8(ofn.lpstrFile);
        free(ofn.lpstrFile);
        return 1;
    } else {
        *file_path = NULL;
        free(ofn.lpstrFile);
        return 0;
    }
#else
    *file_path = NULL;
    return -1;
#endif
}
