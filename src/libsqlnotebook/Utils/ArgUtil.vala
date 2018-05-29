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

namespace SqlNotebook.Utils.ArgUtil {
    public int64 get_int_arg(DataValue arg, string param_name, string function_name) throws RuntimeError {
        if (arg.kind == DataValueKind.INTEGER) {
            return arg.integer_value;
        } else {
            var actual_kind = arg.get_kind_name();
            throw new RuntimeError.WRONG_ARGUMENT_KIND(@"The \"$param_name\" argument must be an INTEGER value, but " +
                    @"type $actual_kind was provided.");
        }
    }

    public double get_real_arg(DataValue arg, string param_name, string function_name) throws RuntimeError {
        if (arg.kind == DataValueKind.REAL) {
            return arg.real_value;
        } else if (arg.kind == DataValueKind.INTEGER) {
            return arg.integer_value;
        } else {
            var actual_kind = arg.get_kind_name();
            throw new RuntimeError.WRONG_ARGUMENT_KIND(@"The \"$param_name\" argument must be a REAL value, but " +
                    @"type $actual_kind was provided.");
        }
    }
}
