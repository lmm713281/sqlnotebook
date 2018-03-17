# SQL Notebook
# Copyright (C) 2018 Brian Luft
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.PHONY: all
all: linux-debug

.PHONY: clean
clean:
	rm -rf obj-linux-debug bin-linux-debug obj-windows-debug bin-windows-debug obj-mac bin-mac
	rm -rf obj-linux-release bin-linux-release obj-windows-release bin-windows-release
	rm -rf obj-web bin-web bin-valadoc
	rm -f meson.build run.sh run-gui.sh
	rm -f temp-jekyll
	find src -name "*.vala.uncrustify" -delete

.PHONY: run
run:
	@./run.sh $(ARGS)

.PHONY: run-gui
run-gui:
	@./run-gui.sh
	
.PHONY: linux-debug
linux-debug:
	PLATFORM=linux BUILDTYPE=debug make internal-docker-build

.PHONY: linux-release
linux-release:
	PLATFORM=linux BUILDTYPE=release make internal-docker-build

.PHONY: windows-debug
windows-debug:
	PLATFORM=windows BUILDTYPE=debug make internal-docker-build

.PHONY: windows-release
windows-release:
	PLATFORM=windows BUILDTYPE=release make internal-docker-build

.PHONY: mac-debug
mac-debug:
	-rm -rf obj-$(PLATFORM)-$(BUILDTYPE)/meson-*
	-rm -f obj-$(PLATFORM)-$(BUILDTYPE)/resources.*
	BUILDTYPE=debug /bin/bash build/mac/build-mac.sh

.PHONY: mac-release
mac-release:
	-rm -rf obj-$(PLATFORM)-$(BUILDTYPE)/meson-*
	-rm -f obj-$(PLATFORM)-$(BUILDTYPE)/resources.*
	BUILDTYPE=release /bin/bash build/mac/build-mac.sh

.PHONY: format
format:
	docker build -t sqlnotebook-uncrustify -f build/format/Dockerfile.uncrustify .
	docker run --rm -t -v "$(CURDIR)":/source sqlnotebook-uncrustify /bin/bash /source/build/format/uncrustify.sh

.PHONY: test
test: linux-debug
	bin-linux-debug/sqlnotebook/opt/sqlnotebook/tests --verbose

.PHONY: license
license:
	docker build -t sqlnotebook-build-web -f build/web/Dockerfile.build-web .
	docker run --rm -t -v "$(CURDIR)":/source sqlnotebook-build-web /bin/bash /source/build/license/generate-license.sh

.PHONY: web
web:
	docker build -t sqlnotebook-build-web -f build/web/Dockerfile.build-web .
	docker run -i --rm -t -v "$(CURDIR)":/source sqlnotebook-build-web /bin/bash /source/build/web/build-web.sh

.PHONY: web-serve
web-serve:
	cd bin-web && python3 -m http.server 8080

.PHONY: valadoc
valadoc:
	docker build -t sqlnotebook-build-linux -f build/linux/Dockerfile.build-linux .
	docker run --rm -i -t -v "$(CURDIR)":/source sqlnotebook-build-linux /bin/bash /source/build/valadoc/build-valadoc.sh

.PHONY: valadoc-serve
valadoc-serve:
	cd bin-valadoc && python3 -m http.server 8081

# do not call directly from the command line
.PHONY: internal-docker-build
internal-docker-build:
	-rm -rf obj-$(PLATFORM)-$(BUILDTYPE)/meson-*
	-rm -f obj-$(PLATFORM)-$(BUILDTYPE)/resources.*
	echo 'bin-$(PLATFORM)-$(BUILDTYPE)/sqlnotebook "$@"' > run.sh
	echo "bin-$(PLATFORM)-$(BUILDTYPE)/sqlnotebook-gui" > run-gui.sh
	docker build -t sqlnotebook-build-$(PLATFORM) -f build/$(PLATFORM)/Dockerfile.build-$(PLATFORM) .
	docker run --rm -i -t -v "$(CURDIR)":/source sqlnotebook-build-$(PLATFORM) /bin/bash /source/build/$(PLATFORM)/build-$(PLATFORM).sh $(BUILDTYPE)
	chmod +x run.sh
	chmod +x run-gui.sh
