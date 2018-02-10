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
using SqlNotebook.Collections;
using SqlNotebook.Errors;
using SqlNotebook.Utils;

namespace SqlNotebook {
    public class Notebook : Object {
        private string _notebook_file_path;
        private bool _is_temporary;
        private NotebookLockBox _lock_box = new NotebookLockBox();

        // protected by lock
        private SqliteSession _sqlite_session;

        public Notebook(string notebook_file_path, bool is_temporary, SqliteSession sqlite_session) {
            _notebook_file_path = notebook_file_path;
            _is_temporary = is_temporary;
            _sqlite_session = sqlite_session;
        }

        public NotebookLockToken enter() {
            return _lock_box.enter();
        }

        public void exit(NotebookLockToken token) {
            _lock_box.exit(token);
        }

        public DataTable sqlite_query_with_named_args(string sql, HashMap<string, DataValue> args,
                NotebookLockToken token) throws RuntimeError {
            _lock_box.check(token);
            return _sqlite_session.query_with_named_args(sql, args);
        }
    }
}
