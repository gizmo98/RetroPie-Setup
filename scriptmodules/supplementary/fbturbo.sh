rp_module_id="fbturbo"
rp_module_desc="FBTURBO X11 driver"
rp_module_menus="4+"

function depends_fbturbo()
{
  rps_checkNeededPackages build-essential xorg-dev xutils-dev x11proto-dri2-dev libltdl-dev libtool automake libdrm-dev	
}

function build_fbturbo()
{
  pushd /opt/retropie/supplementary
  git clone https://github.com/ssvb/xf86-video-fbturbo.git
  cd xf86-video-fbturbo

  autoreconf -vi
  ./configure --prefix=/usr
  make -j2
  popd
}
  
function install_fbturbo()
{
  pushd /opt/retropie/supplementary/xf86-video-fbturbo
  make install
  cp xorg.conf /etc/X11/xorg.conf
  popd
}
