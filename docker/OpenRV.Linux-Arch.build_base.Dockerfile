FROM archlinux/archlinux:latest AS openrv_linux_arch_build_base
# Build:
# /usr/bin/time -f 'Commandline Args: %C\nElapsed Time: %E\nPeak Memory: %M\nExit Code: %x' docker build --file ./docker/OpenRV.Linux-Arch.build_base.Dockerfile --progress plain --tag openstudiolandscapes/openrv_linux_arch_build_base:latest --tag openstudiolandscapes/openrv_linux_arch_build_base:$(date +"%Y-%m-%d_%H-%M-%S") . > >(tee -a docker/openrv_linux_arch_build_base__stdout.log) 2> >(tee -a docker/openrv_linux_arch_build_base__stderr.log >&2)
#
# Run (attached):
# Ref: https://stackoverflow.com/a/55734437/2207196
# docker run --hostname openrv_linux_arch_build_base --rm --name openrv_linux_arch_build_base openstudiolandscapes/openrv_linux_arch_build_base:latest /bin/bash -c "trap : TERM INT; sleep infinity & wait"
# As root:
# docker run --user root [...]
#
# Exec:
# docker container exec --interactive --tty openrv_linux_arch_build_base /bin/bash

# Tested and verified: [x] (2025-06-26)

# LABEL maintainer="Michael Mussato"

USER root

WORKDIR /root

# https://gist.github.com/SiyuanQi-zz/600d1ce536791b7a3bd2e59fdbe69e66
# https://support.codeweavers.com/en_US/missinglibosmesa82
# https://bbs.archlinux.org/viewtopic.php?id=283057
#
# # Add [extra] (default: enabled)
# RUN echo -e "\n[extra]\nInclude = /etc/pacman.d/mirrorlist\n\n" >> /etc/pacman.conf
#
# Add [multilib] (default: disabled)
RUN echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\nSigLevel = PackageRequired\n\n" >> /etc/pacman.conf
RUN pacman -Syyu --disable-download-timeout --noconfirm

# depends=('alsa-lib' 'libaio' 'mesa' 'tk' 'tcsh' 'opencl-icd-loader' 'glu' 'nss'
#         'libxcomposite' 'libxcursor' 'xcb-util-keysyms' 'libxrandr' 'libva'
#         'xcb-util-wm' 'xcb-util-renderutil' 'libxkbcommon-x11' 'libvdpau' 'libxtst'
#         'libva' 'xcb-util-keysyms' 'libnsl' 'xcb-util-image' 'libcups' 'libpulse')


# AUR
# yay: https://itsfoss.com/install-yay-arch-linux/

# mesa does not come with libOSmesa but mesa-amber does
# mesa and mesa-amber are in conflict

RUN \
    pacman -S --disable-download-timeout --noconfirm --needed \
        alsa-lib \
        autoconf \
        automake \
        avahi \
        bison \
        bzip2 \
        cmake \
        curl \
        diffutils \
        flex \
        git \
        gcc \
        libxcomposite \
        libxi \
        libaio \
        libffi \
        nasm \
        ncurses \
        nss \
        libjpeg6-turbo \
        libtool \
        libxkbcommon \
        libxcomposite \
        libxdamage \
        libxrandr \
        libxtst \
        libxcursor \
        mesa-amber \
        glu \
        make \
        meson \
        ninja \
        openssl \
        patch \
        perl \
        pulseaudio \
        ocl-icd \
        opencl-headers \
        qt5-base \
        readline \
        sqlite \
        sudo \
        tcl \
        tcsh \
        tk \
        unzip \
        wget \
        yasm \
        zip \
        zlib \
        systemd && \
    # The cmake in dnf is not recent enough, install from the CMake site \
    curl \
        --location https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3-linux-x86_64.sh \
        --output cmake.sh && \
    sh cmake.sh --prefix=/usr/local/ --skip-license && \
    rm -rf cmake.sh


