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

namespace SqlNotebook.Utils.Zip {
    public class ZipArchive : Object {
        private NativeZipArchive _native_archive;

        public ArrayList<ZipEntry> entries { get; private set; default = new ArrayList<ZipEntry>(); }

        private ZipArchive() {
        }

        public static ZipArchive open(string zip_file_path) throws ZipError {
            var archive = new ZipArchive();
            var result = NativeZipArchive.open(zip_file_path, out archive._native_archive);
            if (result == NativeZipArchiveResult.SUCCESS) {
                archive.populate_entries();
                return archive;
            } else {
                throw get_error(result);
            }
        }

        public static ZipArchive create(string zip_file_path) throws ZipError {
            var archive = new ZipArchive();
            var result = NativeZipArchive.create(zip_file_path, out archive._native_archive);
            if (result == NativeZipArchiveResult.SUCCESS) {
                archive.populate_entries();
                return archive;
            } else {
                throw get_error(result);
            }
        }

        public ZipEntry? find_entry(string name) {
            foreach (var entry in entries) {
                if (entry.name == name) {
                    return entry;
                }
            }

            return null;
        }

        public uint8[] read_entry_bytes(ZipEntry entry) throws ZipError {
            uint64 size;
            var result1 = _native_archive.get_entry_size(entry.index, out size);
            if (result1 != NativeZipArchiveResult.SUCCESS) {
                throw get_error(result1);
            }

            var buffer = new uint8[size];

            var result2 = _native_archive.copy_entry_to_buffer(entry.index, ref buffer);
            if (result2 != NativeZipArchiveResult.SUCCESS) {
                throw get_error(result2);
            }

            return buffer;
        }

        public string read_entry_string(ZipEntry entry) throws ZipError {
            uint64 size;
            var result1 = _native_archive.get_entry_size(entry.index, out size);
            if (result1 != NativeZipArchiveResult.SUCCESS) {
                throw get_error(result1);
            }

            string buffer;
            var result2 = _native_archive.copy_entry_to_string(entry.index, out buffer);
            if (result2 != NativeZipArchiveResult.SUCCESS) {
                throw get_error(result2);
            }

            return buffer;
        }

        public void write_entry_to_file(ZipEntry entry, string file_path) throws ZipError {
            var result = _native_archive.write_entry_to_file(entry.index, file_path);
            if (result != NativeZipArchiveResult.SUCCESS) {
                throw get_error(result);
            }
        }

        public void add_entry_from_file(string entry_name, string file_path) throws ZipError {
            var result = _native_archive.add_entry_from_file(entry_name, file_path);
            if (result != NativeZipArchiveResult.SUCCESS) {
                throw get_error(result);
            }
        }

        public void add_entry_from_string(string entry_name, string data) throws ZipError {
            var result = _native_archive.add_entry_from_string(entry_name, data, data.length);
            if (result != NativeZipArchiveResult.SUCCESS) {
                throw get_error(result);
            }
        }

        private void populate_entries() throws ZipError {
            var entries_count = _native_archive.get_entries_count();
            entries = new ArrayList<ZipEntry>();

            for (var i = 0; i < entries_count; i++) {
                string name;
                var result1 = _native_archive.get_entry_name(i, out name);
                if (result1 != NativeZipArchiveResult.SUCCESS) {
                    throw get_error(result1);
                }

                uint64 size;
                var result2 = _native_archive.get_entry_size(i, out size);
                if (result2 != NativeZipArchiveResult.SUCCESS) {
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

        private static ZipError get_error(NativeZipArchiveResult result) {
            switch (result) {
                default:
                    return new ZipError.UNKNOWN_ERROR("Unknown error.");

                case NativeZipArchiveResult.CORRUPT_FILE:
                    return new ZipError.CORRUPT_FILE("The zip archive is corrupt.");

                case NativeZipArchiveResult.OUT_OF_MEMORY:
                    return new ZipError.OUT_OF_MEMORY("Not enough memory to open the zip archive.");

                case NativeZipArchiveResult.FILE_NOT_FOUND:
                    return new ZipError.FILE_NOT_FOUND("File not found.");

                case NativeZipArchiveResult.IO_FAILED:
                    return new ZipError.IO_FAILED("Zip archive I/O operation failed.");
            }
        }
    }
}
