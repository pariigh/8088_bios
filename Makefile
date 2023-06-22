# Makefile - GNU Makefile
# 
# Copyright (C) 2010 - 2023 Sergey Kiselev.
# Provided for hobbyist use on the Xi 8088 and Micro 8088 boards.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Flash ROM IC type (as supported by minipro programmer)
FLASH_ROM=SST39SF010A
#FLASH_ROM=SST29EE010
#FLASH_ROM=AT29C010A
#FLASH_ROM=W29EE011
#FLASH_ROM="AM29F010 @DIP32"

XTIDE=ide_xt_r624.bin

SOURCES=bios.asm macro.inc at_kbc.inc config.inc errno.inc flash.inc floppy1.inc floppy2.inc keyboard.inc misc.inc printer1.inc printer2.inc ps2aux.inc scancode.inc serial1.inc serial2.inc setup.inc sound.inc time1.inc time2.inc video.inc cpu.inc messages.inc inttrace.inc rtc.inc fnt00-7F.inc fnt80-FF.inc

IMAGES=bios-micro8088-noide.rom bios-micro8088-xtide.rom bios-sergey-xt-noide.rom bios-sergey-xt-xtide.rom bios-xi8088-noide.rom bios-xi8088-xtide.rom bios-book8088-xtide.rom bios-xt.bin
FLASH_IMAGE=bios-micro8088-xtide.rom

all: Makefile $(SOURCES) $(IMAGES)

bios-micro8088.bin: $(SOURCES)
	nasm -DMACHINE_FE2010A -O9 -f bin -o bios-micro8088.bin -l bios-micro8088.lst bios.asm

bios-xi8088.bin: $(SOURCES)
	nasm -DMACHINE_XI8088 -O9 -f bin -o bios-xi8088.bin -l bios-xi8088.lst bios.asm

bios-book8088.bin: $(SOURCES)
	nasm -DMACHINE_BOOK8088 -O9 -f bin -o bios-book8088.bin -l bios-book8088.lst bios.asm

bios-xt.bin: $(SOURCES)
	nasm -DMACHINE_XT -O9 -f bin -o bios-xt.bin -l bios-xt.lst bios.asm

bios-micro8088-noide.rom: bios-micro8088.bin
	dd if=/dev/zero ibs=1k count=40 | LANG=C tr "\000" "\377" > bios-micro8088-noide.rom
	cat bios-micro8088.bin >> bios-micro8088-noide.rom
	dd if=/dev/zero ibs=1k count=64 | LANG=C tr "\000" "\377" >> bios-micro8088-noide.rom

bios-micro8088-xtide.rom: bios-micro8088.bin $(XTIDE)
	cat $(XTIDE) > bios-micro8088-xtide.rom
	dd if=/dev/zero ibs=1k count=32 | LANG=C tr "\000" "\377" >> bios-micro8088-xtide.rom
	cat bios-micro8088.bin >> bios-micro8088-xtide.rom
	dd if=/dev/zero ibs=1k count=64 | LANG=C tr "\000" "\377" >> bios-micro8088-xtide.rom

bios-sergey-xt-noide.rom: bios-xi8088.bin
	dd if=/dev/zero ibs=1k count=96 | LANG=C tr "\000" "\377" > bios-sergey-xt-noide.rom
	cat bios-xi8088.bin >> bios-sergey-xt-noide.rom

bios-sergey-xt-xtide.rom: bios-xi8088.bin $(XTIDE)
	dd if=/dev/zero ibs=1k count=64 | LANG=C tr "\000" "\377" > bios-sergey-xt-xtide.rom
	cat $(XTIDE) >> bios-sergey-xt-xtide.rom
	dd if=/dev/zero ibs=1k count=24 | LANG=C tr "\000" "\377" >> bios-sergey-xt-xtide.rom
	cat bios-xi8088.bin >> bios-sergey-xt-xtide.rom

bios-xi8088-noide.rom: bios-xi8088.bin
	dd if=/dev/zero ibs=1k count=32 | LANG=C tr "\000" "\377" > bios-xi8088-noide.rom
	cat bios-xi8088.bin >> bios-xi8088-noide.rom
	dd if=/dev/zero ibs=1k count=64 | LANG=C tr "\000" "\377" >> bios-xi8088-noide.rom

bios-xi8088-xtide.rom: bios-xi8088.bin $(XTIDE)
	cat $(XTIDE) > bios-xi8088-xtide.rom
	dd if=/dev/zero ibs=1k count=24 | LANG=C tr "\000" "\377" >> bios-xi8088-xtide.rom
	cat bios-xi8088.bin >> bios-xi8088-xtide.rom
	dd if=/dev/zero ibs=1k count=64 | LANG=C tr "\000" "\377" >> bios-xi8088-xtide.rom

bios-book8088-xtide.rom: bios-book8088.bin $(XTIDE)
	cat $(XTIDE) > bios-book8088-xtide.rom
	dd if=/dev/zero ibs=1k count=40 | LANG=C tr "\000" "\377" >> bios-book8088-xtide.rom
	cat bios-book8088.bin >> bios-book8088-xtide.rom

clean:
	rm -f bios-micro8088.lst bios-xi8088.lst bios-book8088.lst bios-xt.lst bios-micro8088.bin bios-xi8088.bin bios-book8088.bin bios-xt.bin $(IMAGES)

flash-micro8088:
	minipro -p $(FLASH_ROM) -w bios-micro8088-xtide.rom

flash-xi8088:
	minipro -p $(FLASH_ROM) -w bios-xi8088-xtide.rom
