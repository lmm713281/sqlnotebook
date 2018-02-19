#!/bin/bash

export BINDIR=/source/bin-windows-$1
export OBJDIR=/source/obj-windows-$1

cd /source
mkdir -p $BINDIR/
mkdir -p $OBJDIR/

python3 build/generate-meson.py > meson.build
chown --reference=.gitignore meson.build
ext/meson/meson.py --buildtype $1 --cross-file build/meson-windows.txt $OBJDIR/ 
ninja -C $OBJDIR/

cp -f /usr/x86_64-w64-mingw32/bin/libffi-6.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libiconv-2.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgettextlib-0-19-8-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgettextsrc-0-19-8-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpcre-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpcrecpp-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpcreposix-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libglib-2.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgmodule-2.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgobject-2.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libintl-8.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgio-2.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgtk-3-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/zlib1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgdk-3-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgdk_pixbuf-2.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libatk-1.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libcairo-2.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libepoxy-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libcairo-gobject-2.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpango-1.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpangocairo-1.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpangowin32-1.0-0.dll $BINDIR/
cp -f /usr/lib/gcc/x86_64-w64-mingw32/6.3-win32/libgcc_s_seh-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libfontconfig-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libfreetype-6.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpixman-1-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpng16-16.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libpangoft2-1.0-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libexpat-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libbz2-1.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libharfbuzz-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libharfbuzz-gobject-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libharfbuzz-icu-0.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgraphite2.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libgee-0.8-2.dll $BINDIR/
cp -f /usr/lib/gcc/x86_64-w64-mingw32/6.3-win32/libstdc++-6.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libjansson-4.dll $BINDIR/
cp -f /usr/x86_64-w64-mingw32/bin/libzip-5.dll $BINDIR/

cp -f $OBJDIR/libsqlnotebook.dll $BINDIR/
cp -f $OBJDIR/sqlnotebook.exe $BINDIR/
cp -f $OBJDIR/sqlnotebook-gui.exe $BINDIR/

chown --reference=.gitignore --recursive $BINDIR/ $OBJDIR/
