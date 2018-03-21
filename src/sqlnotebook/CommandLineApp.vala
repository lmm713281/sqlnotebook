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
    public class CommandLineApp : Object {
        private static bool _version = false;

        [CCode(array_length = false, array_null_terminated = true)]
        private static string[]? _filenames = null;

        private const OptionEntry[] _options = {
            { "version", 0, 0, OptionArg.NONE, ref _version, "Display version information", null },
            { "", 0, 0, OptionArg.FILENAME_ARRAY, ref _filenames, null, "[file]" },
            { null }
        };

        public static int main(string[] args) {
            Intl.setlocale();

            if (!parse_args(args)) {
                return Posix.EXIT_FAILURE;
            }

            if (_filenames != null && _filenames.length > 1) {
                var message = "Please specify at most one notebook filename.";
                stderr.printf("%s\n", message);
                return Posix.EXIT_FAILURE;
            }

            try {
                var cli_factory = CliFactory.create();
                var library_factory = cli_factory.get_library_factory();

                stdout.printf("SQL Notebook %s\n", library_factory.get_app_version());

                if (_version) {
                    return Posix.EXIT_SUCCESS;
                }

                stdout.printf("Enter \".help\" for usage hints.\n");

                var command_prompt = cli_factory.get_command_prompt();
                command_prompt.run();

                return Posix.EXIT_SUCCESS;
            } catch (RuntimeError e) {
                stderr.printf("%s\n", e.message);
                return Posix.EXIT_FAILURE;
            }
        }

        private static bool parse_args(string[] args) {
            var context = new OptionContext("");
            context.add_main_entries(_options, null);

            try {
                unowned string[] args_unowned = args;
                context.parse(ref args_unowned);
            } catch (OptionError e) {
                stderr.printf("%s\n", e.message);
                return false;
            }

            return true;
        }
    }
}
