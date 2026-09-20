.PHONY: test test-fast test-integration build-parser fetch-nvim-treesitter clean

# nvim-treesitter branch the integration suite installs against.
TS_BRANCH ?= main
XDG_BUILD_DIR := $(CURDIR)/test/.build/xdg

build-parser:
	bash scripts/build_parser.sh

test-fast: build-parser
	nvim --headless --noplugin -u test/minimal_init.lua \
		-c "lua require('plenary.test_harness').test_directory('test/spec', { minimal_init = 'test/minimal_init.lua' })"

# Separate, untimed step -- see scripts/fetch_nvim_treesitter.sh for why.
fetch-nvim-treesitter:
	bash scripts/fetch_nvim_treesitter.sh $(TS_BRANCH)

test-integration: build-parser fetch-nvim-treesitter
	mkdir -p $(XDG_BUILD_DIR)/data $(XDG_BUILD_DIR)/state $(XDG_BUILD_DIR)/cache
	XDG_DATA_HOME=$(XDG_BUILD_DIR)/data \
	XDG_STATE_HOME=$(XDG_BUILD_DIR)/state \
	XDG_CACHE_HOME=$(XDG_BUILD_DIR)/cache \
	TS_BRANCH=$(TS_BRANCH) \
	nvim --headless --noplugin -u test/integration/minimal_init.lua \
		-c "lua require('plenary.test_harness').test_directory('test/integration/spec', { minimal_init = 'test/integration/minimal_init.lua', timeout = 180000 })"

test: test-fast test-integration

clean:
	rm -rf test/.build
