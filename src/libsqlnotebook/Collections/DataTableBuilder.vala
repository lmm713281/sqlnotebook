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
    public class DataTableBuilder : Object {
        private ArrayList<string> _column_names;
        private LinkedList<DataTableRow> _rows;
        private LinkedList<string> _strings;
        private LinkedList<DataValueBlob> _blobs;

        private DataTableRow _current_row = null;
        private int _current_value_index = 0;

        public DataTableBuilder(ArrayList<string> column_names) {
            _column_names = column_names;
            _rows = new LinkedList<DataTableRow>();
            _strings = new LinkedList<string>();
            _blobs = new LinkedList<DataValueBlob>();
        }

        public void start_row() {
            _current_row = new DataTableRow() {
                values = new DataTableValue[_column_names.size]
            };
            _current_value_index = 0;
        }

        public void set_next_value_null() {
            _current_row.values[_current_value_index++] = DataTableValue() {
                kind = DataValueKind.NULL,
                value = 0
            };
        }

        public void set_next_value_integer(int64 value) {
            uint64 encoded_value = 0;
            Posix.memcpy(&encoded_value, &value, sizeof(int64));

            _current_row.values[_current_value_index++] = DataTableValue() {
                kind = DataValueKind.INTEGER,
                value = encoded_value
            };
        }

        public void set_next_value_real(double value) {
            uint64 encoded_value = 0;
            Posix.memcpy(&encoded_value, &value, sizeof(double));

            _current_row.values[_current_value_index++] = DataTableValue() {
                kind = DataValueKind.REAL,
                value = encoded_value
            };
        }

        public void set_next_value_text(string value) {
            _strings.add(value);
            var string_index = (uint64)(_strings.size - 1);

            _current_row.values[_current_value_index++] = DataTableValue() {
                kind = DataValueKind.TEXT,
                value = string_index
            };
        }

        public void set_next_value_blob(DataValueBlob value) {
            _blobs.add(value);
            var blob_index = (uint64)(_blobs.size - 1);

            _current_row.values[_current_value_index++] = DataTableValue() {
                kind = DataValueKind.BLOB,
                value = blob_index
            };
        }

        public void finish_row() {
            _rows.add(_current_row);
            _current_row = null;
        }

        public DataTable finish() {
            return new DataTable(_column_names, _rows, _strings, _blobs);
        }
    }
}
