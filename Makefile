PROJDIRS := exocore

export AS       := nasm
export ASFLAGS  := -felf64

export CC       := clang
export WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
            -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wuninitialized -Wconversion -Wstrict-prototypes -Werror
export CFLAGS   := -g -mno-mmx -mno-sse -mno-sse2 -mcmodel=large -m64 -ffreestanding -nostdlib -O2  $(WARNINGS)
export LDFLAGS  := -T link.ld -melf_x86_64

# ------------

.PHONY: all clean

SUBDIRS   = $(addsuffix _submake, $(PROJDIRS))
all: clean $(SUBDIRS)

%_submake: %
	@cd $<; $(MAKE)

CLEANDIRS = $(addsuffix _subclean, $(PROJDIRS))
clean: $(CLEANDIRS)
	-$(RM) test.iso

%_subclean: %
	@cd $<; $(MAKE) clean

run: all
	grub-mkrescue -o test.iso exocore/
	qemu-system-x86_64 -hdb test.iso -boot d

todolist:
	-@for file in $(ALLFILES:Makefile=); do fgrep -H -e TODO -e FIXME $$file; done; true
