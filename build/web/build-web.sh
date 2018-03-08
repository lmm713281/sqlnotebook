#!/bin/bash
cd /source

export BINDIR=/source/bin-web
export OBJDIR=/source/obj-web

rm -rf $BINDIR/ $OBJDIR/

python3 build/web/build-web.py

chown --reference=.gitignore --recursive $BINDIR/ $OBJDIR/
