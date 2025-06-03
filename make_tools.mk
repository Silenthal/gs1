MAKEFLAGS += --no-print-directory

TOOLS_DIR := tools
TOOL_NAMES := pack_strings unpack_strings unpack_overlay

TOOLDIRS := $(TOOL_NAMES:%=$(TOOLS_DIR)/%)

.PHONY: tools clean-tools $(TOOLDIRS)

tools: $(TOOLDIRS)

$(TOOLDIRS):
	@$(MAKE) -C $@

clean-tools:
	@$(foreach tooldir,$(TOOLDIRS),$(MAKE) clean -C $(tooldir);)