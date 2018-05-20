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

namespace SqlNotebook.Gui.Editors {
    [GtkTemplate(ui = "/com/sqlnotebook/sqlnotebook-gui/NoteControl.ui")]
    public class NoteControl : Gtk.Grid {
        private FontFamilyComboBox _font_family_cmb;
        private FontSizeComboBox _font_size_cmb;
        private weak Gtk.TextTag _bold_tag;
        private weak Gtk.TextTag _italic_tag;
        private weak Gtk.TextTag _underline_tag;
        private weak Gtk.TextTag _serif_tag;
        private weak Gtk.TextTag _monospace_tag;
        private weak Gtk.TextTag _small_size_tag;
        private weak Gtk.TextTag _large_size_tag;
        private bool _suppress_btn_click_event = false;

        [GtkChild] private Gtk.ToggleToolButton _bold_btn;
        [GtkChild] private Gtk.ToggleToolButton _italic_btn;
        [GtkChild] private Gtk.ToggleToolButton _underline_btn;
        [GtkChild] private Gtk.ToolItem _font_family_tool_item;
        [GtkChild] private Gtk.ToolItem _font_size_tool_item;
        [GtkChild] private Gtk.TextBuffer _text_buffer;

        public NoteControl() {
            _font_family_cmb = new FontFamilyComboBox();
            _font_family_tool_item.add(_font_family_cmb);
            _font_family_cmb.changed.connect(font_family_cmb_changed);

            _font_size_cmb = new FontSizeComboBox();
            _font_size_tool_item.add(_font_size_cmb);
            _font_size_cmb.changed.connect(font_size_cmb_changed);

            _bold_tag = _text_buffer.create_tag("sqlnb_bold", "weight", Pango.Weight.BOLD, null);
            _italic_tag = _text_buffer.create_tag("sqlnb_italic", "style", Pango.Style.ITALIC, null);
            _underline_tag = _text_buffer.create_tag("sqlnb_underline", "underline", Pango.Underline.SINGLE, null);
            _serif_tag = _text_buffer.create_tag("sqlnb_serif", "family", "serif", null);
            _monospace_tag = _text_buffer.create_tag("sqlnb_monospace", "family", "monospace", null);
            _small_size_tag = _text_buffer.create_tag("sqlnb_small_size", "size_points", 8d, null);
            _large_size_tag = _text_buffer.create_tag("sqlnb_large_size", "size_points", 16d, null);
        }

        [GtkCallback]
        private void bold_btn_clicked() {
            if (!_suppress_btn_click_event) {
                apply_or_remove_text_tag(_bold_tag, _bold_btn.get_active());
            }
        }

        [GtkCallback]
        private void italic_btn_clicked() {
            if (!_suppress_btn_click_event) {
                apply_or_remove_text_tag(_italic_tag, _italic_btn.get_active());
            }
        }

        [GtkCallback]
        private void underline_btn_clicked() {
            if (!_suppress_btn_click_event) {
                apply_or_remove_text_tag(_underline_tag, _underline_btn.get_active());
            }
        }

        [GtkCallback]
        private void text_buffer_cursor_position_changed() {
            var bold = false, italic = false, underline = false,
                serif = false, monospace = false,
                small = false, large = false;

            Gtk.TextIter start_iter, end_iter;
            if (_text_buffer.get_selection_bounds(out start_iter, out end_iter)) {
                // a selection exists
                bold = TextIterUtil.entire_range_has_tag(_bold_tag, start_iter, end_iter);
                italic = TextIterUtil.entire_range_has_tag(_italic_tag, start_iter, end_iter);
                underline = TextIterUtil.entire_range_has_tag(_underline_tag, start_iter, end_iter);

                serif = TextIterUtil.entire_range_has_tag(_serif_tag, start_iter, end_iter);
                monospace = TextIterUtil.entire_range_has_tag(_monospace_tag, start_iter, end_iter);

                small = TextIterUtil.entire_range_has_tag(_small_size_tag, start_iter, end_iter);
                large = TextIterUtil.entire_range_has_tag(_large_size_tag, start_iter, end_iter);
            } else {
                // no selection exists
                var insert_mark = _text_buffer.get_insert();
                _text_buffer.get_iter_at_mark(out start_iter, insert_mark);

                // use the format of the character before the insertion point, not the one after it
                start_iter.backward_char(); // fails if we're already at the beginning

                bold = start_iter.has_tag(_bold_tag);
                italic = start_iter.has_tag(_italic_tag);
                underline = start_iter.has_tag(_underline_tag);

                serif = start_iter.has_tag(_serif_tag);
                monospace = start_iter.has_tag(_monospace_tag);

                small = start_iter.has_tag(_small_size_tag);
                large = start_iter.has_tag(_large_size_tag);
            }

            _suppress_btn_click_event = true;

            _bold_btn.set_active(bold);
            _italic_btn.set_active(italic);
            _underline_btn.set_active(underline);

            _font_family_cmb.set_font_family(
                    serif ? FontFamily.SERIF :
                    monospace ? FontFamily.MONOSPACE :
                    FontFamily.SANS_SERIF);

            _font_size_cmb.set_font_size(
                    large ? FontSize.LARGE :
                    small ? FontSize.SMALL :
                    FontSize.NORMAL);

            _suppress_btn_click_event = false;
        }

        private void font_family_cmb_changed() {
            if (!_suppress_btn_click_event) {
                var font_family = _font_family_cmb.get_font_family();

                var tag = get_font_family_tag(font_family);

                if (tag != _serif_tag) {
                    apply_or_remove_text_tag(_serif_tag, false);
                }

                if (tag != _monospace_tag) {
                    apply_or_remove_text_tag(_monospace_tag, false);
                }

                apply_or_remove_text_tag(tag, true);
            }
        }

        private void font_size_cmb_changed() {
            if (!_suppress_btn_click_event) {
                var font_size = _font_size_cmb.get_font_size();

                var tag = get_font_size_tag(font_size);

                if (tag != _small_size_tag) {
                    apply_or_remove_text_tag(_small_size_tag, false);
                }

                if (tag != _large_size_tag) {
                    apply_or_remove_text_tag(_large_size_tag, false);
                }

                apply_or_remove_text_tag(tag, true);
            }
        }

        private void apply_or_remove_text_tag(Gtk.TextTag? tag, bool apply) {
            if (tag == null) {
                return;
            }
            
            Gtk.TextIter start_iter, end_iter;
            if (!_text_buffer.get_selection_bounds(out start_iter, out end_iter)) {
                var insert_mark = _text_buffer.get_insert();
                _text_buffer.get_iter_at_mark(out start_iter, insert_mark);
                end_iter = start_iter;
            }

            if (apply) {
                _text_buffer.apply_tag(tag, start_iter, end_iter);
            } else {
                _text_buffer.remove_tag(tag, start_iter, end_iter);
            }
        }

        private unowned Gtk.TextTag? get_font_family_tag(FontFamily font_family) {
            switch (font_family) {
                case FontFamily.MONOSPACE:
                    return _monospace_tag;

                case FontFamily.SANS_SERIF:
                    return null;

                case FontFamily.SERIF:
                    return _serif_tag;

                default:
                    assert(false);
                    return null;
            }
        }

        private unowned Gtk.TextTag? get_font_size_tag(FontSize font_size) {
            switch (font_size) {
                case FontSize.SMALL:
                    return _small_size_tag;

                case FontSize.NORMAL:
                    return null;

                case FontSize.LARGE:
                    return _large_size_tag;

                default:
                    assert(false);
                    return null;
            }
        }
    }
}
