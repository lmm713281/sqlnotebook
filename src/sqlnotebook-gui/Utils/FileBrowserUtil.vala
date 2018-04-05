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
using Gtk;
using SqlNotebook.Utils;

namespace SqlNotebook.Gui.Utils.FileBrowserUtil {
    public string? open_file(Window? parent, string title, string filter_name, ArrayList<string> filter_extensions) {
        string file_path;
        var native_result = NativeFileBrowserUtil.run_open_file_dialog(
                title, filter_name, StringUtil.join_strings(";", filter_extensions), out file_path);

        if (native_result == 1) {
            // user selected a file
            return file_path;
        } else if (native_result == 0) {
            // user canceled
            return null;
        } else {
            // fall back to gtk dialog
            var w = new FileChooserNative(
                    /* title */ title,
                    /* parent */ parent,
                    /* action */ FileChooserAction.OPEN,
                    /* accept_label */ "Open",
                    /* cancel_label */ "Cancel");
            w.set_modal(true);
            w.set_transient_for(parent);

            var filter = new FileFilter();
            filter.set_filter_name(filter_name);
            foreach (var extension in filter_extensions) {
                filter.add_pattern(extension);
            }
            w.add_filter(filter);

            if (w.run() == ResponseType.ACCEPT) {
                return w.get_filename();
            } else {
                return null;
            }
        }
    }
}
