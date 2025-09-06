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

# Links
1. https://linuxize.com/post/how-to-install-wine-on-ubuntu-20-04/
2. https://virtualdub.org/altirra.html
3. 
