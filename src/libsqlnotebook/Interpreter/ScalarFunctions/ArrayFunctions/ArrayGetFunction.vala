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

using SqlNotebook.Collections;
using SqlNotebook.Errors;
using SqlNotebook.Utils;

namespace SqlNotebook.Interpreter.ScalarFunctions.ArrayFunctions {
    public class ArrayGetFunction : ScalarFunction {
        public override string get_name() {
            return "array_get";
        }

        public override int get_parameter_count() {
            return 2;
        }

        public override bool is_deterministic() {
            return true;
        }

        public override DataValue execute(Gee.ArrayList<DataValue> args) throws RuntimeError {
            var name = get_name();
            var blob = ArgUtil.get_blob_arg(args[0], "array", name);
            var index = ArgUtil.get_int32_arg(args[1], "element-index", name);

            if (!SqlArrayUtil.is_sql_array(blob)) {
                throw new RuntimeError.WRONG_ARGUMENT_KIND(@"$name: blob argument is not an array.");
            }

            var count = SqlArrayUtil.get_count(blob);
            if (index < 0 || index >= count) {
                return DataValue.for_null();
            } else {
                return SqlArrayUtil.get_element(blob, index);
            }
        }
    }
}
