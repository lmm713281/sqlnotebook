#!/bin/bash
cd /source
mkdir -p bin-windows/
mkdir -p obj-windows/

python3 build/generate-meson.py > meson.build
chown --reference=.gitignore meson.build
ext/meson/meson.py --buildtype $BUILDTYPE --cross-file build/meson-windows.txt obj-windows/ 
ninja -C obj-windows/

cp -f /usr/x86_64-w64-mingw32/bin/libffi-6.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libiconv-2.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgettextlib-0-19-8-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgettextsrc-0-19-8-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpcre-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpcrecpp-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpcreposix-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libglib-2.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgmodule-2.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgobject-2.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libintl-8.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgio-2.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgtk-3-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/zlib1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgdk-3-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgdk_pixbuf-2.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libatk-1.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libcairo-2.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libepoxy-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libcairo-gobject-2.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpango-1.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpangocairo-1.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpangowin32-1.0-0.dll bin-windows/
cp -f /usr/lib/gcc/x86_64-w64-mingw32/6.3-win32/libgcc_s_seh-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libfontconfig-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libfreetype-6.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpixman-1-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpng16-16.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libpangoft2-1.0-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libexpat-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libbz2-1.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libharfbuzz-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libharfbuzz-gobject-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libharfbuzz-icu-0.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgraphite2.dll bin-windows/
cp -f /usr/x86_64-w64-mingw32/bin/libgee-0.8-2.dll bin-windows/
cp -f /usr/lib/gcc/x86_64-w64-mingw32/6.3-win32/libstdc++-6.dll bin-windows/
cp -f obj-windows/libsqlnotebook.dll bin-windows/
cp -f obj-windows/sqlnotebook.exe bin-windows/
cp -f obj-windows/sqlnotebook-gui.exe bin-windows/
x86_64-w64-mingw32-strip bin-windows/*.dll bin-windows/*.exe

chown --reference=.gitignore --recursive bin-windows/ obj-windows/
