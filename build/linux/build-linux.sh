#!/bin/bash

export BINDIR=/source/bin-linux-$1
export OBJDIR=/source/obj-linux-$1
export PKGROOT=$BINDIR/sqlnotebook
export PKGDIR=$PKGROOT/opt/sqlnotebook

cd /source
mkdir -p $PKGDIR
mkdir -p $PKGDIR/bin
mkdir -p $PKGDIR/lib
mkdir -p $OBJDIR

python3 build/generate-meson.py > meson.build
chown --reference=.gitignore meson.build
ext/meson/meson.py --buildtype $1 $OBJDIR/
ninja -C $OBJDIR/

cp -f $OBJDIR/libsqlnotebook.so $PKGDIR/lib/
cp -f $OBJDIR/sqlnotebook $PKGDIR/bin/sqlnotebook.bin
cp -f $OBJDIR/sqlnotebook-gui $PKGDIR/bin/sqlnotebook-gui.bin

# generate these copy statements by uncommenting the command below and then running a build
#LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" \
    #ldd \
        #bin-linux-debug/sqlnotebook/opt/sqlnotebook/lib/libsqlnotebook.so \
        #bin-linux-debug/sqlnotebook/opt/sqlnotebook/bin/sqlnotebook.bin \
        #bin-linux-debug/sqlnotebook/opt/sqlnotebook/bin/sqlnotebook-gui.bin \
    #| grep -v libsqlnotebook \
    #| grep -v libX \
    #| grep -v libwayland \
    #| awk '{ print "cp -f " $3 " $PKGDIR/lib/" }' \
    #| grep -v "^cp -f /lib/" \
    #| grep -v "0x0" \
    #| grep -v "  " \
    #| sort \
    #| uniq

cp -f /usr/lib/x86_64-linux-gnu/libatk-1.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libatk-bridge-2.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libatspi.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.62.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libboost_system.so.1.62.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libcairo-gobject.so.2 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libcairo.so.2 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libcapnp-0.5.3.so $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libdatrie.so.1 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libepoxy.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libffi.so.6 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libfontconfig.so.1 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libfreetype.so.6 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgdk-3.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgee-0.8.so.2 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgio-2.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgmodule-2.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgraphite2.so.3 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libgtk-3.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libharfbuzz.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libjansson.so.4 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libkj-0.5.3.so $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/liblz4.so.1 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libmirclient.so.9 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libmircommon.so.7 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libmircore.so.1 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libmirprotobuf.so.3 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libpango-1.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libpangocairo-1.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libpangoft2-1.0.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libpixman-1.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libpng16.so.16 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libprotobuf-lite.so.10 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libstdc++.so.6 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libthai.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libxcb-render.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libxcb-shm.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libxcb.so.1 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libxkbcommon.so.0 $PKGDIR/lib/
cp -f /usr/lib/x86_64-linux-gnu/libzip.so.4 $PKGDIR/lib/

# swap in the launcher script
cp -f $OBJDIR/linux-launcher $PKGDIR/sqlnotebook-gui
chmod +x $PKGDIR/sqlnotebook-gui
cp -f $OBJDIR/linux-launcher $PKGDIR/sqlnotebook
chmod +x $PKGDIR/sqlnotebook

if [ $1 == "release" ]
then
    # set up desktop icon
    mkdir -p $PKGROOT/usr/share/applications
    mkdir -p $PKGROOT/usr/share/icons/hicolor/48x48/apps/
    cp -f build/linux/sqlnotebook-gui.desktop $PKGROOT/usr/share/applications/
    cp -f art/sqlnotebook_256.png $PKGROOT/usr/share/icons/hicolor/48x48/apps/sqlnotebook-gui.png

    # create .deb
    mkdir -p $BINDIR/sqlnotebook/DEBIAN
    cp -f build/linux/deb-control $BINDIR/sqlnotebook/DEBIAN/control
    pushd $BINDIR
    dpkg-deb --build sqlnotebook
    popd

    # create .tar.gz
    pushd $PKGROOT/opt
    tar zcf $BINDIR/sqlnotebook.tar.gz sqlnotebook/
    popd
fi

echo "$PKGDIR/sqlnotebook \"\$@\"" > run.sh
echo $PKGDIR/sqlnotebook-gui > run-gui.sh

chown --reference=.gitignore --recursive $BINDIR/ $OBJDIR/
