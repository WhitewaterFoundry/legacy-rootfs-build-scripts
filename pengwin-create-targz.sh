#!/bin/bash

# create our environment
set -e
BUILDIR=$(pwd)
TMPDIR=$(mktemp -d)
ARCH=""
DIST="testing"
mkdir -p $TMPDIR/$DIST
cd $TMPDIR

function build {

# install script dependencies
sudo apt-get -y -q update
sudo apt-get -y -q install curl gnupg cdebootstrap

# bootstrap image
sudo cdebootstrap -a $ARCH --include=sudo,locales,git,ssh,gnupg,apt-transport-https,wget,ca-certificates,man,less,curl,bash-completion,vim $DIST $DIST http://deb.debian.org/debian

# download and install pengwin-base and pengwin-setup
sudo curl "https://salsa.debian.org/rhaist-guest/WSL/raw/master/linux_files/profile" -so "${TMPDIR}/${DIST}/etc/profile"
sudo cp $BUILDIR/linux_files/setup $TMPDIR/$DIST/etc/setup

# bind /dev/pts so chroot will work, then install
sudo mount --bind /dev/pts $DIST/dev/pts
sudo chroot $DIST /bin/bash -c "bash /etc/setup --silent --install"

# configure initial language settings
sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"
sudo chroot $DIST /bin/bash -c "update-locale LANGUAGE=en_US.UTF-8 LC_ALL=C"

# configure sudo lecture
sudo chroot $DIST /bin/bash -c "echo 'Defaults lecture_file = /etc/sudoers.lecture' >> /etc/sudoers"
sudo chroot $DIST /bin/bash -c "echo 'Enter your UNIX password below. This is not your Windows password.' > /etc/sudoers.lecture"

# remove unnecessary packages in initial image
sudo chroot $DIST apt-get -y -q remove systemd dmidecode --allow-remove-essential

# clean up any orphaned apt dependencies
sudo chroot $DIST apt-get -y -q autoremove

# clean apt cache
sudo chroot $DIST apt-get -y -q clean

# create tar
cd $DIST
sudo tar --ignore-failed-read -czvf $TMPDIR/install.tar.gz *

# move into place in build folder
cd $TMPDIR
cp install.tar.gz $BUILDIR/$ARCHDIR/
cd $BUILDIR

}

# describe script usage
function usage {
echo "./create-targz.sh <BUILD_ARCHITECTURE>"
echo "Possible architectures: arm64, amd64"
}

# accept argument input for architecture type
ARCH=$@
if [ "$ARCH" = "amd64" ] ; then
	ARCH="amd64"
	ARCHDIR="x64"
	build
elif [ "$ARCH" = "arm64" ] ; then
	ARCH="arm64"
	ARCHDIR="ARM64"
	build
else
	usage
fi
