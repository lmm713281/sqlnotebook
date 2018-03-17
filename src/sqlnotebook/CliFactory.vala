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

namespace SqlNotebook.Cli {
    public class CliFactory : Object {
        private LibraryFactory _library_factory;

        private CliFactory() {
        }

        public static CliFactory create() throws RuntimeError {
            var f = new CliFactory();
            f._library_factory = LibraryFactory.create();
            return f;
        }

        public CommandPrompt get_command_prompt() {
            var script_parser = _library_factory.get_script_parser();
            var script_environment = _library_factory.get_script_environment();
            var command_prompt = new CommandPrompt(_library_factory, script_parser, script_environment);
            return command_prompt;
        }

        public LibraryFactory get_library_factory() {
            return _library_factory;
        }
    }
}
