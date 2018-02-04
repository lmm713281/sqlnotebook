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
using SqlNotebook;
using SqlNotebook.Errors;

namespace SqlNotebook.Interpreter {
    public class ScriptRunner : Object {
        private weak Notebook _notebook;
        private HashMap<string, string> _scripts; // lowercase script name -> script code

        public ScriptRunner(Notebook notebook, HashMap<string, string> scripts) {
            _notebook = notebook;
            _scripts = scripts;
        }

        private string get_script_code(string name) throws RuntimeError {
            var lowercase_name = name.down();
            if (_scripts.has_key(lowercase_name)) {
                return _scripts.get(lowercase_name);
            } else {
                throw new RuntimeError.UNKNOWN_SCRIPT_NAME(@"There is no script named \"$name\".");
            }
        }
    }
}
