rp_module_id="vba-next"
rp_module_desc="GBA LibretroCore VBA-Next"
rp_module_menus="2+"

function sources_vba-next() {
    gitPullOrClone "$rootdir/emulatorcores/vba-next" git://github.com/libretro/vba-next.git
    pushd "$rootdir/emulatorcores/vba-next"
    popd
}

function build_vba-next() {
    pushd "$rootdir/emulatorcores/vba-next"
    make -f Makefile.libretro clean
    make -f Makefile.libretro -j2 platform=armvhardfloatunix
    if [[ -z `find $rootdir/emulatorcores/vba-next/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile GBA core."
    fi
    popd
}

function configure_vba-next() {
    mkdir -p $romdir/gba

    rps_retronet_prepareConfig
    setESSystem "Game Boy Advance" "gba" "~/RetroPie/roms/gba" ".gba .GBA" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/vba-next/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gba/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "gba" "gba"
    # <!-- alternatively: <command>$rootdir/emulators/snes9x-rpi/snes9x %ROM%</command> -->
    # <!-- alternatively: <command>$rootdir/emulators/pisnes/snes9x %ROM%</command> -->
}
