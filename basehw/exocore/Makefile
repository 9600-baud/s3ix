BUILDDIR := build

SRCFILES := $(shell find . -type f -name "*.c")
HDRFILES := $(shell find . -type f -name "*.h")
ASFILES  := $(shell find . -type f -name "*.s")
OBJFILES := $(patsubst %.c, %.o, $(SRCFILES)) $(patsubst %.s, %.o, $(ASFILES))

.PHONY: all clean

all: $(OBJFILES) kimage

clean:
	-$(RM) $(wildcard $(OBJFILES)) kimage

%.c:
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

%.s:
	$(AS) $(ASFLAGS) $< -o $@

kimage:
	$(LD) $(LDFLAGS) $(OBJFILES) -o kimage

%.o: %.c %.s Makefile
