# Copyright (c) 2016 - present Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.

OBJECTS = $(foreach source,$(SOURCES),$(basename $(source)).o)

include $(TESTS_DIR)/base.make
include $(TESTS_DIR)/clang-base.make

ONE_SOURCE = $(lastword $(SOURCES))

default: compile

compile: $(OBJECTS)

$(ONE_SOURCE).test.dot: $(CLANG_DEPS) $(SOURCES) $(HEADERS)
	$(QUIET)$(call silent_on_success,Testing the infer/clang frontend in $(TEST_REL_DIR),\
	  $(INFER_BIN) capture --frontend-tests --project-root $(TESTS_DIR) $(INFER_OPTIONS) -- \
	    clang $(CLANG_OPTIONS) $(SOURCES))

.PHONY: capture
capture: $(ONE_SOURCE).test.dot

.PHONY: print
print: capture

.PHONY: test
test: capture
	$(QUIET)for file in $(SOURCES) ; do \
	  diff -u $$file.dot $$file.test.dot || error=1 ; \
	done ; \
	if [ 0$$error -eq 1 ]; then exit 1; fi

.PHONY: replace
replace: capture
	$(QUIET)for file in $(SOURCES) ; do \
	  mv $$file.test.dot $$file.dot ; \
	done

.PHONY: clean
clean:
	$(REMOVE_DIR) infer-out $(OBJECTS) */*.test.dot */*/*.test.dot $(CLEAN_EXTRA)