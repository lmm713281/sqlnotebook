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

namespace SqlNotebook.Utils {
    public class ZipArchive : Object {
        private ZipArchiveNative _native_archive;

        public ArrayList<ZipEntry> entries { get; private set; default = new ArrayList<ZipEntry>(); }

        private ZipArchive() {
        }

        public static ZipArchive open(string zip_file_path) throws ZipArchiveError {
            var archive = new ZipArchive();
            var result = ZipArchiveNative.open(zip_file_path, out archive._native_archive);
            if (result == ZipArchiveNativeResult.SUCCESS) {
                archive.populate_entries();
                return archive;
            } else {
                throw get_error(result);
            }
        }

        public static ZipArchive create(string zip_file_path) throws ZipArchiveError {
            var archive = new ZipArchive();
            var result = ZipArchiveNative.create(zip_file_path, out archive._native_archive);
            if (result == ZipArchiveNativeResult.SUCCESS) {
                archive.populate_entries();
                return archive;
            } else {
                throw get_error(result);
            }
        }

        public uint8[] read_entry(ZipEntry entry) throws ZipArchiveError {
            uint64 size;
            var result1 = _native_archive.get_entry_size(entry.index, out size);
            if (result1 != ZipArchiveNativeResult.SUCCESS) {
                throw get_error(result1);
            }

            var buffer = new uint8[size];

            var result2 = _native_archive.copy_entry_to_buffer(entry.index, ref buffer);
            if (result2 != ZipArchiveNativeResult.SUCCESS) {
                throw get_error(result2);
            }

            return buffer;
        }

        public void write_entry_to_file(ZipEntry entry, string file_path) throws ZipArchiveError {
            var result = _native_archive.write_entry_to_file(entry.index, file_path);
            if (result != ZipArchiveNativeResult.SUCCESS) {
                throw get_error(result);
            }
        }

        private void populate_entries() throws ZipArchiveError {
            var entries_count = _native_archive.get_entries_count();
            entries = new ArrayList<ZipEntry>();

            for (var i = 0; i < entries_count; i++) {
                string name;
                var result1 = _native_archive.get_entry_name(i, out name);
                if (result1 != ZipArchiveNativeResult.SUCCESS) {
                    throw get_error(result1);
                }

                uint64 size;
                var result2 = _native_archive.get_entry_size(i, out size);
                if (result2 != ZipArchiveNativeResult.SUCCESS) {
                    throw get_error(result2);
                }

                var entry = new ZipEntry() {
                    index = i,
                    name = name,
                    size = size
                };

                entries.add(entry);
            }
        }

        private static ZipArchiveError get_error(ZipArchiveNativeResult result) {
            switch (result) {
                default:
                    return new ZipArchiveError.UNKNOWN_ERROR("Unknown error.");

                case ZipArchiveNativeResult.CORRUPT_FILE:
                    return new ZipArchiveError.CORRUPT_FILE("The zip archive is corrupt.");

                case ZipArchiveNativeResult.OUT_OF_MEMORY:
                    return new ZipArchiveError.OUT_OF_MEMORY("Not enough memory to open the zip archive.");

                case ZipArchiveNativeResult.FILE_NOT_FOUND:
                    return new ZipArchiveError.FILE_NOT_FOUND("File not found.");

                case ZipArchiveNativeResult.IO_FAILED:
                    return new ZipArchiveError.IO_FAILED("Zip archive I/O operation failed.");
            }
        }
    }
}
