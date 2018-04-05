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

using Gdk;
using Gee;
using SqlNotebook.Errors;
using SqlNotebook.Gui.Editors;
using SqlNotebook.Gui.Utils;
using SqlNotebook.Persistence;
using SqlNotebook.Utils;

namespace SqlNotebook.Gui {
    [GtkTemplate(ui = "/com/sqlnotebook/sqlnotebook-gui/AppWindow.ui")]
    public class AppWindow : Gtk.ApplicationWindow {
        private Gtk.Application _application;
        private Notebook _notebook;
        private LibraryFactory _library_factory;
        private NotebookTreeStoreSync _notebook_tree_store_sync;

        [GtkChild] private Gtk.ToolItem _search_tool_item;
        [GtkChild] private Gtk.Notebook _tabs_ctl;
        [GtkChild] private Gtk.TreeView _notebook_tree_view;
        [GtkChild] private Gtk.TreeStore _notebook_tree_store;

        public AppWindow(Gtk.Application application, LibraryFactory library_factory) {
            Object(application: application);
            _application = application;
            _library_factory = library_factory;

            set_size_request(900, 650);
            set_role("SqlNotebookAppWindow");

            // https://stackoverflow.com/a/9343106
            // this sets the application name in the GNOME shell top bar.
            // it also needs to match the StartupWMClass property in the .desktop file.
            set_wmclass("SQL Notebook", "SQL Notebook");

            try {
                _notebook = _library_factory.new_notebook();
                icon = new Pixbuf.from_resource("/com/sqlnotebook/sqlnotebook-gui/sqlnotebook_48.png");

                var search_entry = new Gtk.Entry() {
                    placeholder_text = "Search Help"
                };

                search_entry.primary_icon_pixbuf = new Pixbuf.from_resource(
                        "/com/sqlnotebook/sqlnotebook-gui/search_20.png");

                _search_tool_item.add(search_entry);

                init_notebook_tree();
            } catch (Error e) {
                assert(false);
            }
        }

        private void init_notebook_tree() throws RuntimeError {
            _notebook_tree_view.insert_column_with_attributes(-1, null, new Gtk.CellRendererText(), "text", 0, null);
            _notebook_tree_store_sync = new NotebookTreeStoreSync(_notebook, _notebook_tree_store);

            var token = _notebook.enter();
            try {
                _notebook_tree_store_sync.initial_sync(token);
            } finally {
                _notebook.exit(token);
            }
        }

        [GtkCallback]
        private void new_mnu_activate() {
            open_new_notebook_window();
        }

        [GtkCallback]
        private void new_notebook_btn_clicked() {
            open_new_notebook_window();
        }

        [GtkCallback]
        private void open_mnu_activate() {
            open_existing_notebook_window();
        }

        [GtkCallback]
        private void open_notebook_btn_clicked() {
            open_existing_notebook_window();
        }

        [GtkCallback]
        private void about_mnu_activate() {
            var dialog = new AboutDialog();
            dialog.set_modal(true);
            dialog.set_transient_for(this);
            dialog.show_all();
        }

        [GtkCallback]
        private void add_note_btn_clicked() {
            add_new_item(NotebookItemKind.NOTE);
        }

        [GtkCallback]
        private void add_note_mnu_activate() {
            add_new_item(NotebookItemKind.NOTE);
        }

        [GtkCallback]
        private void add_console_btn_clicked() {
            add_new_item(NotebookItemKind.CONSOLE);
        }

        [GtkCallback]
        private void add_console_mnu_activate() {
            add_new_item(NotebookItemKind.CONSOLE);
        }

        [GtkCallback]
        private void add_script_btn_clicked() {
            add_new_item(NotebookItemKind.SCRIPT);
        }

        [GtkCallback]
        private void add_script_mnu_activate() {
            add_new_item(NotebookItemKind.SCRIPT);
        }

        private void open_new_notebook_window() {
            var w = new AppWindow(_application, _library_factory);
            w.show_all();
        }

        private void open_existing_notebook_window() {
            var extensions = new ArrayList<string>();
            extensions.add("*.sqlnb");
            FileBrowserUtil.open_file(this, "Open Notebook", "SQL Notebook files", extensions);
        }

        private void add_new_item(NotebookItemKind kind) {
            string? name = null;

            var token = _notebook.enter();
            try {
                name = _notebook.add_new_item(kind, token);
                _notebook_tree_store_sync.sync(token);
            } catch (RuntimeError e) {
                MessageBoxUtil.show_error(this, "Unable to add the new item.", e.message);
            } finally {
                _notebook.exit(token);
            }
            if (name != null) {
                open_existing_item(kind, name);
            }
        }

        private void open_existing_item(NotebookItemKind kind, string name) {
            var title = new Gtk.Label(name);

            Gtk.Widget content = null;

            switch (kind) {
                case NotebookItemKind.NOTE:
                    content = new NoteControl();
                    break;

                default:
                    content = new Gtk.Label("Unknown item kind!");
                    break;
            }

            title.show();
            content.show();

            var index = _tabs_ctl.append_page(content, title);
            assert(index != -1);
            _tabs_ctl.set_current_page(index);
        }
    }
}
