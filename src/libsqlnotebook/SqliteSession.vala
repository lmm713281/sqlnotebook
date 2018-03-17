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
    public class SqliteSession : Object {
        private string _file_path;
        private bool _is_temporary;
        private Sqlite.Database? _database;

        private SqliteSession(string file_path, bool is_temporary) {
            _file_path = file_path;
            _is_temporary = is_temporary;
        }

        ~SqliteSession() {
            _database = null;

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

        public bool is_open {
            get {
                return _database != null;
            }
        }

        public void close() {
            _database = null;
        }

        public void reopen() throws RuntimeError {
            maybe_throw_without_database(Sqlite.Database.open(_file_path, out _database));
        }

        private static void maybe_throw(Sqlite.Database database, int sqlite_result) throws RuntimeError {
            if (sqlite_result != 0) {
                var message = "%s\n%s".printf(
                        Sqlite.Database.errstr(sqlite_result),
                        database.errmsg());
                maybe_throw_without_database(sqlite_result, message);
            }
        }

        private static void maybe_throw_without_database(int sqlite_result, string? message = null) throws RuntimeError {
            if (message == null) {
                message = Sqlite.Database.errstr(sqlite_result);
            }

            switch (sqlite_result) {
                case Sqlite.OK: return;
                default: throw new RuntimeError.SQLITE_ERROR(message);
                case Sqlite.INTERNAL: throw new RuntimeError.SQLITE_INTERNAL(message);
                case Sqlite.PERM: throw new RuntimeError.SQLITE_PERM(message);
                case Sqlite.ABORT: throw new RuntimeError.SQLITE_ABORT(message);
                case Sqlite.BUSY: throw new RuntimeError.SQLITE_BUSY(message);
                case Sqlite.LOCKED: throw new RuntimeError.SQLITE_LOCKED(message);
                case Sqlite.NOMEM: throw new RuntimeError.SQLITE_NOMEM(message);
                case Sqlite.READONLY: throw new RuntimeError.SQLITE_READONLY(message);
                case Sqlite.INTERRUPT: throw new RuntimeError.SQLITE_INTERRUPT(message);
                case Sqlite.IOERR: throw new RuntimeError.SQLITE_IOERR(message);
                case Sqlite.CORRUPT: throw new RuntimeError.SQLITE_CORRUPT(message);
                case Sqlite.NOTFOUND: throw new RuntimeError.SQLITE_NOTFOUND(message);
                case Sqlite.FULL: throw new RuntimeError.SQLITE_FULL(message);
                case Sqlite.CANTOPEN: throw new RuntimeError.SQLITE_CANTOPEN(message);
                case Sqlite.PROTOCOL: throw new RuntimeError.SQLITE_PROTOCOL(message);
                case Sqlite.EMPTY: throw new RuntimeError.SQLITE_EMPTY(message);
                case Sqlite.SCHEMA: throw new RuntimeError.SQLITE_SCHEMA(message);
                case Sqlite.TOOBIG: throw new RuntimeError.SQLITE_TOOBIG(message);
                case Sqlite.CONSTRAINT: throw new RuntimeError.SQLITE_CONSTRAINT(message);
                case Sqlite.MISMATCH: throw new RuntimeError.SQLITE_MISMATCH(message);
                case Sqlite.MISUSE: throw new RuntimeError.SQLITE_MISUSE(message);
                case Sqlite.NOLFS: throw new RuntimeError.SQLITE_NOLFS(message);
                case Sqlite.AUTH: throw new RuntimeError.SQLITE_AUTH(message);
                case Sqlite.FORMAT: throw new RuntimeError.SQLITE_FORMAT(message);
                case Sqlite.RANGE: throw new RuntimeError.SQLITE_RANGE(message);
                case Sqlite.NOTADB: throw new RuntimeError.SQLITE_NOTADB(message);
                case Sqlite.NOTICE: throw new RuntimeError.SQLITE_NOTICE(message);
                case Sqlite.WARNING: throw new RuntimeError.SQLITE_WARNING(message);
                case Sqlite.ROW: throw new RuntimeError.SQLITE_ROW(message);
                case Sqlite.DONE: throw new RuntimeError.SQLITE_DONE(message);
            }
        }

        public DataTable query_with_named_args(string sql, HashMap<string, DataValue> args) throws RuntimeError {
            return query(sql, args, null, true);
        }

        private DataTable? query(string sql, HashMap<string, DataValue>? named_args, ArrayList<DataValue>? ordered_args,
                bool return_result) throws RuntimeError {

            // from https://www.sqlite.org/c3ref/prepare.html
            // > If the caller knows that the supplied string is nul-terminated, then there is a small performance
            // > advantage to passing an nByte parameter that is the number of bytes in the input string *including* the
            // > nul-terminator.
            Sqlite.Statement statement;
            maybe_throw(_database, _database.prepare_v2(sql, sql.length + 1, out statement, null));

            // bind the arguments to the statement
            maybe_throw(_database, statement.clear_bindings());
            var param_count = statement.bind_parameter_count();

            assert(named_args == null || ordered_args == null);
            assert(named_args != null || ordered_args != null || param_count == 0);

            for (var i = 1; i <= param_count; i++) {
                DataValue value;

                if (named_args != null) {
                    var param_name = statement.bind_parameter_name(i);
                    var lowercase_param_name = param_name.down();
                    if (named_args.has_key(lowercase_param_name)) {
                        value = named_args.get(lowercase_param_name);
                    } else {
                        var message = @"Missing value for SQL parameter \"$param_name\".";
                        throw new RuntimeError.INVALID_SCRIPT_OPERATION(message);
                    }
                } else {
                    value = ordered_args[i - 1];
                }

                switch (value.kind) {
                    case DataValueKind.BLOB:
                        statement.bind_blob(i, value.blob_value.bytes);
                        break;
                    case DataValueKind.INTEGER:
                        statement.bind_int64(i, value.integer_value);
                        break;
                    case DataValueKind.NULL:
                        maybe_throw(_database, statement.bind_null(i));
                        break;
                    case DataValueKind.REAL:
                        statement.bind_double(i, value.real_value);
                        break;
                    case DataValueKind.TEXT:
                        statement.bind_text(i, value.text_value, value.text_value.length);
                        break;
                    default:
                        assert(false);
                        break;
                }
            }

            // prepare to read the results (if the caller wants to)
            var column_names = new ArrayList<string>();
            var column_count = statement.column_count();
            if (return_result) {
                for (var i = 0; i < column_count; i++) {
                    var column_name = statement.column_name(i).dup();
                    column_names.add(column_name);
                }
            }

            // step through the query execution
            var data_table_builder = new DataTableBuilder(column_names);
            while (true) {
                var step_result = statement.step();
                if (step_result == Sqlite.DONE) {
                    break;
                } else if (step_result == Sqlite.ROW) {
                    // if we're not returning results then don't bother retrieving the row
                    if (!return_result) {
                        continue;
                    }

                    data_table_builder.start_row();
                    for (var i = 0; i < column_count; i++) {
                        switch (statement.column_type(i)) {
                            case Sqlite.INTEGER:
                                data_table_builder.set_next_value_integer(statement.column_int64(i));
                                break;

                            case Sqlite.FLOAT:
                                data_table_builder.set_next_value_real(statement.column_double(i));
                                break;

                            case Sqlite.TEXT:
                                data_table_builder.set_next_value_text(statement.column_text(i).dup());
                                break;

                            case Sqlite.BLOB:
                                data_table_builder.set_next_value_blob(read_blob_column(statement, i));
                                break;

                            case Sqlite.NULL:
                                data_table_builder.set_next_value_null();
                                break;

                            default:
                                assert(false);
                                break;
                        }
                    }
                    data_table_builder.finish_row();
                } else {
                    maybe_throw(_database, step_result);
                }
            }

            if (return_result) {
                return data_table_builder.finish();
            } else {
                return null;
            }
        }

        private DataValueBlob read_blob_column(Sqlite.Statement statement, int column_index) {
            var blob = new DataValueBlob();
            var byte_count = statement.column_bytes(column_index);
            var source_buffer = statement.column_blob(column_index);
            blob.bytes = new uint8[byte_count];
            Posix.memcpy(blob.bytes, source_buffer, byte_count);
            return blob;
        }
    }
}
