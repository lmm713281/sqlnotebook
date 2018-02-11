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

#include <stdio.h>
#include <stdlib.h>
#include <zip.h>
#include "ZipArchive.h"

struct ZipArchive {
    zip_t* zip;
};

static ZipArchiveResult zip_archive_open_core(const char* zip_file_path, ZipArchive** archive, int create) {
    zip_t* zip = NULL;
    int error_code = 0;

    zip = zip_open(
            /* path */ zip_file_path,
            /* flags */ create ? ZIP_CREATE : ZIP_RDONLY,
            /* errorp */ &error_code);
    if (zip == NULL) {
        *archive = NULL;
        switch (error_code) {
            case ZIP_ER_INCONS:
            case ZIP_ER_NOZIP:
                return ZIP_ARCHIVE_RESULT_CORRUPT_FILE;
            case ZIP_ER_MEMORY:
                return ZIP_ARCHIVE_RESULT_OUT_OF_MEMORY;
            case ZIP_ER_NOENT:
                return ZIP_ARCHIVE_RESULT_FILE_NOT_FOUND;
            case ZIP_ER_OPEN:
            case ZIP_ER_READ:
            case ZIP_ER_SEEK:
                return ZIP_ARCHIVE_RESULT_IO_FAILED;
            default:
                return ZIP_ARCHIVE_RESULT_UNKNOWN_ERROR;
        }
    }

    *archive = calloc(1, sizeof(ZipArchive));
    (*archive)->zip = zip;
    return ZIP_ARCHIVE_RESULT_SUCCESS;
}

ZipArchiveResult zip_archive_open(const char* zip_file_path, ZipArchive** archive) {
    return zip_archive_open_core(zip_file_path, archive, 0);
}

ZipArchiveResult zip_archive_create(const char* zip_file_path, ZipArchive** archive) {
    return zip_archive_open_core(zip_file_path, archive, 1);
}

int64_t zip_archive_get_entries_count(ZipArchive* archive) {
    return (int64_t)zip_get_num_entries(
            /* archive */ archive->zip,
            /* flags */ 0);
}

ZipArchiveResult zip_archive_get_entry_name(ZipArchive* archive, int entry_index, const char** name) {
    *name = zip_get_name(
            /* archive */ archive->zip,
            /* index */ entry_index,
            /* flags */ 0);

    if (*name == NULL) {
        return ZIP_ARCHIVE_RESULT_CORRUPT_FILE;
    } else {
        return ZIP_ARCHIVE_RESULT_SUCCESS;
    }
}

ZipArchiveResult zip_archive_get_entry_size(ZipArchive* archive, int entry_index, uint64_t* size) {
    zip_stat_t sb = { 0 };
    int ret = 0;

    ret = zip_stat_index(
            /* archive */ archive->zip,
            /* index */ entry_index,
            /* flags */ 0,
            /* sb */ &sb);
    if (ret != 0) {
        *size = 0;
        return ZIP_ARCHIVE_RESULT_CORRUPT_FILE;
    } else {
        *size = sb.size;
        return ZIP_ARCHIVE_RESULT_SUCCESS;
    }
}

ZipArchiveResult zip_archive_copy_entry_to_buffer(ZipArchive* archive, int entry_index, uint8_t** buffer,
        uint64_t buffer_size) {
    zip_file_t* file = NULL;
    int sub_result = 0, result = ZIP_ARCHIVE_RESULT_SUCCESS;

    file = zip_fopen_index(
            /* archive */ archive->zip,
            /* index */ entry_index,
            /* flags */ 0);
    if (file == NULL) {
        result = ZIP_ARCHIVE_RESULT_CORRUPT_FILE;
        goto finish;
    }

    sub_result = zip_fread(
            /* file */ file,
            /* buf */ *buffer,
            /* nbytes */ buffer_size);
    if (sub_result == -1) {
        result = ZIP_ARCHIVE_RESULT_IO_FAILED;
        goto finish;
    }

finish:
    if (file != NULL) {
        sub_result = zip_fclose(file);
        if (sub_result != 0) {
            result = ZIP_ARCHIVE_RESULT_IO_FAILED;
        }
    }

    return result;
}

ZipArchiveResult zip_archive_write_entry_to_file(ZipArchive* archive, int entry_index, const char* file_path) {
    zip_file_t* source_file = NULL;
    FILE* target_file = NULL;
    int sub_result = 0, result = ZIP_ARCHIVE_RESULT_SUCCESS;
    uint8_t buffer[32768];

    target_file = fopen(file_path, "wb");
    if (target_file == NULL) {
        result = ZIP_ARCHIVE_RESULT_IO_FAILED;
        goto finish;
    }

    source_file = zip_fopen_index(
            /* archive */ archive->zip,
            /* index */ entry_index,
            /* flags */ 0);
    if (source_file == NULL) {
        result = ZIP_ARCHIVE_RESULT_CORRUPT_FILE;
        goto finish;
    }

    while (1) {
        int64_t bytes_read = 0;
        size_t bytes_written = 0;

        bytes_read = zip_fread(
                /* file */ source_file,
                /* buf */ buffer,
                /* nbytes */ sizeof(buffer));
        if (bytes_read == -1) {
            result = ZIP_ARCHIVE_RESULT_IO_FAILED;
            goto finish;
        }

        bytes_written = fwrite(
                /* ptr */ buffer,
                /* size */ 1,
                /* count */ bytes_read,
                /* stream */ target_file);
        if (bytes_written != bytes_read) {
            result = ZIP_ARCHIVE_RESULT_IO_FAILED;
            goto finish;
        }

        if (bytes_read < sizeof(buffer)) {
            break;
        }
    }

finish:
    if (target_file != NULL) {
        sub_result = fclose(target_file);
        if (sub_result != 0) {
            result = ZIP_ARCHIVE_RESULT_IO_FAILED;
        }
    }

    if (source_file != NULL) {
        sub_result = zip_fclose(source_file);
        if (sub_result != 0) {
            result = ZIP_ARCHIVE_RESULT_IO_FAILED;
        }
    }

    return result;
}

void zip_archive_close(ZipArchive* archive) {
    int ret = 0;

    if (archive != NULL) {
        if (archive->zip != NULL) {
            ret = zip_close(archive->zip);
            if (ret != 0) {
                zip_discard(archive->zip);
            }

            archive->zip = NULL;
        }

        free(archive);
    }
}
