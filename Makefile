PROJDIRS = lua basehw

SUBPROJS = $(addsuffix _proj, $(PROJDIRS))
all: $(SUBPROJS)

%_proj: %
	cd $< && $(MAKE)

CLEANDIRS = $(addsuffix _clean, $(PROJDIRS))
clean: $(CLEANDIRS)

%_clean: %
	cd $< && $(MAKE) clean

luarun: lua_proj
	cd lua && $(MAKE) run

