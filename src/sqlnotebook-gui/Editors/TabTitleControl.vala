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

using SqlNotebook.Gui.Utils;
using SqlNotebook.Persistence;

namespace SqlNotebook.Gui.Editors {
    [GtkTemplate(ui = "/com/sqlnotebook/sqlnotebook-gui/TabTitleControl.ui")]
    public class TabTitleControl : Gtk.EventBox {
        [GtkChild] private Gtk.Label _label;
        [GtkChild] private Gtk.Button _close_btn;
        [GtkChild] private Gtk.Image _close_img;
        [GtkChild] private Gtk.Image _console_img;
        [GtkChild] private Gtk.Image _note_img;
        [GtkChild] private Gtk.Image _script_img;

        private const int MIDDLE_BUTTON = 2;
        private NotebookItemKind _kind;

        // if the user presses the middle mouse button over the tab and then moves the mouse outside the tab
        // and releases the mouse button, then cancel the close operation that would otherwise happen.
        private bool _middle_click_in_progress = false;
        private bool _cancel_middle_click = false;

        public signal void close_tab();

        public TabTitleControl(NotebookItemKind kind, string text) {
            _kind = kind;
            set_title_text(text);
            update_tab_image(false);
        }

        public void set_title_text(string text) {
            _label.set_text(text);
        }

        public override bool enter_notify_event(Gdk.EventCrossing event) {
            if (_middle_click_in_progress) {
                _cancel_middle_click = false;
            }

            return false;
        }

        public override bool leave_notify_event(Gdk.EventCrossing event) {
            if (_middle_click_in_progress) {
                _cancel_middle_click = true;
            }

            return false;
        }

        [GtkCallback]
        private void close_btn_clicked() {
            close_tab();
        }

        [GtkCallback]
        private bool close_btn_enter_notify_event(Gdk.EventCrossing event) {
            update_tab_image(true);
            return false;
        }

        [GtkCallback]
        private bool close_btn_leave_notify_event(Gdk.EventCrossing event) {
            update_tab_image(false);
            return false;
        }

        public override bool button_press_event(Gdk.EventButton e) {
            if (e.button == MIDDLE_BUTTON) {
                _middle_click_in_progress = true;
                _cancel_middle_click = false;
            }

            return false;
        }

        public override bool button_release_event(Gdk.EventButton e) {
            if (e.button == MIDDLE_BUTTON && _middle_click_in_progress && !_cancel_middle_click) {
                close_tab();
            }

            _middle_click_in_progress = false;
            _cancel_middle_click = false;

            return false;
        }

        private void update_tab_image(bool mouse_inside) {
            if (mouse_inside) {
                _close_btn.set_image(_close_img);
            } else {
                switch (_kind) {
                    case NotebookItemKind.CONSOLE:
                        _close_btn.set_image(_console_img);
                        break;

                    case NotebookItemKind.NOTE:
                        _close_btn.set_image(_note_img);
                        break;

                    case NotebookItemKind.SCRIPT:
                        _close_btn.set_image(_script_img);
                        break;

                    default:
                        assert(false);
                        break;
                }
            }
        }
    }
}
