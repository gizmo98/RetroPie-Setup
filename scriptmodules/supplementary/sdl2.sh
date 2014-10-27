rp_module_id="sdl"
rp_module_desc="SDL 2.0.1"
rp_module_menus="2+"

function depends_sdl() {
    rps_checkNeededPackages libudev-dev libaudio-dev libasound2-dev libdbus-1-dev libx11-dev libxrandr-dev libxcursor-dev libxi-dev libxxf86vm-dev libesd0-dev libegl1-mesa-dev 
}

function sources_sdl() {
    # These packages are listed in SDL2's "README-raspberrypi.txt" file as build dependencies.
    # If libudev-dev is not installed before compiling, the keyboard will mysteriously not work!
    # The rest should already be installed, but just to be safe, include them all.

    wget http://downloads.petrockblock.com/retropiearchives/SDL2-2.0.1.tar.gz
    wget https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.zip
    wget https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.zip
    wget https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.zip
    mkdir -p "$rootdir/supplementary/"
    tar xvfz SDL2-2.0.1.tar.gz -C "$rootdir/supplementary/"
    rm SDL2-2.0.1.tar.gz || return 1
    unzip \*.zip
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
    pushd "$rootdir/supplementary/SDL2_ttf-2.0.12" || return 1
    ./configure
    make -j2
    popd || return 1
    pushd "$rootdir/supplementary/SDL2_image-2.0.0" || return 1
    ./configure
    make -j2
    popd || return 1
    pushd "$rootdir/supplementary/SDL2_mixer-2.0.0" || return 1
    ./configure
    make -j2
    popd || return 1
}

function install_sdl() {
    pushd "$rootdir/supplementary/SDL2-2.0.1" || return 1
    make install || return 1
    cp -R include /usr/include/
    mv /usr/include/include /usr/include/SDL2	
    popd || return 1
    pushd "$rootdir/supplementary/SDL2_ttf-2.0.12" || return 1
    make install || return 1
    popd || return 1
    pushd "$rootdir/supplementary/SDL2_image-2.0.0" || return 1
    make install || return 1
    popd || return 1
    pushd "$rootdir/supplementary/SDL2_mixer-2.0.0" || return 1
    make install || return 1
    popd || return 1
}
