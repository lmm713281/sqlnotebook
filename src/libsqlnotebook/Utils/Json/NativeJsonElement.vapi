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

[CCode(cheader_filename = "src/libsqlnotebook/Utils/Json/NativeJsonElement.h")]
namespace SqlNotebook.Utils.Json {
    [Compact]
    [CCode(free_function = "json_element_dispose_element", cname = "JsonElement", cprefix = "json_element_")]
    public class NativeJsonElement {
        public static NativeJsonElement parse(string json, out string error_message, out int error_line,
                out int error_column);
        public NativeJsonDataType get_element_type();
        public unowned string get_string();
        public int64 get_integer();
        public double get_real();
        public int64 get_array_size();
        public NativeJsonElement get_array_item(int64 array_index);
        public int64 get_object_size();
        public NativeJsonObjectIterator get_object_iterator();
        public static NativeJsonElement for_true();
        public static NativeJsonElement for_false();
        public static NativeJsonElement for_null();
        public static NativeJsonElement for_string(string value);
        public static NativeJsonElement for_integer(int64 value);
        public static NativeJsonElement for_real(double value);
        public static NativeJsonElement for_array();
        public static NativeJsonElement for_object();
        public void array_append(NativeJsonElement child_element);
        public void object_set(string key, NativeJsonElement value_element);
        public string to_json_string();
    }
}
