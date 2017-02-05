export LUA     := lua5.3
export LUAMIN   := $(shell which luamin 2> /dev/null)

# For make run:
LUA52             := lua5.2
OCEMU             := ~/dev/OCEmu
OCEMU_INSTANCE    := ~/testoc
OCEMU_INSTANCE_FS := f6cc6715-cea5-434f-be87-f1e0c76a388d

.PHONY: all clean

include mkmod.deps
SUBDIRS   = $(addsuffix _submake, $(MODULES))
all: $(SUBDIRS)

%_submake: %
	@cd $<; $(MAKE)

CLEANDIRS = $(addsuffix _clean, $(MODULES))
clean: $(CLEANDIRS)

%_clean: %
	cd $<; $(MAKE) clean

run: clean all
	cp src/core/kmod.lob $(OCEMU_INSTANCE)/$(OCEMU_INSTANCE_FS)/init.lua
	cd $(OCEMU)/src && $(LUA52) boot.lua $(OCEMU_INSTANCE)
