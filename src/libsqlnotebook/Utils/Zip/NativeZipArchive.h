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

#pragma once

#include <stdint.h>
#include "NativeZipArchiveResult.h"

typedef struct ZipArchive ZipArchive;

ZipArchiveResult zip_archive_open(const char* zip_file_path, ZipArchive** archive);
ZipArchiveResult zip_archive_create(const char* zip_file_path, ZipArchive** archive);
int64_t zip_archive_get_entries_count(ZipArchive* archive);
ZipArchiveResult zip_archive_get_entry_name(ZipArchive* archive, int entry_index, const char** name);
ZipArchiveResult zip_archive_get_entry_size(ZipArchive* archive, int entry_index, uint64_t* size);
ZipArchiveResult zip_archive_copy_entry_to_buffer(ZipArchive* archive, int entry_index, uint8_t** buffer,
        uint64_t buffer_size);
ZipArchiveResult zip_archive_copy_entry_to_string(ZipArchive* archive, int entry_index, char** buffer);
ZipArchiveResult zip_archive_write_entry_to_file(ZipArchive* archive, int entry_index, const char* file_path);
ZipArchiveResult zip_archive_add_entry_from_file(ZipArchive* archive, const char* entry_name, const char* file_path);
ZipArchiveResult zip_archive_add_entry_from_string(ZipArchive* archive, const char* entry_name, const char* data,
        uint64_t length);
void zip_archive_close(ZipArchive* archive);
