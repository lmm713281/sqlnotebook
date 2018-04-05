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
using SqlNotebook;
using SqlNotebook.Errors;
using SqlNotebook.Persistence;

namespace SqlNotebook.Gui {
    /**
     * Updates a Gtk.TreeStore to match the contents of the {@link Notebook} on demand.
     */
    public class NotebookTreeStoreSync : Object {
        private Notebook _notebook; // readonly
        private Gtk.TreeStore _tree_store; // readonly
        private TreeGroup _consoles_tree_group; // readonly
        private TreeGroup _notes_tree_group; // readonly
        private TreeGroup _scripts_tree_group; // readonly
        private TreeGroup _tables_tree_group; // readonly
        private TreeGroup _views_tree_group; // readonly

        public NotebookTreeStoreSync(Notebook notebook, Gtk.TreeStore tree_store) {
            _notebook = notebook;
            _tree_store = tree_store;
        }

        public void initial_sync(NotebookLockToken token) throws RuntimeError {
            _consoles_tree_group = append_tree_group("Consoles");
            _notes_tree_group = append_tree_group("Notes");
            _scripts_tree_group = append_tree_group("Scripts");
            _tables_tree_group = append_tree_group("Tables");
            _views_tree_group = append_tree_group("Views");

            sync(token);
        }

        public void sync(NotebookLockToken token) throws RuntimeError {
            sync_group(_consoles_tree_group, NotebookItemKind.CONSOLE, token);
            sync_group(_notes_tree_group, NotebookItemKind.NOTE, token);
            sync_group(_scripts_tree_group, NotebookItemKind.SCRIPT, token);
            sync_group(_tables_tree_group, NotebookItemKind.TABLE, token);
            sync_group(_views_tree_group, NotebookItemKind.VIEW, token);
        }

        private void sync_group(TreeGroup tree_group, NotebookItemKind item_kind,
                NotebookLockToken token) throws RuntimeError {
            var notebook_names = _notebook.get_names_of_items_of_kind(item_kind, token);

            // add new items that have been created in the notebook
            foreach (var name in notebook_names) {
                if (!tree_group.items.has_key(name)) {
                    var tree_iter = append(tree_group.tree_iter, name);
                    tree_group.items.set(name, tree_iter);
                }
            }

            // remove items that have been removed from the notebook
            foreach (var name in tree_group.items.keys) {
                if (!notebook_names.contains(name)) {
                    var tree_iter = tree_group.items.get(name);
                    _tree_store.remove(ref tree_iter);
                    // don't bother removing from notebook_names because it's a throwaway collection
                }
            }
        }

        private TreeGroup append_tree_group(string text) {
            var tree_group = new TreeGroup() {
                tree_iter = append(null, text)
            };
            return tree_group;
        }

        private Gtk.TreeIter append(Gtk.TreeIter? parent, string text) {
            Gtk.TreeIter iter;
            _tree_store.append(out iter, parent);
            _tree_store.set(iter, 0, text, -1);
            return iter;
        }

        private class TreeGroup : Object {
            public HashMap<string, Gtk.TreeIter?> items = new HashMap<string, Gtk.TreeIter?>();
            public Gtk.TreeIter tree_iter;
        }
    }
}
