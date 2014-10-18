rp_module_id="olimex"
rp_module_desc="OLinuXino A20 first intialisation"
rp_module_menus="2+"

function install_olimex()
{
  mkdir /opt/retropie
  mkdir /opt/retropie/supplementary

  A20_depens
  A20_olimex_debian_fix
  # A20_gles2_headers
}
  
function A20_depens()
{
  # switch to debian jessie. Is not possible atm because udev libs cannot be updated. Kernel is too old.
  # sed -i 's/wheezy/jessie/g' /etc/apt/sources.list 
  
  # add debian wheezy backports repo
  if grep -q 'deb http://http.debian.net/debian wheezy-backports main' /etc/apt/sources.list; then
      echo 'Nothing to do'
  else
      echo 'deb http://http.debian.net/debian wheezy-backports main' >> /etc/apt/sources.list
  fi
  
  # add sunxi repo
  if grep -q 'deb http://packages.linux-sunxi.org/debian/ wheezy main' /etc/apt/sources.list; then
      echo 'Nothing to do'
  else
      echo 'deb http://packages.linux-sunxi.org/debian/ wheezy main' >> /etc/apt/sources.list
  fi
  
  if grep -q 'deb-src http://packages.linux-sunxi.org/debian/ wheezy main' /etc/apt/sources.list; then
      echo 'Nothing to do'
  else
      echo 'deb-src http://packages.linux-sunxi.org/debian/ wheezy main' >> /etc/apt/sources.list
  fi
  
  cat >> /etc/apt/preferences.d/00-linux-sunxi << _EOF_
Package: *
Pin: origin packages.linux-sunxi.org
Pin-Priority: 990
_EOF_

  # apt update
  apt-get update
  apt-get -y upgrade

  # install necessary packages
  # apt-get -t wheezy-backports install libsdl2-dev
  apt-get -y install libsdl1.2-dev libegl1-mesa-dev libgles2-mesa-dev
  apt-get -y remove libpulse0 libpulse-dev
}
  
function A20_ump_install()
{
  # start mali kernel module
  modprobe mali
  
  # install ump userspace lib
  #pushd /opt/retropie/supplementary
  #apt-get install -y debhelper dh-autoreconf pkg-config
  #apt-get install -y git build-essential autoconf libtool
  #git clone https://github.com/linux-sunxi/libump.git
  #cd libump
  #dpkg-buildpackage -b
  #dpkg -i ../libump_*.deb
  #popd
}

function A20_dri2_install()
{
  # install dri2 libs
  pushd /opt/retropie/supplementary
  git clone https://github.com/robclark/libdri2
  cd libdri2
  ./autogen.sh
  ./configure
  make
  make install
  ldconfig
  popd
}

function A20_mali_install()
{
  # start mali kernel module
  modprobe mali
  
  # install mali userspace driver
  #export ABI='armhf'
  #export VERSION='r3p2-01rel1'
  pushd /opt/retropie/supplementary
  git clone https://github.com/linux-sunxi/sunxi-mali.git
  cd sunxi-mali
  git submodule init
  git submodule update
  make clean
  #sudo make config.mk
  sudo make install
  popd
  #unset ABI
  #unset VERSION
}

function A20_fbturbo_depen()
{
  apt-get -y install git build-essential xorg-dev xutils-dev x11proto-dri2-dev
  apt-get -y install libltdl-dev libtool automake libdrm-dev	
}

function A20_fbturbo_build()
{
  pushd /opt/retropie/supplementary
  git clone https://github.com/ssvb/xf86-video-fbturbo.git
  cd xf86-video-fbturbo

  autoreconf -vi
  ./configure --prefix=/usr
  make
  popd
}
  
function A20_fbturbo_build()
{
  pushd /opt/retropie/supplementary/xf86-video-fbturbo
  make install
  cp xorg.conf /etc/X11/xorg.conf
  popd
}

function A20_olimex_debian_fix()
{
  # enable necessary services
  /etc/init.d kmod start
  /etc/init.d alsa-utils start
  update-rc.d kmod enable
  update-rc.d alsa-utils enable

  # fix /etc/hosts file
  sed -i 's/a20_OLinuXino/a20-OLinuXino/g' /etc/hosts
  
  # enable autoconnect
  sed -i 's/^#auto eth0/auto eth0/g' /etc/network/interfaces
  
  # enable sudo without passwort
  if grep -q 'olimex ALL=(ALL) NOPASSWD: ALL' /etc/sudoers; then
      echo 'Nothing to do'
  else
      echo 'olimex ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  fi
  
  # add udev rule
  cat > "/etc/udev/rules.d/50-mali.rules" << _EOF_
KERNEL=="mali", MODE="0660", GROUP="video"
KERNEL=="ump", MODE="0660", GROUP="video"
_EOF_

  # move the lima drivers out of the search path:
  sudo mkdir /usr/lib/arm-linux-gnueabihf/bak
  sudo mv /usr/lib/arm-linux-gnueabihf/libGLES* /usr/lib/arm-linux-gnueabihf/bak
  sudo mv /usr/lib/arm-linux-gnueabihf/libEGL* /usr/lib/arm-linux-gnueabihf/bak

  # enable module mali at startup
  sed -i 's/^#mali/mali/g' /etc/modules
}

function A20_gles2_headers()
{
  pushd /opt/retropie/supplementary/
  mkdir gles2
  wget "http://www.khronos.org/registry/gles/api/GLES2/gl2.h"
  wget "http://www.khronos.org/registry/gles/api/GLES2/gl2platform.h"
  wget "http://www.khronos.org/registry/gles/api/GLES2/gl2ext.h"
  popd
}
