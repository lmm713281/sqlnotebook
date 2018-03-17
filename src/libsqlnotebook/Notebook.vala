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
using SqlNotebook.Persistence;
using SqlNotebook.Utils;

namespace SqlNotebook {
    /**
     * Represents an open notebook (.sqlnb file).
     */
    public class Notebook : Object {
        private string _sqlite_db_file_path; // readonly
        private NotebookLockBox _lock_box = new NotebookLockBox(); // readonly
        private NotebookSerializer _notebook_serializer; // readonly

        // these members are protected by the NotebookLockBox
        private string? _notebook_file_path; // mutable
        private SqliteSession _sqlite_session; // readonly
        private NotebookUserData _notebook_user_data; // readonly

        public Notebook(string? notebook_file_path, string sqlite_db_file_path, SqliteSession sqlite_session,
                NotebookUserData notebook_user_data, NotebookSerializer notebook_serializer) {
            _notebook_file_path = notebook_file_path;
            _sqlite_db_file_path = sqlite_db_file_path;
            _notebook_user_data = notebook_user_data;
            _sqlite_session = sqlite_session;
            _notebook_serializer = notebook_serializer;
        }

        /**
         * Acquires a notebook lock.  The caller must call {@link exit} to release the lock.
         * @return Token representing the held lock which must be presented when calling other notebook methods.
         */
        public NotebookLockToken enter() {
            return _lock_box.enter();
        }

        /**
         * Releases a notebook lock that was obtained from {@link enter}.
         */
        public void exit(NotebookLockToken token) {
            _lock_box.exit(token);
        }

        /**
         * Gets the absolute path of the .sqlnb file that this notebook was loaded from.
         * @param token Proof that the caller acquired the notebook lock using {@link enter}
         * @return File path, or ``null`` if this is an unsaved new notebook.
         */
        public string? get_notebook_file_path(NotebookLockToken token) throws RuntimeError {
            _lock_box.check(token);
            return _notebook_file_path;
        }

        /**
         * Checks whether the SQLite connection is open.  This will always be true unless we're in the middle of a save
         * operation.  The {@link SqlNotebook.Persistence.NotebookSerializer} uses this method verifies that it's safe
         * to access the database file directly.
         * @param token Proof that the caller acquired the notebook lock using {@link enter}
         * @return ``true`` if the SQLite connection is open
         */
        public bool is_sqlite_open(NotebookLockToken token) {
            _lock_box.check(token);
            return _sqlite_session.is_open;
        }

        /**
         * Saves the notebook to the specified file.
         * @param notebook_file_path Destination .sqlnb file path
         * @param token Proof that the caller acquired the notebook lock using {@link enter}
         */
        public void save(string notebook_file_path, NotebookLockToken token) throws RuntimeError {
            _lock_box.check(token);
            _sqlite_session.close();
            _notebook_serializer.save_notebook(
                    notebook_file_path, _sqlite_db_file_path, this, _notebook_user_data, token);
            _sqlite_session.reopen();
            _notebook_file_path = notebook_file_path;
        }

        /**
         * Performs a plain SQLite query (i.e. not an SQL Notebook script statement).
         * @param sql SQLite command text
         * @param args Named arguments referenced in the command text
         * @param token Proof that the caller acquired the notebook lock using {@link enter}
         * @return Query results
         */
        public DataTable sqlite_query_with_named_args(string sql, HashMap<string, DataValue> args,
                NotebookLockToken token) throws RuntimeError {
            _lock_box.check(token);
            return _sqlite_session.query_with_named_args(sql, args);
        }
    }
}
