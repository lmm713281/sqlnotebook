#!/bin/bash
cd /source
doctoc license.md
pandoc -f markdown -t plain --wrap=auto --columns=80 license.md | tail -n +6 > src/sqlnotebook-gui/resources/license.txt
chown --reference=.gitignore src/sqlnotebook-gui/resources/license.txt
