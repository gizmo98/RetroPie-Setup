rp_module_id="lima"
rp_module_desc="Build lima driver"
rp_module_menus="4+"

function install_lima() {
  gitPullOrClone "$rootdir/supplementary/lima" "git://gitorious.org/lima/lima.git"
  pushd "$rootdir/supplementary/lima"
  make
  make install
  popd
}
