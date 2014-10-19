rp_module_id="mali-fbdev"
rp_module_desc="Install MALI fbdev blob"
rp_module_menus="4+"

function install_mali-fbdev()
{
  # start mali kernel module
  modprobe mali
  
  # install mali userspace driver
  export ABI='armhf'
  # export VERSION='r3p2-01rel1'
  export EGL_TYPE='framebuffer'
  pushd /opt/retropie/supplementary
  git clone https://github.com/linux-sunxi/sunxi-mali.git
  cd sunxi-mali
  git submodule init
  git submodule update
  make clean
  # make config.mk
  make install
  popd
  unset ABI
  # unset VERSION
  unset EGL_TYPE

  pushd /opt/retropie/supplementary/
  mkdir gles2
  wget "http://www.khronos.org/registry/gles/api/GLES2/gl2.h"
  wget "http://www.khronos.org/registry/gles/api/GLES2/gl2platform.h"
  wget "http://www.khronos.org/registry/gles/api/GLES2/gl2ext.h"
  mv gl2.h /usr/include/GLES2/gl2.h
  mv gl2platform.h /usr/include/GLES2/gl2platform.h
  mv gl2ext.h /usr/include/GLES2/gl2ext.h
  popd
}
