# My first OS

## bootloader with assembly

### Table of contents
* [General info](#general-info)
* [Requirements](#Requirements)
* [PC primer](#PC-primer)
* [registers](#registers)
* [Building](#Building)
* [TO DO Lists](#Task-Lists)
* [Sources](#reference)

---
## General info
> this is my first bootloader in x86 assembly language.The resulting will be very small (fitting into a bootloader) and have very few features(just show hello world :D)

---
## Requirements
* we need some knowledge of a lower-level language like C, especially on the subject of memory and pointers.
* we using Linux and need to install some apps to gets the development toolchain (compiler etc.), QEMU PC emulator and the <abbr title="which converts assembly language into raw machine code executable files">NASM assembler</abbr>.  
###### so entering this in a terminal window:  
```
sudo apt-get install build-essential qemu nasm
```

---
## PC primer
When a PC is powered-up, it starts executing the <abbr title="Basic Input/Output System">**BIOS**</abbr>, which is essentially a mini-OS built into the system. It performs a few hardware tests (eg memory checks) and typically spurts out a graphic (eg Dell logo) or diagnostic text to the screen. Then, when it's done, it starts to load your operating system from any media it can find. Many PCs jump to the hard drive and start executing code they find in the <abbr title="Master Boot Record">**MBR**</abbr>, a 512-byte section at the start of the hard drive; some try to find executable code on a floppy disk (boot sector) or CD-ROM.  

This all depends on the boot order - you can normally specify it in the BIOS options screen. The BIOS loads 512 bytes from the chosen media into its memory, and begins executing it. This is the bootloader, the small program that then loads the main OS kernel or a larger boot program (eg GRUB/LILO for Linux systems). This 512 byte bootloader has two special numbers at the end to tell the OS that it's a boot sector - we'll cover that later.  

Note that PCs have an interesting feature for booting. Historically, most PCs had a floppy drive, so the BIOS was configured to boot from that device. Today, however, many PCs don't have a floppy drive - only a CD-ROM - so a hack was developed to cater for this. When you're booting from a CD-ROM, it can emulate a floppy disk; the BIOS reads the CD-ROM drive, loads in a chunk of data, and executes it as if it was a floppy disk. This is incredibly useful for us OS developers, as we can make floppy disk versions of our OS, but still boot it on CD-only machines. (Floppy disks are really easy to work with, whereas CD-ROM filesystems are much more complicated.)  

So, to recap, the boot process is:

  1. Power on: the PC starts up and begins executing the BIOS code.
  2. The BIOS looks for various media such as a floppy disk or hard drive.
  3. The BIOS loads a 512 byte boot sector from the specified media and begins executing it.
  4. Those 512 bytes then go on to load the OS itself, or a more complex bootloader.

---
## Registers
Here's a list of the fundamental registers on a typical x86 CPU:

registers name | describe
------------ | -------------
AX, BX, CX, DX | General-purpose registers for storing numbers that you're using. For instance, you may use AX to store the character that has been pressed on the keyboard, while using CX to act as a counter in a loop. (Note: these 16-bit registers can be split into 8-bit registers such as AH/AL, BH/BL etc.)
SI, DI | Source and destination data index registers. These point to places in memory for retrieving and storing data.
SP | The Stack Pointer (explained in a moment).
IP (sometimes CP) | The Instruction/Code Pointer. This contains the location in memory of the instruction being executed. When an instruction has finished, it is incremented and moves on to the next instruction. You can change the contents of this register to move around in your code.

---
## Building
these instructions are for Linux  
```
nasm -f bin -o myfirst.bin myfirst.asm
```
Here we assemble the code from our text file into a raw binary file of machine-code instructions. With the -f bin flag, we tell NASM that we want a plain binary file (not a complicated Linux executable - we want it as plain as possible!). The -o myfirst.bin part tells NASM to generate the resulting binary in a file called myfirst.bin.
```
dd status=noxfer conv=notrunc if=myfirst.bin of=myfirst.flp
```
This uses the 'dd' utility to directly copy our kernel to the first sector of the floppy disk image. When it's done, we can boot our new OS using the QEMU PC emulator as follows:
```
qemu-system-i386 -fda myfirst.flp
```
And there you are! Your OS will boot up in a virtual PC. If you want to use it on a real PC, you can write the floppy disk image to a real floppy and boot from it, or generate a CD-ROM ISO image. For the latter, make a new directory called cdiso and move the myfirst.flp file into it. Then, in your home directory, enter:
```
mkisofs -o myfirst.iso -b myfirst.flp cdiso/
```

This generates a CD-ROM ISO image called myfirst.iso with bootable floppy disk emulation, using the virtual floppy disk image from before. Now you can burn that ISO to a CD-R and boot your PC from it! (Note that you need to burn it as a direct ISO image and not just copy it onto a disc.)

---
## Task-Lists
- [x] complete code
- [ ] complete Document

---
## Reference
[2017 Mike Saunders and MikeOS Developers](http://mikeos.sourceforge.net/write-your-own-os.html)
