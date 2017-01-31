PROJDIRS := exocore

export AS       := nasm
export ASFLAGS  := -felf32

export CC       := clang
export WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
            -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wuninitialized -Wconversion -Wstrict-prototypes -Werror
export CFLAGS   := -m32 -ffreestanding -nostdlib -O2  $(WARNINGS)
export LDFLAGS  := -melf_i386

# ------------

.PHONY: all clean kimage

SUBDIRS   = $(addsuffix _submake, $(PROJDIRS))
all: $(SUBDIRS) kimage

%_submake: %
	@cd $<; $(MAKE)

kimage: stub.o
	$(LD) $(LDFLAGS) -T misc/link.ld -o kimage $(shell find . -type f -name "*.ko")


stub.o:
	$(AS) $(ASFLAGS) misc/stub.s -o kimage

CLEANDIRS = $(addsuffix _subclean, $(PROJDIRS))
clean: $(CLEANDIRS)
	-$(RM) kimage

%_subclean: %
	@cd $<; $(MAKE) clean

todolist:
	-@for file in $(ALLFILES:Makefile=); do fgrep -H -e TODO -e FIXME $$file; done; true
