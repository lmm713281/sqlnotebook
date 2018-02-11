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

[CCode(cheader_filename = "src/libsqlnotebook/Utils/Zip/NativeZipArchive.h")]
namespace SqlNotebook.Utils.Zip {
    [Compact]
    [CCode(free_function = "zip_archive_close", cname = "ZipArchive", cprefix = "zip_archive_")]
    public class NativeZipArchive {
        public static NativeZipArchiveResult open(string zip_file_path, out NativeZipArchive archive);
        public static NativeZipArchiveResult create(string zip_file_path, out NativeZipArchive archive);
        public int64 get_entries_count();
        public NativeZipArchiveResult get_entry_name(int entry_index, out unowned string name);
        public NativeZipArchiveResult get_entry_size(int entry_index, out uint64 size);
        public NativeZipArchiveResult copy_entry_to_buffer(int entry_index, ref uint8[] buffer);
        public NativeZipArchiveResult copy_entry_to_string(int entry_index, out string buffer);
        public NativeZipArchiveResult write_entry_to_file(int entry_index, string file_path);
        public NativeZipArchiveResult add_entry_from_file(string entry_name, string file_path);
        public NativeZipArchiveResult add_entry_from_string(string entry_name, string data, uint64 length);
    }
}
