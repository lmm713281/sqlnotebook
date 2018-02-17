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
using SqlNotebook.Utils;

namespace SqlNotebook.Gui {
    [GtkTemplate(ui = "/com/sqlnotebook/sqlnotebook-gui/AppWindow.ui")]
    public class AppWindow : ApplicationWindow {
        private Gtk.Application _application;

        [GtkChild] private ToolItem _search_tool_item;

        public AppWindow(Gtk.Application application) {
            Object(application: application);
            _application = application;
            set_size_request(900, 650);
            set_role("SqlNotebookAppWindow");

            // https://stackoverflow.com/a/9343106
            // this sets the application name in the GNOME shell top bar
            set_wmclass("SQL Notebook", "SQL Notebook");

            try {
                icon = new Pixbuf.from_resource("/com/sqlnotebook/sqlnotebook-gui/sqlnotebook_48.png");
            } catch (Error e) {
                assert(false);
            }
            
            var search_entry = new Entry() {
                placeholder_text = "Search Help"
            };
            
            try {
                search_entry.primary_icon_pixbuf = new Pixbuf.from_resource("/com/sqlnotebook/sqlnotebook-gui/search_20.png");
            } catch (Error e) {
                assert(false);
            }
            
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

        private void open_new_notebook_window() {
            var w = new AppWindow(_application);
            w.show_all();
        }

        private void open_existing_notebook_window() {
            var w = new FileChooserDialog(
                    /* title */ "Open Notebook",
                    /* parent */ this,
                    /* action */ FileChooserAction.OPEN,
                    /* accept_label */ "Open", ResponseType.ACCEPT,
                    /* cancel_label */ "Cancel", ResponseType.CANCEL);
            w.set_modal(true);
            w.set_transient_for(this);
            w.run();
            w.close();
        }
    }
}
