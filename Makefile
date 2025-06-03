include make_tools.mk

TARGET			:= goldensun
BASE			:= baserom

TOOLS_DIR		:= $(CURDIR)/tools

PACK_STRINGS	:= $(TOOLS_DIR)/pack_strings/pack_strings
UNPACK_STRINGS	:= $(TOOLS_DIR)/unpack_strings/unpack_strings
UNPACK_OVERLAY	:= $(TOOLS_DIR)/unpack_overlay/unpack_overlay

PREFIX := arm-none-eabi-
OBJCOPY := $(PREFIX)objcopy
AS := $(PREFIX)as
LD := $(PREFIX)ld

ASFLAGS := -mcpu=arm7tdmi

# Default target. Verify the checksums of the built ROM and overlays.

ROM := $(TARGET).gba
OVERLAYS := $(patsubst %.sha1,%.bin,$(wildcard overlays/*/overlay.sha1))

COMPARE_OVERLAYS := $(OVERLAYS:%.bin=compare-%)

.PHONY: $(ROM) compare compare-goldensun $(COMPARE_OVERLAYS)
compare: compare-goldensun $(COMPARE_OVERLAYS)

compare-goldensun $(COMPARE_OVERLAYS):
	sha1sum -c $<

compare-goldensun: $(TARGET).sha1 $(ROM)

$(COMPARE_OVERLAYS): compare-%: %.sha1 %.bin


# Clean target.
.PHONY: clean
clean::


# Build ARM binaries from assembly sources.

%.o: %.s
	$(AS) $(ASFLAGS) -Iinclude -MD $(@:.o=.d) -o $@ $<

%.elf: %.ld
	$(LD) -T $< -Map $(@:.elf=.map) -o $@

$(ROM) $(OVERLAYS):
	$(OBJCOPY) -O binary $< $@

$(ROM): %.gba: %.elf

$(OVERLAYS): %.bin: %.elf

ELFS := $(ROM:.gba=.elf) $(OVERLAYS:.bin=.elf)
MAPS := $(ELFS:.elf=.map)
SRCS := $(wildcard *.s */*.s */*/*.s)
OBJS := $(SRCS:.s=.o)
DEPS := $(OBJS:.o=.d)

-include $(DEPS)

clean:: clean-tools
	-$(RM) $(ROM) $(OVERLAYS) $(ELFS) $(MAPS) $(OBJS) $(DEPS)


# Read dependencies from the linker scripts.

define elf_deps
$(1): $(shell grep -o '[A-Za-z0-9/_-]\+\.o' $(1:.elf=.ld))
endef
$(foreach elf,$(ELFS),$(eval $(call elf_deps,$(elf))))


rom_15000/data/strings/strings.s: rom_15000/data/strings/strings.txt tools/pack_strings
	$(PACK_STRINGS) -i $< -o $(dir $@)

rom_15000/data/strings/strings.txt: $(BASE).gba tools/unpack_strings
	mkdir -p $(dir $@)
	$(UNPACK_STRINGS) -r $< -o $@

clean::
	-$(RM) -r rom_15000/data/


# Overlays are special in a couple of ways.
#
# They are compressed in the ROM. We extract the compressed overlays
# for two purposes:
# 1. Since we don't yet have a matching compressor, we verify the built
# overlay against the extracted (uncompressed) binary.
# 2. The uncompressed binary is needed for incbin statements in overlay
# sources.

OVERLAY_DIRS := $(dir $(OVERLAYS))

define overlay_orig_deps
$(patsubst %.s,%.o,$(wildcard $(1)*.s)): %.o: $(1)orig.bin
endef
$(foreach overlay_dir,$(OVERLAY_DIRS),$(eval $(call overlay_orig_deps, $(overlay_dir))))

overlays/common/common0.o: overlays/rom_78ef88/orig.bin

overlays/common/common1.o: overlays/rom_7db0c8/orig.bin

overlays/common/common2.o: overlays/rom_7bf5a8/orig.bin

overlays/rom_%/orig.bin: $(BASE).gba tools/unpack_overlay
	$(UNPACK_OVERLAY) -r $< -a 0x$* -o $@

clean::
	-$(RM) $(addsuffix orig.bin,$(OVERLAY_DIRS))

# Overlays use symbols defined in the main part of the ROM. We have to
# add that as a prerequisite, and tell the linker to refer to it.

OVERLAY_ELFS := $(OVERLAYS:.bin=.elf)

$(OVERLAY_ELFS): %.elf: %.ld $(TARGET).elf
	$(LD) -T $< -Map $(@:.elf=.map) -R $(TARGET).elf -o $@
