#! /usr/bin/env bash
# Apple wireless keyboard module installation script
# by Bystroushaak (bystrousak@kitakitsune.org)

UBUNTU_VERSION=`cat /etc/os-release | grep VERSION= | cut -d "," -f 2 | awk '{print tolower($1)}'`
UBUNTU="ubuntu-$UBUNTU_VERSION"

if [ ! -d $UBUNTU ]; then
	git clone --depth=1 "git://kernel.ubuntu.com/ubuntu/$UBUNTU.git" $UBUNTU
fi

cd $UBUNTU

# check for changes in repository
git checkout master
git pull

# create branch from tag in
VER=`uname -r | sed -e s/-generic//`
BRANCH=`git tag | grep $VER | head -n 1`

BRANCH_PRESENT=`git branch | grep "$VER"`
if [ -z $BRANCH_PRESENT ]; then
	git checkout -b "apple_keyboard_$VER" "$BRANCH"
else
	git checkout "apple_keyboard_$VER"
fi

# copy patched file
cp ../hid-apple.c drivers/hid/hid-apple.c

# make prerequisities
make oldconfig
make prepare
timeout 1m make # just to make all proper tools

# compile all modules
cd drivers/hid
make -C /lib/modules/`uname -r`/build  M=`pwd`  modules

# copy new module into proper directory
OLDD=`pwd`
cd /lib/modules/`uname -r`/kernel/drivers/hid/

# backup old file, but only if it wasn't backupped before
if [ ! -f "hid-apple.ko_" ]; then 
	sudo cp hid-apple.ko hid-apple.ko_
fi

# copy new module here
sudo cp $OLDD/hid-apple.ko .

# config apple keyboard to usable mode
APPLE_CONF="/etc/modprobe.d/hid_apple.conf"
MODULE_OPT="options hid_apple fnmode=2 swapctrlfn=1 use_ejectcd_as_delete=1"

grep "$MODULE_OPT" $APPLE_CONF
if [[ $? != 0 ]]; then
    echo "$MODULE_OPT" | sudo tee -a $APPLE_CONF
fi

# reload driver
sudo modprobe -r hid_apple
sudo modprobe hid_apple

# put driver into kernel
sudo update-initramfs -u