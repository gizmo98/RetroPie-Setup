rp_module_id="mupen64plus"
rp_module_desc="N64 LibretroCore Mupen64Plus"
rp_module_menus="4+"

function sources_mupen64plus() {
    gitPullOrClone "$rootdir/emulatorcores/mupen64plus" git://github.com/libretro/mupen64plus-libretro.git
    pushd "$rootdir/emulatorcores/mupen64plus"
    popd
}

function build_mupen64plus() {
    pushd "$rootdir/emulatorcores/mupen64plus"
    make clean
    make -j2 platform=armvhardfloatunixneongles WITH_DYNAREC=arm CPUFLAGS=" -mcpu=cortex-a7 -mfpu=neon-vfp4 -mfloat-abi=hard -DNO_ASM -DNOSSE"
    if [[ -z `find $rootdir/emulatorcores/mupen64plus/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile GBA core."
    fi
    popd
}

function configure_mupen64plus() {
    mkdir -p $romdir/n64

    rps_retronet_prepareConfig
    setESSystem "Nintendo 64" "n64" "~/RetroPie/roms/n64" ".z64 .Z64 .n64 .N64 .v64 .V64" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mupen64plus-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/n64/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "n64" "n64"
    # <!-- alternatively: <command>$rootdir/emulators/snes9x-rpi/snes9x %ROM%</command> -->
    # <!-- alternatively: <command>$rootdir/emulators/pisnes/snes9x %ROM%</command> -->
}
