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
    public class DataValue : Object {
        public DataValueKind kind;
        public int64 integer_value;
        public double real_value;
        public string? text_value;
        public DataValueBlob? blob_value;

        public static DataValue for_null() {
            var x = new DataValue() {
                kind = DataValueKind.NULL
            };
            return x;
        }

        public static DataValue for_integer(int64 value) {
            var x = new DataValue() {
                kind = DataValueKind.INTEGER,
                integer_value = value
            };
            return x;
        }

        public static DataValue for_real(double value) {
            var x = new DataValue() {
                kind = DataValueKind.REAL,
                real_value = value
            };
            return x;
        }

        public static DataValue for_text(string value) {
            var x = new DataValue() {
                kind = DataValueKind.TEXT,
                text_value = value
            };
            return x;
        }

        public static DataValue for_blob(DataValueBlob value) {
            var x = new DataValue() {
                kind = DataValueKind.BLOB,
                blob_value = value
            };
            return x;
        }

        public string to_string() {
            switch (kind) {
                case DataValueKind.NULL:
                    return "(null)";

                case DataValueKind.INTEGER:
                    return @"$integer_value";

                case DataValueKind.REAL:
                    return @"$real_value";

                case DataValueKind.TEXT:
                    return text_value;

                case DataValueKind.BLOB:
                    return "(blob)";

                default:
                    assert(false);
                    return "(unknown kind)";
            }
        }
    }
}
