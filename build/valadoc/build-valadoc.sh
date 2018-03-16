#!/bin/bash
cd /source
rm -rf bin-valadoc/
valadoc \
    -o bin-valadoc/ \
    --use-svg-images \
    --package-name=sqlnotebook \
    --pkg=gio-2.0 \
    --pkg=glib-2.0 \
    --pkg=gobject-2.0 \
    --pkg=gmodule-2.0 \
    --pkg=gtk+-3.0 \
    --pkg=gee-0.8 \
    --pkg=posix \
    $(find ext/vapi/ -iname '*.vapi' -printf "/source/%p ") \
    $(find src/ -iname '*.vapi' -printf "/source/%p ") \
    $(find src/ -iname '*.vala' -not -iname '*App.vala' -printf "/source/%p ")
echo "div.site_navigation { width: 400px !important; }" >> bin-valadoc/style.css
echo "div.site_content { margin-left: 420px !important; }" >> bin-valadoc/style.css
echo "ul.navi_inline li.namespace { margin-top: 50px !important; border-top: 1px solid black; }" >> bin-valadoc/style.css
chown --reference=.gitignore --recursive bin-valadoc/
