CC=/usr/bin/gcc
CXX=/usr/bin/g++

.DEFAULT_GOAL := help


.PHONY: help
help: ## Show this help message.
	@echo 'usage: make [target] ...'
	@echo ''
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'


.PHONY: clean
clean: ## clean build folder
	rm -rf build/*


.PHONY: format
format: ## code formatting for c++ files
	clang-format src/* -i


.PHONY: build
build: ## build app for release
	mkdir -p build && \
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release .. && \
	make


.PHONY: rebuild ## rebuild app for release
rebuild: clean build


.PHONY: build_debug
build_debug: ## build the app for debugging
	mkdir -p build
	cd build && \
	export LSAN_OPTION=verbosity=1:log_threads=1; cmake -DCMAKE_BUILD_TYPE=Debug .. && \
	export LSAN_OPTION=verbosity=1:log_threads=1; make


.PHONY: run
run: ## run the app
	cd build && \
	./membot


.PHONY: debug
debug: ## debug the app
	cd build && \
	export LSAN_OPTION=verbosity=1:log_threads=1; gdb ./membot


.PHONY: build-and-run
build-and-run: build run ## build app for release and run it

.PHONY: build-and-debug
build-and-debug: build_debug debug ## build app for debugging and run it

.PHONY: rebuild-and-run
rebuild-and-run: rebuild run ## rebuild app for release and run it

.PHONY: rebuild-and-debug
rebuild-and-debug: clean build_debug debug ## rebuild app for debugging and run it
