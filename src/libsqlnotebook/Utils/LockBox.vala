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

using SqlNotebook.Errors;

namespace SqlNotebook.Utils {
    public class LockBox : Object {
        private Mutex _mutex = Mutex();
        private bool _is_entered = false;
        private int _proof_value = 0;

        public LockBoxKey enter() {
            _mutex.lock ();

            assert(!_is_entered);
            _is_entered = true;

            var key = LockBoxKey() {
                proof = ++_proof_value
            };

            return key;
        }

        public void check(LockBoxKey key) {
            assert(_is_entered);
            assert(key.proof == _proof_value);
        }

        public void exit(LockBoxKey key) {
            assert(_is_entered);
            assert(key.proof == _proof_value);

            _proof_value++;
            _is_entered = false;
            _mutex.unlock();
        }
    }
}
