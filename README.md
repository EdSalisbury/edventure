# Description

This repository contains final code for each episode of [Coding a Roguelike in Atari 8-bit Assembly](https://youtu.be/whhTuBpkcrY?si=NNua2iIBsaxaKKlB) podcasts.

Ever wanted to write a game on the ATARI 8-Bit?  If so, you're not alone!  Come along with me on my journey to make a Roguelike on the Atari 8-bit computer in 6502 Assembly language!

Socials:
- Instagram:   / missionedpossible  
- Twitter:   / missionedposs  
- Facebook:   / missionedpossible  
- Website: http://missionedpossible.com


# Setup

## Windows

### 1. Atari Emulator - Altira

Just download it from https://virtualdub.org/altirra.html

### 3. Assembler

The MADS assembler is available for download/clone from github repository: https://github.com/wudsn/wudsn-ide-tools/tree/main/ASM/MADS

Copy the whole folder to your C: drive.


## Linux (Ubuntu)

### 1. Wine

That is needed for windows applications emulation and the Atita Atari emulator is for windows.
This turorial uses Altira, hence I'm sticking to it, but you might want to try other Linux native Atari emulators.

```shell
sudo dpkg --add-architecture i386
sudo apt update

# on older Ubuntus you might want to add latest repo of winehq
wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo apt install software-properties-common
sudo apt-add-repository "deb http://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main"
sudo apt install --install-recommends winehq-stable

# need to configure it and allow installing other required modules - just agree when asked
winecfg
```

### 2. Atari Emulator - Altira

Just download it from https://virtualdub.org/altirra.html

### 3. Assembler

The MADS assembler is available for download/clone from github repository: https://github.com/wudsn/wudsn-ide-tools/tree/main/ASM/MADS

For linux machinne with 64bit system you can try https://github.com/wudsn/wudsn-ide-tools/blob/main/ASM/MADS/mads.linux-x86-64

Likely you want to move it to one of the system binaries folders to have it avaliable under `mads` command:
```shell
sudo cp mads.linux-x86-64 /usr/local/bin/mads

# and check if working
mads --version

# compiling .asm files
masm -lt main.asm
```

# Links
1. [Coding a Roguelike in Atari 8-bit Assembly podcast](https://youtu.be/whhTuBpkcrY?si=NNua2iIBsaxaKKlB)
2. [How to install wine](https://linuxize.com/post/how-to-install-wine-on-ubuntu-20-04/)
3. [Altirra Atari Emulator](https://virtualdub.org/altirra.html)
4. [WUDSN Atari Demo Group Page](https://www.wudsn.com/)
5. [Assemblers Repository](https://github.com/wudsn/wudsn-ide-tools/tree/main/ASM/MADS)
6. [Atari Memory Map](https://www.atariarchives.org/mapping/memorymap.php)
