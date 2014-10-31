rp_module_id="lima"
rp_module_desc="Build lima driver"
rp_module_menus="4+"

function install_lima() {
  gitPullOrClone "git://gitorious.org/lima/lima.git"
  cd lima
  make
  make install
}
