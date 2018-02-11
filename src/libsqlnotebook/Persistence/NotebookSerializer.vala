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

using SqlNotebook;
using SqlNotebook.Errors;
using SqlNotebook.Utils;
using SqlNotebook.Utils.Json;
using SqlNotebook.Utils.Zip;

namespace SqlNotebook.Persistence {
    public class NotebookSerializer : Object {
        private const string DATABASE_ENTRY_NAME = "sqlite.db";
        private const string USER_DATA_ENTRY_NAME = "notebook.json";

        private TempFolder _temp_folder;

        public NotebookSerializer(TempFolder temp_folder) {
            _temp_folder = temp_folder;
        }

        public void open_notebook(string notebook_file_path,
                out string database_file_path, out NotebookUserData user_data) throws RuntimeError {
            database_file_path = _temp_folder.get_temp_file_path(".db");

            try {
                var zip_archive = ZipArchive.open(notebook_file_path);

                // write the sqlite database to a file on disk
                var database_entry = zip_archive.find_entry(DATABASE_ENTRY_NAME);
                if (database_entry == null) {
                    throw new RuntimeError.CORRUPT_NOTEBOOK_FILE(
                            @"Unable to find the \"$DATABASE_ENTRY_NAME\" entry in the notebook file.");
                }

                zip_archive.write_entry_to_file(database_entry, database_file_path);

                // read the user data into memory
                var user_data_entry = zip_archive.find_entry(USER_DATA_ENTRY_NAME);
                if (user_data_entry == null) {
                    throw new RuntimeError.CORRUPT_NOTEBOOK_FILE(
                            @"Unable to find the \"$USER_DATA_ENTRY_NAME\" entry in the notebook file.");
                }

                var user_data_json = zip_archive.read_entry_string(user_data_entry);
                user_data = parse_user_data_json(user_data_json);
            } catch (ZipError ex) {
                throw new RuntimeError.CORRUPT_NOTEBOOK_FILE("Unable to open the notebook file. " + ex.message);
            }
        }

        private NotebookUserData parse_user_data_json(string json) throws RuntimeError {
            throw new RuntimeError.CANCELED("nyi");
        }
    }
}
