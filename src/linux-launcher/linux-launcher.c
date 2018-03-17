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

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static char* get_exe_directory(char* argv[]) {
    char* dir = NULL;
    int i = 0;

    dir = strdup(argv[0]);

    for (i = strlen(dir) - 1; i >= 0; i--) {
        if (dir[i] == '/') {
            dir[i] = '\0';
            return dir;
        }
    }

    free(dir);
    return NULL;
}

static char* get_target_exe_file_path(char* argv[], const char* current_directory) {
    const char* target_exe_relative_path = NULL;
    char* target_exe_file_path = NULL;
    const char* filename = NULL;
    int i = 0;

    filename = argv[0];
    for (i = strlen(argv[0]) - 1; i >= 0; i--) {
        if (argv[0][i] == '/') {
            filename = &argv[0][i + 1];
            break;
        }
    }

    if (strcmp(filename, "sqlnotebook-gui") == 0) {
        target_exe_relative_path = "/bin/sqlnotebook-gui.bin";
    } else if (strcmp(filename, "tests") == 0) {
        target_exe_relative_path = "/bin/tests.bin";
    } else {
        target_exe_relative_path = "/bin/sqlnotebook.bin";
    }

    target_exe_file_path = calloc(
            strlen(current_directory) + strlen(target_exe_relative_path) + 1,
            sizeof(char));
    strcpy(target_exe_file_path, current_directory);
    strcat(target_exe_file_path, target_exe_relative_path);

    return target_exe_file_path;
}

static char* get_new_ld_library_path(const char* old_ld_library_path, const char* current_directory) {
    const char* directory_suffix = "/lib";
    const char* separator = ":";
    char* ld_library_path = NULL;

    ld_library_path = calloc(
            strlen(old_ld_library_path) + strlen(separator) + strlen(current_directory) + strlen(directory_suffix) + 1,
            sizeof(char));

    strcpy(ld_library_path, old_ld_library_path);

    if (old_ld_library_path[0] != '\0') {
        strcat(ld_library_path, separator);
    }

    strcat(ld_library_path, current_directory);
    strcat(ld_library_path, directory_suffix);

    return ld_library_path;
}

int main(int argc, char* argv[]) {
    char* current_directory = NULL;
    char* target_exe_file_path = NULL;
    const char* old_ld_library_path = NULL;
    char* new_ld_library_path = NULL;

    current_directory = get_exe_directory(argv);
    if (current_directory == NULL) {
        fprintf(stderr, "Unable to determine the executable path.\n");
        return -1;
    }

    target_exe_file_path = get_target_exe_file_path(argv, current_directory);
    old_ld_library_path = getenv("LD_LIBRARY_PATH");
    if (old_ld_library_path == NULL) {
        old_ld_library_path = "";
    }
    new_ld_library_path = get_new_ld_library_path(old_ld_library_path, current_directory);
    free(current_directory);
    setenv("LD_LIBRARY_PATH", new_ld_library_path, 1);
    free(new_ld_library_path);
    setenv("GTK_THEME", "Adwaita", 1);

    return execv(target_exe_file_path, argv);
}
