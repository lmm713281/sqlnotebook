#!/bin/bash
cd /source
find src/ | grep "\.vala$" | uncrustify -c build/uncrustify.vala.cfg --replace --no-backup -F -
chown --reference=.gitignore --recursive src/

