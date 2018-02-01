#!/bin/bash

cd /source
mkdir -p bin-linux/
mkdir -p obj-linux/

python3 build/generate-meson.py > meson.build
chown --reference=.gitignore meson.build
ext/meson/meson.py obj-linux/
ninja -C obj-linux/

cp -f obj-linux/libsqlnotebook.so bin-linux/
cp -f obj-linux/sqlnotebook bin-linux/
cp -f obj-linux/sqlnotebook-gui bin-linux/

strip bin-linux/libsqlnotebook.so
strip bin-linux/sqlnotebook
strip bin-linux/sqlnotebook-gui

chown --reference=.gitignore --recursive bin-linux/ obj-linux/
