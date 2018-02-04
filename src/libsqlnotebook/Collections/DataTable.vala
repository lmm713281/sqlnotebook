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

namespace SqlNotebook.Collections {
    public class DataTable : Object {
        private string[] _column_names;
        private DataTableRow[] _rows;
        public string[] _strings;
        public DataValueBlob[] _blobs;

        public DataTable(Collection<string> column_names, Collection<DataTableRow> rows, Collection<string> strings,
                Collection<DataValueBlob> blobs) {
            _column_names = column_names.to_array();
            _rows = rows.to_array();
            _strings = strings.to_array();
            _blobs = blobs.to_array();
        }

        public int row_count {
            get {
                return _rows.length;
            }
        }

        public int column_count {
            get {
                return _column_names.length;
            }
        }

        public string get_column_name(int column_index) {
            return _column_names[column_index];
        }

        public DataValueKind get_value_kind(int row_index, int column_index) {
            return _rows[row_index].values[column_index].kind;
        }

        public int64 get_value_integer(int row_index, int column_index) {
            var encoded_value = _rows[row_index].values[column_index].value;

            int64 decoded_value = 0;
            Posix.memcpy(&decoded_value, &encoded_value, sizeof(int64));

            return decoded_value;
        }

        public double get_value_real(int row_index, int column_index) {
            var encoded_value = _rows[row_index].values[column_index].value;

            double decoded_value = 0;
            Posix.memcpy(&decoded_value, &encoded_value, sizeof(double));

            return decoded_value;
        }

        public string get_value_text(int row_index, int column_index) {
            var string_index = _rows[row_index].values[column_index].value;
            return _strings[string_index];
        }

        public DataValueBlob get_value_blob(int row_index, int column_index) {
            var blob_index = _rows[row_index].values[column_index].value;
            return _blobs[blob_index];
        }
    }
}
