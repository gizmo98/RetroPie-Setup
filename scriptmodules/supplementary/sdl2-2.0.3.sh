rp_module_id="sdl203"
rp_module_desc="SDL 2.0.3"
rp_module_menus="4+"

function depends_sdl203() {
    rps_checkNeededPackages libudev-dev libasound2-dev libdbus-1-dev
}

function sources_sdl203() {
    # These packages are listed in SDL2's "README-raspberrypi.txt" file as build dependencies.
    # If libudev-dev is not installed before compiling, the keyboard will mysteriously not work!
    # The rest should already be installed, but just to be safe, include them all.

    wget http://libsdl.org/release/SDL2-2.0.3.tar.gz
    mkdir -p "$rootdir/supplementary/"
    tar xvfz SDL2-2.0.3.tar.gz -C "$rootdir/supplementary/"
    rm SDL2-2.0.3.tar.gz || return 1
}

function build_sdl203() {
    pushd "$rootdir/supplementary/SDL2-2.0.3" || return 1
    mv /usr/include/GL /usr/include/GL.bak
    mv /usr/include/GLES /usr/include/GLES.bak
    ./configure --disable-video-opengl --enable-video-opengles --enable-libudev --enable-alsa --disable-oss
    make -j2
    mv /usr/include/GL.bak /usr/include/GL
    mv /usr/include/GLES.bak /usr/include/GLES
    popd || return 1
}

function install_sdl203() {
    pushd "$rootdir/supplementary/SDL2-2.0.3" || return 1
    make install || return 1
    cp -R include /usr/include/SDL2	
    popd || return 1
}
