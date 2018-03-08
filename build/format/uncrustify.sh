#!/bin/bash
cd /source
find src/ | grep "\.vala$" | uncrustify -c build/format/uncrustify.vala.cfg --replace --no-backup -F -
find src/ | grep "\.vapi$" | uncrustify -c build/format/uncrustify.vala.cfg --replace --no-backup -F -
find src/ | grep "\.c$" | uncrustify -c build/format/uncrustify.vala.cfg --replace --no-backup -F -
find src/ | grep "\.h$" | uncrustify -c build/format/uncrustify.vala.cfg --replace --no-backup -F -
chown --reference=.gitignore --recursive src/
