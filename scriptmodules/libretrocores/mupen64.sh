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
    make platform=armvcortex-a8 
    if [[ -z `find $rootdir/emulatorcores/mupen64plus/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile N64 core."
    fi
    popd
}

function configure_mupen64plus() {
    mkdir -p $romdir/n64

    ensureSystemretroconfig "n64"

    ensureKeyValue "mupen64-gfxplugin" "rice" "$rootdir/configs/all/retroarch-core-options.cfg"
    ensureKeyValue "mupen64-gfxplugin-accuracy" "low" "$rootdir/configs/all/retroarch-core-options.cfg"
    ensureKeyValue "mupen64-screensize" "640x400" "$rootdir/configs/all/retroarch-core-options.cfg"

    rps_retronet_prepareConfig
    setESSystem "Nintendo 64" "n64" "~/RetroPie/roms/n64" ".z64 .Z64 .n64 .N64 .v64 .V64" "$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mupen64plus/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/n64/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%" "n64" "n64"
}
