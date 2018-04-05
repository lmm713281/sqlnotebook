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

namespace SqlNotebook.Gui {
    public class App : Gtk.Application {
        private Gtk.CssProvider _css_provider;

        public App() {
            Object(application_id: "com.sqlnotebook.SqlNotebook", flags: ApplicationFlags.FLAGS_NONE);
        }

        protected override void activate() {
            var screen = Gdk.Screen.get_default();
            _css_provider = new Gtk.CssProvider();
            _css_provider.load_from_resource("/com/sqlnotebook/sqlnotebook-gui/App.css");
            Gtk.StyleContext.add_provider_for_screen(
                    screen, _css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            LibraryFactory library_factory;
            try {
                library_factory = LibraryFactory.create();
            } catch (RuntimeError e) {
                assert(false);
                return;
            }
            var app_window = new AppWindow(this, library_factory);
            app_window.show_all();
        }

        public static int main(string[] args) {
            Intl.setlocale();

            var app = new App();
            return app.run(args);
        }
    }
}
