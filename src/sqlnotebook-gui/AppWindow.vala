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
using Gtk;

namespace SqlNotebook.Gui {
    [GtkTemplate(ui = "/com/sqlnotebook/sqlnotebook-gui/AppWindow.ui")]
    public class AppWindow : ApplicationWindow {
        private Gtk.Application _application;

        [GtkChild] private ToolButton _new_notebook_btn;
        [GtkChild] private ToolButton _open_notebook_btn;
        [GtkChild] private ToolButton _save_notebook_btn;
        [GtkChild] private ToolButton _add_note_btn;
        [GtkChild] private ToolButton _add_console_btn;
        [GtkChild] private ToolButton _add_script_btn;
        [GtkChild] private ToolItem _search_tool_item;

        public AppWindow(Gtk.Application application) {
            Object(application: application);
            _application = application;
            set_size_request(900, 650);
            set_role("SqlNotebookAppWindow");

            // https://stackoverflow.com/a/9343106
            // this sets the application name in the GNOME shell top bar
            set_wmclass("SQL Notebook", "SQL Notebook");

            icon = new Pixbuf.from_resource("/com/sqlnotebook/sqlnotebook-gui/sqlnotebook_48.png");
            _new_notebook_btn.icon_widget = new Image.from_resource("/com/sqlnotebook/sqlnotebook-gui/new_notebook_20.png");
            _open_notebook_btn.icon_widget = new Image.from_resource("/com/sqlnotebook/sqlnotebook-gui/open_notebook_20.png");
            _save_notebook_btn.icon_widget = new Image.from_resource("/com/sqlnotebook/sqlnotebook-gui/save_notebook_20.png");
            _add_note_btn.icon_widget = new Image.from_resource("/com/sqlnotebook/sqlnotebook-gui/note_add_20.png");
            _add_console_btn.icon_widget = new Image.from_resource("/com/sqlnotebook/sqlnotebook-gui/console_add_20.png");
            _add_script_btn.icon_widget = new Image.from_resource("/com/sqlnotebook/sqlnotebook-gui/script_add_20.png");

            var search_entry = new SearchEntry() {
                placeholder_text = "Search Help"
            };
            _search_tool_item.add(search_entry);
        }

        [GtkCallback]
        private void new_mnu_activate() {
            open_new_notebook_window();
        }

        [GtkCallback]
        private void new_notebook_btn_clicked() {
            open_new_notebook_window();
        }

        private void open_new_notebook_window() {
            var w = new AppWindow(_application);
            w.show_all();
        }

        [GtkCallback]
        private void open_mnu_activate() {
            open_existing_notebook_window();
        }

        [GtkCallback]
        private void open_notebook_btn_clicked() {
            open_existing_notebook_window();
        }

        private void open_existing_notebook_window() {
            var w = new FileChooserNative(
                    /* title */ "Open Notebook",
                    /* parent */ this,
                    /* action */ FileChooserAction.OPEN,
                    /* accept_label */ "Open",
                    /* cancel_label */ "Cancel");
            w.run();
        }
    }
}
