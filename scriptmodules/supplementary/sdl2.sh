rp_module_id="sdl"
rp_module_desc="SDL 2.0.1"
rp_module_menus="2+"

function depends_sdl() {
    rps_checkNeededPackages libudev-dev libasound2-dev libdbus-1-dev
}

function sources_sdl() {
    # These packages are listed in SDL2's "README-raspberrypi.txt" file as build dependencies.
    # If libudev-dev is not installed before compiling, the keyboard will mysteriously not work!
    # The rest should already be installed, but just to be safe, include them all.

    wget http://downloads.petrockblock.com/retropiearchives/SDL2-2.0.1.tar.gz
    mkdir -p "$rootdir/supplementary/"
    tar xvfz SDL2-2.0.1.tar.gz -C "$rootdir/supplementary/"
    rm SDL2-2.0.1.tar.gz || return 1
}

function build_sdl() {
    pushd "$rootdir/supplementary/SDL2-2.0.1" || return 1
    mv /usr/include/GL /usr/include/GL.bak
    mv /usr/include/GLES /usr/include/GLES.bak
    ./configure --disable-video-opengl --enable-video-opengles --enable-libudev --enable-alsa
    make -j2
    mv /usr/include/GL.bak /usr/include/GL
    mv /usr/include/GLES.bak /usr/include/GLES
    popd || return 1
}

function install_sdl() {
    pushd "$rootdir/supplementary/SDL2-2.0.1" || return 1
    make install || return 1
    popd || return 1
}
