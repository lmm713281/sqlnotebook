#!/bin/sh

# derived from https://stackoverflow.com/a/7101577
here="${0%/*}"  # or you can use `dirname "$0"`

LD_LIBRARY_PATH="$here"/lib:"$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH
exec "$here"/bin/sqlnotebook-gui.bin "$@"
