#!/bin/bash

# Pulizia dei file precedenti
rm -f bootloader.bin kernel.o kernel.elf kernel.bin floppy.img

echo "[1] Compilazione del bootloader..."
nasm -f bin bootloader.asm -o bootloader.bin

echo "[2] Compilazione del kernel..."
gcc -m32 -ffreestanding -fno-pic -c kernel.c -o kernel.o

echo "[3] Collegamento del kernel..."
ld -m elf_i386 -T link.ld kernel.o -o kernel.elf

echo "[4] Conversione in binario puro..."
objcopy -O binary kernel.elf kernel.bin

echo "[5] Creazione dell'immagine del disco..."
dd if=/dev/zero of=floppy.img bs=512 count=2880
dd if=bootloader.bin of=floppy.img bs=512 count=1 conv=notrunc
dd if=kernel.bin of=floppy.img bs=512 seek=1 conv=notrunc

echo "[6] Test con QEMU..."
qemu-system-i386 -fda floppy.img -S -s
