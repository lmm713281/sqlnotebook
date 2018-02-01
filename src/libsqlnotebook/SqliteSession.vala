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
    public class SqliteSession : Object {
        private string _file_path;
        private bool _is_temporary;
        private Sqlite.Database _database;

        private SqliteSession(string file_path, bool is_temporary) {
            _file_path = file_path;
            _is_temporary = is_temporary;
        }

        ~SqliteSession() {
            if (_is_temporary) {
                try {
                    File.new_for_path(_file_path).delete();
                } catch (Error e) {
                    // TODO: log to a file so we can delete it later
                }
            }
        }

        public static SqliteSession open(string file_path, bool is_temporary) throws RuntimeError {
            var session = new SqliteSession(file_path, is_temporary);
            maybe_throw_without_database(Sqlite.Database.open(file_path, out session._database));
            return session;
        }

        /*private static void maybe_throw(Sqlite.Database database, int sqlite_result) throws RuntimeError {
            var message = "%s\n%s".printf(
                Sqlite.Database.errstr(sqlite_result),
                database.errmsg());
                maybe_throw_without_database(sqlite_result, message);
           }*/

        private static void maybe_throw_without_database(int sqlite_result, string? message = null) throws RuntimeError {
            if (message == null) {
                message = Sqlite.Database.errstr(sqlite_result);
            }

            switch (sqlite_result) {
                case 0: return;
                default: throw new RuntimeError.SQLITE_ERROR(message);
                case 2: throw new RuntimeError.SQLITE_INTERNAL(message);
                case 3: throw new RuntimeError.SQLITE_PERM(message);
                case 4: throw new RuntimeError.SQLITE_ABORT(message);
                case 5: throw new RuntimeError.SQLITE_BUSY(message);
                case 6: throw new RuntimeError.SQLITE_LOCKED(message);
                case 7: throw new RuntimeError.SQLITE_NOMEM(message);
                case 8: throw new RuntimeError.SQLITE_READONLY(message);
                case 9: throw new RuntimeError.SQLITE_INTERRUPT(message);
                case 10: throw new RuntimeError.SQLITE_IOERR(message);
                case 11: throw new RuntimeError.SQLITE_CORRUPT(message);
                case 12: throw new RuntimeError.SQLITE_NOTFOUND(message);
                case 13: throw new RuntimeError.SQLITE_FULL(message);
                case 14: throw new RuntimeError.SQLITE_CANTOPEN(message);
                case 15: throw new RuntimeError.SQLITE_PROTOCOL(message);
                case 16: throw new RuntimeError.SQLITE_EMPTY(message);
                case 17: throw new RuntimeError.SQLITE_SCHEMA(message);
                case 18: throw new RuntimeError.SQLITE_TOOBIG(message);
                case 19: throw new RuntimeError.SQLITE_CONSTRAINT(message);
                case 20: throw new RuntimeError.SQLITE_MISMATCH(message);
                case 21: throw new RuntimeError.SQLITE_MISUSE(message);
                case 22: throw new RuntimeError.SQLITE_NOLFS(message);
                case 23: throw new RuntimeError.SQLITE_AUTH(message);
                case 24: throw new RuntimeError.SQLITE_FORMAT(message);
                case 25: throw new RuntimeError.SQLITE_RANGE(message);
                case 26: throw new RuntimeError.SQLITE_NOTADB(message);
                case 27: throw new RuntimeError.SQLITE_NOTICE(message);
                case 28: throw new RuntimeError.SQLITE_WARNING(message);
                case 100: throw new RuntimeError.SQLITE_ROW(message);
                case 101: throw new RuntimeError.SQLITE_DONE(message);
            }
        }
    }
}