# workaround when using mesa-amber
# - [ ] working?
# https://archlinux.org/packages/extra/x86_64/mesa-amber/
# amber -> mesa
# usr/lib/libEGL_amber.so.0.0.0
RUN ln -s /usr/lib/libEGL_amber.so.0.0.0 /usr/lib/libEGL_mesa.so.0.0.0
RUN ln -s /usr/lib/libEGL_amber.so.0 /usr/lib/libEGL_mesa.so.0
RUN ln -s /usr/lib/libEGL_amber.so /usr/lib/libEGL_mesa.so
# usr/lib/libGLX_amber.so.0.0.0
RUN ln -s /usr/lib/libGLX_amber.so.0.0.0 /usr/lib/libGLX_mesa.so.0.0.0
RUN ln -s /usr/lib/libGLX_amber.so.0 /usr/lib/libGLX_mesa.so.0
RUN ln -s /usr/lib/libGLX_amber.so /usr/lib/libGLX_mesa.so


# libGLX_mesa.so
# - Manjaro
#   - libGLX_mesa.so
#       $ pkgfile libGLX_mesa.so
#       extra/mesa
#       multilib/lib32-mesa
#       $ find / -type f -name libGLX_mesa*
#       /usr/lib32/libGLX_mesa.so.0.0.0
#       /usr/lib/libGLX_mesa.so.0.0.0
#   - libOSMesa.so
#       $ pkgfile libOSMesa.so
#       extra/mesa-amber
#       multilib/lib32-mesa-amber
#       $ find / -type f -name libOSMesa*

# - Arch
#   $ pkgfile libGLX_mesa.so
#   extra/mesa
#   multilib/lib32-mesa
#   $ pacman -Syyu --noconfirm mesa
#   $ find / -type f -name libGLX_*
#   /usr/lib/libGLX_amber.so.0.0.0
#   /usr/lib/libGLX.so.0.0.0
#   /usr/lib32/libGLX.so.0.0.0
#   /usr/lib32/libGLX_amber.so.0.0.0

# pacman -S mesa mesa-amber
# resolving dependencies...
# looking for conflicting packages...
# warning: removing 'mesa-1:25.1.4-2' from target list because it conflicts with 'mesa-amber-21.3.9-6'
# warning: dependency cycle detected:
# warning: mesa-amber will be installed before its libglvnd dependency
#
# That means we cannot have lib_GLX_mesa.so and libOSmesa.so at the same time :((
#

# create and run as user rv
RUN useradd -u 1001 -ms /bin/bash rv
USER rv
ENV HOME="/home/rv"
WORKDIR ${HOME}

ENV PATH="${HOME}/.local/bin:/usr/local/bin:${PATH}"
ENV QT_QPA_PLATFORM="offscreen"

# Download ninja from GitHub to get a more recent version.
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip
RUN unzip ninja-linux.zip -d ./ninja
RUN echo 'export PATH=${HOME}/ninja:${PATH}' >> ${HOME}/.bash_profile
ENV PATH="${HOME}/ninja:${PATH}"

# Using pyenv to make sure that python and python3 command points to the same version.
# Install pyenv
RUN git clone http://github.com/pyenv/pyenv.git ${HOME}/.pyenv
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
RUN echo 'export PYENV_ROOT="${HOME}/.pyenv"' >> ~/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install specific version of Python
RUN pyenv install 3.10.13

# Set as the global version
RUN pyenv global 3.10.13

RUN python -m pip install --upgrade pip
RUN python -m pip install aqtinstall

RUN \
    python -m aqt install-qt linux desktop 5.15.2 gcc_64 -O ~/Qt \
    -m debug_info qtcharts qtdatavis3d qtlottie qtnetworkauth qtpurchasing qtquick3d qtquicktimeline qtscript qtvirtualkeyboard qtwaylandcompositor qtwebengine qtwebglplugin \
    --archives icu qt3d qtbase qtconnectivity qtdeclarative qtgamepad qtgraphicaleffects qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2 qtremoteobjects qtscxml qtsensors qtserialbus qtserialport qtspeech qtsvg qttools qttranslations qtwayland qtwebchannel qtwebsockets qtwebview qtx11extras qtxmlpatterns

ENV QT_HOME="${HOME}/Qt/5.15.2/gcc_64"

CMD ["/bin/bash"]
