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
using SqlNotebook.Utils;
using SqlNotebook.Utils.Json;
using SqlNotebook.Utils.Zip;

namespace SqlNotebook.Persistence {
    public class NotebookSerializer : Object {
        private const int MIN_SUPPORTED_FILE_VERSION = 1;
        private const int CURRENT_FILE_VERSION = 1;
        private const string DATABASE_ENTRY_NAME = "sqlite.db";
        private const string USER_DATA_ENTRY_NAME = "notebook.json";
        private const string KEY_ITEMS = "items";
        private const string KEY_VERSION = "version";
        private const string KEY_NAME = "name";
        private const string KEY_KIND = "kind";
        private const string KEY_DATA = "data";

        private TempFolder _temp_folder;

        public NotebookSerializer(TempFolder temp_folder) {
            _temp_folder = temp_folder;
        }

        public void open_notebook(string notebook_file_path,
                out string database_file_path, out NotebookUserData user_data) throws RuntimeError {
            database_file_path = _temp_folder.get_temp_file_path(".db");

            try {
                var zip_archive = ZipArchive.open(notebook_file_path);

                // extract the sqlite database to a file on disk
                var database_entry = zip_archive.find_entry(DATABASE_ENTRY_NAME);
                if (database_entry == null) {
                    throw new RuntimeError.CORRUPT_NOTEBOOK_FILE(
                            @"Unable to find the \"$DATABASE_ENTRY_NAME\" entry in the notebook file.");
                }

                zip_archive.write_entry_to_file(database_entry, database_file_path);

                // read the user data into memory and parse
                var user_data_entry = zip_archive.find_entry(USER_DATA_ENTRY_NAME);
                if (user_data_entry == null) {
                    throw new RuntimeError.CORRUPT_NOTEBOOK_FILE(
                            @"Unable to find the \"$USER_DATA_ENTRY_NAME\" entry in the notebook file.");
                }

                var user_data_json = zip_archive.read_entry_string(user_data_entry);
                user_data = parse_user_data_json(user_data_json);
            } catch (ZipError e) {
                throw new RuntimeError.CORRUPT_NOTEBOOK_FILE("Unable to open the notebook file. " + e.message);
            }
        }

        public void save_notebook(string notebook_file_path, string sqlite_db_file_path, Notebook notebook,
                NotebookUserData user_data, NotebookLockToken token) throws RuntimeError {
            // the caller should have closed the SQLite connection already
            assert(!notebook.is_sqlite_open(token));

            try {
                var zip_archive = ZipArchive.create(notebook_file_path);

                // write the sqlite database
                zip_archive.add_entry_from_file(DATABASE_ENTRY_NAME, sqlite_db_file_path);

                // write the user data
                var user_data_json = jsonify_user_data(user_data);
                zip_archive.add_entry_from_string(USER_DATA_ENTRY_NAME, user_data_json);
            } catch (ZipError e) {
                throw new RuntimeError.SAVE_FAILED("Unable to save the notebook file. " + e.message);
            }
        }

        private string jsonify_user_data(NotebookUserData user_data) throws RuntimeError {
            var root = JsonElement.for_object();

            var version = JsonElement.for_integer(CURRENT_FILE_VERSION);
            root.object_set(KEY_VERSION, version);

            var items = JsonElement.for_array();
            foreach (var item_record in user_data.items) {
                var item_element = JsonElement.for_object();
                item_element.object_set(KEY_NAME, JsonElement.for_string(item_record.name));
                item_element.object_set(KEY_KIND, JsonElement.for_integer(item_record.kind));
                item_element.object_set(KEY_DATA, JsonElement.for_string(item_record.data));
                items.array_append(item_element);
            }
            root.object_set(KEY_ITEMS, items);

            return root.to_json_string();
        }

        private NotebookUserData parse_user_data_json(string json) throws RuntimeError {
            var user_data = new NotebookUserData();

            try {
                var root = JsonElement.parse(json);
                root.check_type(JsonDataType.OBJECT);

                var root_entries = root.get_object();
                check_file_version(root_entries);
                user_data.items = parse_notebook_item_records(get_object_item(root_entries, KEY_ITEMS));
            } catch (JsonError e) {
                throw new RuntimeError.CORRUPT_NOTEBOOK_FILE("The JSON inside the notebook file is not valid.");
            }

            return user_data;
        }

        private void check_file_version(HashMap<string, JsonElement> root_entries) throws JsonError, RuntimeError {
            var version_element = get_object_item(root_entries, KEY_VERSION);
            var file_version = version_element.get_integer();
            if (file_version < MIN_SUPPORTED_FILE_VERSION || file_version > CURRENT_FILE_VERSION) {
                throw new RuntimeError.UNSUPPORTED_NOTEBOOK_FILE(
                        @"The file version @file_version is not supported.");
            }
        }

        private ArrayList<NotebookItemRecord> parse_notebook_item_records(JsonElement items_array) throws JsonError, RuntimeError {
            var list = new ArrayList<NotebookItemRecord>();

            foreach (var item_element in items_array.get_array()) {
                list.add(parse_notebook_item_record(item_element));
            }

            return list;
        }

        private NotebookItemRecord parse_notebook_item_record(JsonElement item_element) throws JsonError, RuntimeError {
            var item = item_element.get_object();
            var record = new NotebookItemRecord() {
                name = get_object_item(item, KEY_NAME).get_string(),
                kind = (NotebookItemKind)get_object_item(item, KEY_KIND).get_integer(),
                data = get_object_item(item, KEY_DATA).get_string()
            };
            return record;
        }

        private static JsonElement get_object_item(HashMap<string, JsonElement> entries, string key) throws JsonError, RuntimeError {
            JsonElement element;
            if (MapUtil.try_get_value(entries, key, out element)) {
                return element;
            } else {
                throw new RuntimeError.CORRUPT_NOTEBOOK_FILE("Missing JSON field \"@key\".");
            }
        }
    }
}
