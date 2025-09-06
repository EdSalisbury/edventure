# Setup

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
```

# Links
1. https://linuxize.com/post/how-to-install-wine-on-ubuntu-20-04/
2. https://virtualdub.org/altirra.html
3. https://www.wudsn.com/
4. https://github.com/wudsn/wudsn-ide-tools/tree/main/ASM/MADS
