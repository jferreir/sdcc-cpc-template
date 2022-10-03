TARGET := game

# leaves bytes for startup routine
CODE := 0x00D5

SDCC_DIR := /mnt/ext/Homebrew/toolbox/sdcc_v4.2.0
IDISK_BIN_DIR := /mnt/ext/Homebrew/machines/cpc/toolbox/idsk/build

asm_source_files := $(filter-out crt0.s, $(wildcard *.s))
asm_object_files := $(patsubst %.s, %.rel, $(asm_source_files))

c_source_files := $(wildcard *.c)
c_object_files := $(patsubst %.c, %.rel, $(c_source_files))

# Verbose flag
ifeq ($(V),1)
Q :=
else
Q := @
endif

.PHONY: all clean run

all: dsk

$(TARGET).ihx: crt0.rel $(asm_object_files) $(c_object_files)
	$(Q) $(SDCC_DIR)/bin/sdldz80 -n -mjwx -k $(SDCC_DIR)/share/sdcc/lib/z80 -l z80 -i $@ -b _CODE=$(CODE) crt0.rel $(asm_object_files) $(c_object_files) -e

$(TARGET).bin: $(TARGET).ihx
	$(Q) $(SDCC_DIR)/bin/sdobjcopy -I ihex -O binary $< $@
	wc -c < $(TARGET).bin

%.rel: %.s
	$(Q) $(SDCC_DIR)/bin/sdasz80 -xlos -g $<

%.rel: %.c
	$(Q) $(SDCC_DIR)/bin/sdcc -o $@ -c --std-c99 -mz80 --debug --fsigned-char --std-sdcc99 --opt-code-speed --fomit-frame-pointer $<

%.c: %.h
	$(Q) touch $@

dsk: $(TARGET).bin 
	$(Q) rm -f $(TARGET).dsk
	$(Q) $(IDISK_BIN_DIR)/iDSK $(TARGET).dsk -n
	$(Q) $(IDISK_BIN_DIR)/iDSK $(TARGET).dsk -i $< -e $(CODE) -c $(CODE) -t 1 -f

clean:
	$(Q) rm -f *.bin *.ihx *.rst *.lst *.sym *.map *.rel *.adb *.noi *.asm *.dsk


