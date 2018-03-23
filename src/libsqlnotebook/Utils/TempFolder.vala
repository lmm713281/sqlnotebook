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

namespace SqlNotebook.Utils {
    public class TempFolder : Object {
        private const string ROOT_DIR_NAME = "com.sqlnotebook";
        private string _process_dir;

        private TempFolder(string process_dir) {
            _process_dir = process_dir;
        }

        public static TempFolder create() throws RuntimeError {
            // tmp
            var temp_dir = Environment.get_tmp_dir();

            // tmp/com.sqlnotebook
            var sqlnotebook_dir = Path.build_filename(temp_dir, ROOT_DIR_NAME);
            create_directory(sqlnotebook_dir);

            prune(sqlnotebook_dir);

            // tmp/com.sqlnotebook/1234
            var pid = (int)Posix.getpid();
            var process_dir = Path.build_filename(sqlnotebook_dir, @"$pid");
            create_directory(process_dir);

            return new TempFolder(process_dir);
        }

        public string get_temp_file_path(string extension) {
            var filename = Uuid.string_random() + extension;
            var file_path = Path.build_filename(_process_dir, filename);
            return file_path;
        }

        private static void prune(string sqlnotebook_dir) {
            LinkedList<string> paths;
            Regex pid_regex;
            try {
                paths = get_process_paths(sqlnotebook_dir);
                pid_regex = new Regex("^[0-9]+$");
            } catch (RuntimeError e) {
                return;
            } catch (RegexError e) {
                return;
            }
            foreach (var path in paths) {
                var name = Path.get_basename(path);
                if (pid_regex.match(name) && NativeUtil.does_process_exist(int.parse(name)) == 0) {
                    delete_directory(path);
                }
            }
        }

        private static LinkedList<string> get_process_paths(string sqlnotebook_dir) throws RuntimeError {
            try {
                var sqlnotebook_dir_file = File.new_for_path(sqlnotebook_dir);
                var children_enumerator = sqlnotebook_dir_file.enumerate_children("standard::*",
                        FileQueryInfoFlags.NOFOLLOW_SYMLINKS);

                var process_paths = new LinkedList<string>();
                FileInfo dir_info;
                while ((dir_info = children_enumerator.next_file()) != null) {
                    if (dir_info.get_file_type() == FileType.DIRECTORY) {
                        process_paths.add(Path.build_filename(sqlnotebook_dir, dir_info.get_name()));
                    }
                }

                return process_paths;
            } catch (Error e) {
                var reason = e.message;
                var message = @"Failed to get a list of temporary paths. $reason";
                throw new RuntimeError.ERROR_LISTING_TEMP_DIRS(message);
            }
        }

        private static void create_directory(string path) throws RuntimeError {
            if (NativeUtil.create_directory(path) == 0) {
                var message = @"Unable to create a temporary directory ($path).";
                throw new RuntimeError.ERROR_CREATING_TEMP_DIR(message);
            }
        }

        private static void delete_directory(string path) {
            try {
                var dir_file = File.new_for_path(path);
                var children_enumerator = dir_file.enumerate_children("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);

                FileInfo dir_info;
                while ((dir_info = children_enumerator.next_file()) != null) {
                    var file_path = dir_info.get_name();
                    if (dir_info.get_file_type() == FileType.DIRECTORY) {
                        delete_directory(file_path);
                    } else {
                        Posix.unlink(file_path);
                    }
                }

                Posix.rmdir(path);
            } catch (Error e) {
                // eat it
            }
        }
    }
}
