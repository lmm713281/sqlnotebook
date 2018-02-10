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
all: linux

.PHONY: run
run: linux
	bin-linux/glance

.PHONY: clean
clean:
	rm -rf obj-linux bin-linux obj-windows bin-windows obj-mac bin-mac meson.build
	find src -name "*.vala.uncrustify" -delete

# build for linux, requires docker
.PHONY: linux
linux:
	PLATFORM=linux make internal-docker-build

# build for windows, requires docker
.PHONY: windows
windows:
	PLATFORM=windows make internal-docker-build

# build for mac, requires an actual mac
.PHONY: mac
mac:
	/bin/bash build/build-mac.sh

.PHONY: format
format:
	docker build -t sqlnotebook-uncrustify -f build/Dockerfile.uncrustify .
	docker run --rm -t -v "$(CURDIR)":/source sqlnotebook-uncrustify /bin/bash /source/build/uncrustify.sh

.PHONY: test
test: linux
	obj-linux/tests --verbose

.PHONY: doc
doc: internal-doctoc
	
.PHONY: internal-doctoc
internal-doctoc:
	docker build -t sqlnotebook-doctoc -f build/Dockerfile.doctoc .
	docker run --rm -t -v "$(CURDIR)":/source sqlnotebook-doctoc /bin/bash /source/build/doctoc.sh

.PHONY: internal-docker-build
internal-docker-build:
	docker build -t sqlnotebook-build-$(PLATFORM) -f build/Dockerfile.build-$(PLATFORM) .
	docker run -i --rm -t -v "$(CURDIR)":/source sqlnotebook-build-$(PLATFORM) /bin/bash /source/build/build-$(PLATFORM).sh
