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
using SqlNotebook.Interpreter;
using SqlNotebook.Interpreter.Ast;

namespace SqlNotebook.Tests {
    public class Test_ScriptParser : TestModule {
        private static ScriptParser _target;

        public override void go() throws Error {
            var library_factory = LibraryFactory.create();
            _target = library_factory.get_script_parser();

            Test.add_func("/ScriptParser/single_return", () => {
                try {
                    var script_node = _target.parse("RETURN");
                    if (!assert_eq_int(script_node.block.statements.size, 1, "script_node.block.statements.size")) {
                        return;
                    }
                    var statement = script_node.block.statements[0];
                    if (!assert_true(statement is ReturnStatementNode, "statement is ReturnStatementNode")) {
                        return;
                    }
                    var return_statement = (ReturnStatementNode)statement;
                    assert_true(return_statement.value == null, "return_statement.value == null");
                } catch (CompileError e) {
                    fail(e.message);
                }
            });
        }
    }
}
