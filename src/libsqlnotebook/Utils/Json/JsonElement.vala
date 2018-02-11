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

namespace SqlNotebook.Utils.Json {
    public class JsonElement : Object {
        private NativeJsonElement? _native_root;

        private JsonElement() {
        }

        public static JsonElement parse(string json) throws JsonError {
            var json_element = new JsonElement();

            string error_message = null;
            int error_line = 0, error_column = 0;
            json_element._native_root = NativeJsonElement.parse(json, out error_message, out error_line, out error_column);
            if (json_element._native_root == null) {
                throw new JsonError.INVALID_JSON(@"$error_message (line $error_line, column $error_column)");
            }

            return json_element;
        }

        public JsonDataType get_data_type() {
            switch (_native_root.get_element_type()) {
                case NativeJsonDataType.OBJECT:
                    return JsonDataType.OBJECT;

                case NativeJsonDataType.ARRAY:
                    return JsonDataType.ARRAY;

                case NativeJsonDataType.STRING:
                    return JsonDataType.STRING;

                case NativeJsonDataType.INTEGER:
                    return JsonDataType.INTEGER;

                case NativeJsonDataType.REAL:
                    return JsonDataType.REAL;

                case NativeJsonDataType.TRUE:
                    return JsonDataType.TRUE;

                case NativeJsonDataType.FALSE:
                    return JsonDataType.FALSE;

                case NativeJsonDataType.NULL:
                    return JsonDataType.NULL;

                default:
                    assert(false);
                    return JsonDataType.NULL;
            }
        }

        public string get_string() {
            return _native_root.get_string().dup();
        }

        public int64 get_integer() {
            return _native_root.get_integer();
        }

        public double get_real() {
            return _native_root.get_real();
        }

        public ArrayList<JsonElement> get_array() {
            var count = _native_root.get_array_size();
            var list = new ArrayList<JsonElement>();

            for (int64 i = 0; i < count; i++) {
                var child_element = new JsonElement();
                child_element._native_root = _native_root.get_array_item(i);
                list.add(child_element);
            }

            return list;
        }

        public HashMap<string, JsonElement> get_object() {
            var map = new HashMap<string, JsonElement>();
            var iterator = _native_root.get_object_iterator();

            while (iterator.eof() == 0) {
                var key = iterator.key().dup();
                var value_element = new JsonElement();
                value_element._native_root = iterator.value();
                map.set(key, value_element);
                iterator.next();
            }

            return map;
        }

        public static JsonElement for_true() {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_true();
            return element;
        }

        public static JsonElement for_false() {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_false();
            return element;
        }

        public static JsonElement for_null() {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_null();
            return element;
        }

        public static JsonElement for_string(string value) {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_string(value);
            return element;
        }

        public static JsonElement for_integer(int64 value) {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_integer(value);
            return element;
        }

        public static JsonElement for_real(double value) {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_real(value);
            return element;
        }

        public static JsonElement for_array() {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_array();
            return element;
        }

        public static JsonElement for_object() {
            var element = new JsonElement();
            element._native_root = NativeJsonElement.for_object();
            return element;
        }

        public void array_append(JsonElement child_element) {
            _native_root.array_append(child_element._native_root);
        }

        public void object_set(string key, JsonElement value_element) {
            _native_root.object_set(key, value_element._native_root);
        }

        public string to_json_string() {
            return _native_root.to_json_string();
        }
    }
}
