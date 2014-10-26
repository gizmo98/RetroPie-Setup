rp_module_id="jessie"
rp_module_desc="Switch to Raspbian/Debian Jessie"
rp_module_menus="4+"

function install_jessie()
{
  # switch to raspbian/debian jessie. 
  # olimex: Not possible atm because udev libs cannot be updated. Kernel is too old.
  sed -i 's/wheezy/jessie/g' /etc/apt/sources.list 
  apt-get update
  apt-get -y dist-upgrade
}
