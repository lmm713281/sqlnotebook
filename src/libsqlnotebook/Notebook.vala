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

using SqlNotebook.Errors;

namespace SqlNotebook {
    public class Notebook : Object {
        private string _notebook_file_path;
        private bool _is_temporary;
        private SqliteSession _sqlite_session;

        private Notebook(string notebook_file_path, bool is_temporary, SqliteSession sqlite_session) {
            _notebook_file_path = notebook_file_path;
            _is_temporary = is_temporary;
            _sqlite_session = sqlite_session;
        }

        // create a temporary database file
        public static Notebook create() throws RuntimeError {
            var dir = Environment.get_tmp_dir();
            var filename = "new_notebook.squint.db"; // TODO: random
            var file_path = Path.build_filename(dir, filename);
            var session = SqliteSession.open(file_path, true);
            return new Notebook(file_path, true, session);
        }

        // open an existing database file
        public static Notebook open(string file_path) throws RuntimeError {
            var session = SqliteSession.open(file_path, false);
            return new Notebook(file_path, false, session);
        }
    }
}
