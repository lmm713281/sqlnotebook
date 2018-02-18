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
    [GtkTemplate(ui = "/com/sqlnotebook/sqlnotebook-gui/AboutDialog.ui")]
    public class AboutDialog : Dialog {
        [GtkChild] private TextView _license_txt;

        public AboutDialog() {
            set_size_request(750, 600);
            _license_txt.buffer.text = ResourceUtil.get_string("/com/sqlnotebook/sqlnotebook-gui/license.txt");
        }

        [GtkCallback]
        private void close_btn_clicked() {
            destroy();
        }

        [GtkCallback]
        private void website_btn_clicked() {
            try {
                Gtk.show_uri_on_window(this, "https://sqlnotebook.com", Gdk.CURRENT_TIME);
            } catch (Error e) {
                show_browser_error();
            }
        }

        [GtkCallback]
        private void github_btn_clicked() {
            try {
                Gtk.show_uri_on_window(this, "https://github.com/electroly/sqlnotebook", Gdk.CURRENT_TIME);
            } catch (Error e) {
                show_browser_error();
            }
        }

        private void show_browser_error() {
            var d = new MessageDialog(this, DialogFlags.MODAL, MessageType.WARNING, ButtonsType.OK,
                    "Unable to open an external browser.");
            d.response.connect(response_id => {
                d.destroy();
            });
            d.show();
        }
    }
}
