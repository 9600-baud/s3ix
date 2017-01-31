BUILDDIR := build

SRCFILES := $(shell find . -type f -name "*.c")
HDRFILES := $(shell find . -type f -name "*.h")
ASFILES  := $(shell find . -type f -name "*.s")
OBJFILES := $(patsubst %.c, %.o, $(SRCFILES)) $(patsubst %.s, %.o, $(ASFILES))

.PHONY: all clean

all: $(OBJFILES) exocore.ko

KOFILES := $(shell find . -type f -name "*.ko")
clean:
	-$(RM) $(wildcard $(OBJFILES) $(KOFILES))

%.c:
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

%.s:
	$(AS) $(ASFLAGS) $< -o $@

exocore.ko:
	$(LD) $(LDFLAGS) $(OBJFILES) -o exocore.ko

%.o: %.c %.s Makefile
