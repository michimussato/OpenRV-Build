FROM rockylinux/rockylinux:9 AS openrv_linux_rocky9_build_base
# Build:
# /usr/bin/time -f 'Commandline Args: %C\nElapsed Time: %E\nPeak Memory: %M\nExit Code: %x' docker build --file ./docker/OpenRV.Linux-Rocky9.build_base.Dockerfile --progress plain --tag openstudiolandscapes/openrv_linux_rocky9_build_base:latest --tag openstudiolandscapes/openrv_linux_rocky9_build_base:$(date +"%Y-%m-%d_%H-%M-%S") .
#
# Run (attached):
# Ref: https://stackoverflow.com/a/55734437/2207196
# docker run --hostname openrv_linux_rocky9_build_base --rm --name openrv_linux_rocky9_build_base openstudiolandscapes/openrv_linux_rocky9_build_base:latest /bin/bash -c "trap : TERM INT; sleep infinity & wait"
#
# Exec:
# docker container exec --interactive --tty openrv_linux_rocky9_build_base /bin/bash

# Tested and verified: [x] (2025-06-26)

# LABEL maintainer="Michael Mussato"

USER root

# enable epel crb and devel packages
RUN \
    dnf upgrade -y && \
    dnf install -y epel-release && \
    dnf config-manager --set-enabled crb devel && \
    dnf install -y \
        # RV requirements
        alsa-lib-devel \
        autoconf \
        automake \
        avahi-compat-libdns_sd-devel \
        bison \
        bzip2-devel \
        cmake-gui \
        curl-devel \
        diffutils \
        flex \
        git \
        gcc \
        gcc-c++ \
        libXcomposite \
        libXi-devel \
        libaio-devel \
        libffi-devel \
        nasm \
        ncurses-devel \
        nss \
        libtool \
        libxkbcommon \
        libXcomposite \
        libXdamage \
        libXrandr \
        libXtst \
        libXcursor \
        mesa-libGLU \
        mesa-libGLU-devel \
        mesa-libOSMesa \
        mesa-libOSMesa-devel \
        meson \
        ninja-build \
        openssl-devel \
        patch \
        perl-FindBin \
        pulseaudio-libs \
        pulseaudio-libs-glib2 \
        ocl-icd \
        ocl-icd-devel \
        opencl-headers \
        qt5-qtbase-devel \
        readline-devel \
        sqlite-devel \
        sudo \
        tcl-devel \
        tcsh \
        tk-devel \
        wget \
        yasm \
        zip \
        zlib-devel \
        systemd-devel && \
    # The cmake in dnf is not recent enough, install from the CMake site
    curl  \
        --location https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3-linux-x86_64.sh \
        --output cmake.sh && \
    sh cmake.sh --prefix=/usr/local/ --skip-license && \
    rm -rf cmake.sh && \
    # Clearing dnf caches
    dnf clean all && \
    rm -rf /var/cache/yum

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

RUN python -m pip install aqtinstall

RUN \
    python -m aqt install-qt linux desktop 5.15.2 gcc_64 -O ~/Qt \
    -m debug_info qtcharts qtdatavis3d qtlottie qtnetworkauth qtpurchasing qtquick3d qtquicktimeline qtscript qtvirtualkeyboard qtwaylandcompositor qtwebengine qtwebglplugin \
    --archives icu qt3d qtbase qtconnectivity qtdeclarative qtgamepad qtgraphicaleffects qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2 qtremoteobjects qtscxml qtsensors qtserialbus qtserialport qtspeech qtsvg qttools qttranslations qtwayland qtwebchannel qtwebsockets qtwebview qtx11extras qtxmlpatterns

ENV QT_HOME="${HOME}/Qt/5.15.2/gcc_64"

CMD ["/bin/bash"]
