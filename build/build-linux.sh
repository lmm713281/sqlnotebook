#!/bin/bash

export BINDIR=/source/bin-linux-$1
export OBJDIR=/source/obj-linux-$1

cd /source
mkdir -p $BINDIR
mkdir -p $OBJDIR

python3 build/generate-meson.py > meson.build
chown --reference=.gitignore meson.build
ext/meson/meson.py --buildtype $1 $OBJDIR/
ninja -C $OBJDIR/

cp -f $OBJDIR/libsqlnotebook.so $BINDIR/
cp -f $OBJDIR/sqlnotebook $BINDIR/
cp -f $OBJDIR/sqlnotebook-gui $BINDIR/

strip $BINDIR/libsqlnotebook.so
strip $BINDIR/sqlnotebook
strip $BINDIR/sqlnotebook-gui

chown --reference=.gitignore --recursive $BINDIR/ $OBJDIR/
