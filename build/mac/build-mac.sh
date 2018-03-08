#!/bin/bash

function run_install_name_tool() {
    # $1 = library filename
    # $2 = executable filename
    install_name_tool -change "$(find obj-mac/homebrew/Cellar -name $1 -print -quit)" @executable_path/$1 bin-mac/$2
}

function copy_library() {
    # $1 = library filename
    cp -f "$(find obj-mac/homebrew/Cellar -name $1 -print -quit)" bin-mac/
    run_install_name_tool $1 libsqlnotebook.dylib
    run_install_name_tool $1 sqlnotebook
}

# ---

set -eux

mkdir -p bin-mac/
mkdir -p obj-mac/

# homebrew
pushd obj-mac
[[ ! -d homebrew ]] && git clone --depth 1 https://github.com/mxcl/homebrew.git
export PATH=$(pwd)/homebrew/bin:$PATH
brew update
brew install xz vala python3 ninja gtk+3 libiconv pango libgee jansson
popd

# gtk-mac-bundler
if [ ! -f "~/.local/bin/gtk-mac-bundler" ]; then
    pushd obj-mac
    [[ ! -d gtk-mac-bundler ]] && git clone --depth 1 https://github.com/jralls/gtk-mac-bundler.git
    pushd gtk-mac-bundler
    make install
    popd
    popd
fi
export PATH=~/.local/bin:$PATH

python3 build/generate-meson.py > meson.build
ext/meson/meson.py --buildtype $1 obj-mac/
ninja -C obj-mac/

# sqlnotebook
cp -f obj-mac/libsqlnotebook.dylib bin-mac/
cp -f obj-mac/sqlnotebook bin-mac/
install_name_tool -change @rpath/libsqlnotebook.dylib @executable_path/libsqlnotebook.dylib bin-mac/sqlnotebook
copy_library libffi.6.dylib
copy_library libiconv.2.dylib
copy_library libgettextlib-0.19.8.1.dylib
copy_library libgettextsrc-0.19.8.1.dylib
copy_library libpcre.1.dylib
copy_library libpcrecpp.0.dylib
copy_library libpcreposix.0.dylib
copy_library libgio-2.0.0.dylib
copy_library libglib-2.0.0.dylib
copy_library libgmodule-2.0.0.dylib
copy_library libgobject-2.0.0.dylib
copy_library libintl.8.dylib
chmod +w bin-mac/*
run_install_name_tool libgobject-2.0.0.dylib libgio-2.0.0.dylib
run_install_name_tool libffi.6.dylib libgio-2.0.0.dylib
run_install_name_tool libgmodule-2.0.0.dylib libgio-2.0.0.dylib
run_install_name_tool libglib-2.0.0.dylib libgio-2.0.0.dylib
run_install_name_tool libpcre.1.dylib libgio-2.0.0.dylib
run_install_name_tool libintl.8.dylib libgio-2.0.0.dylib
run_install_name_tool libiconv.2.dylib libgio-2.0.0.dylib
run_install_name_tool libpcre.1.dylib libglib-2.0.0.dylib
run_install_name_tool libintl.8.dylib libglib-2.0.0.dylib
run_install_name_tool libiconv.2.dylib libglib-2.0.0.dylib
run_install_name_tool libglib-2.0.0.dylib libgmodule-2.0.0.dylib
run_install_name_tool libpcre.1.dylib libgmodule-2.0.0.dylib
run_install_name_tool libintl.8.dylib libgmodule-2.0.0.dylib
run_install_name_tool libiconv.2.dylib libgmodule-2.0.0.dylib
run_install_name_tool libglib-2.0.0.dylib libgobject-2.0.0.dylib
run_install_name_tool libpcre.1.dylib libgobject-2.0.0.dylib
run_install_name_tool libffi.6.dylib libgobject-2.0.0.dylib
run_install_name_tool libintl.8.dylib libgobject-2.0.0.dylib
run_install_name_tool libiconv.2.dylib libgobject-2.0.0.dylib
run_install_name_tool libiconv.2.dylib libintl.8.dylib
strip bin-mac/*.dylib bin-mac/sqlnotebook 2> /dev/null || true

# sqlnotebook-gui
export HOMEBREW_PREFIX=$(pwd)/obj-mac/homebrew
export PKG_CONFIG_PATH=$(pwd)/obj-mac/homebrew/lib/pkgconfig
cp -f /usr/lib/charset.alias obj-mac/homebrew/lib/
rm -rf "obj-mac/mac-bundle" "obj-mac/sqlnotebook-gui.app"
mkdir "obj-mac/mac-bundle"
pushd "build/mac-bundle"
cp -f * "../../obj-mac/mac-bundle/"
popd
iconutil -c icns -o "obj-mac/mac-bundle/sqlnotebook-gui.icns" art/sqlnotebook-gui.iconset
pushd "obj-mac/mac-bundle"
cp -f ../sqlnotebook-gui .
cp -f ../libsqlnotebook.dylib .
gtk-mac-bundler sqlnotebook-gui.bundle
popd
