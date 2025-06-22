# Credits:
# - https://github.com/rubikstriangle/OpenRV-Rocky9-Docker

# https://hub.docker.com/r/amd64/rockylinux
FROM amd64/rockylinux:9
# docker run -it amd64/rockylinux:9 /bin/bash
# https://hub.docker.com/r/rockylinux/rockylinux
# FROM rockylinux/rockylinux:9
# docker run -it rockylinux/rockylinux:9 /bin/bash

SHELL ["/bin/bash", "-c"]

# Set the build arguments for Qt login credentials
ARG QT_EMAIL
ARG QT_PASSWORD

# ENV HOME=/root
ENV QT_ROOT=/opt/Qt
ENV QT_HOME_VERSION="5.15.2"

USER root

WORKDIR $HOME

ENV QT_HOME=$QT_ROOT/$QT_HOME_VERSION/gcc_64

# Update PATH to include /root/.local/bin
# ENV PATH=$HOME/.local/bin:$PATH

# Install base packages and additional development tools
RUN dnf install -y git diffutils epel-release
RUN dnf config-manager --set-enabled crb devel
RUN dnf install -y \
    expect \
    alsa-lib-devel \
    autoconf automake \
    avahi-compat-libdns_sd-devel \
    bison \
    bzip2-devel \
    cmake-gui \
    curl-devel \
    flex \
    gcc \
    gcc-c++ \
    iproute \
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
    meson \
    ninja-build \
    openssl \
    openssl-devel \
    perl-FindBin \
    pulseaudio-libs \
    pulseaudio-libs-glib2 \
    ocl-icd \
    ocl-icd-devel \
    opencl-headers \
    python3 \
    python3-devel \
    qt5-qtbase-devel \
    qt5-qttools-devel \
    readline-devel \
    sqlite-devel \
    tcl-devel \
    tcsh \
    tk-devel \
    yasm \
    zip \
    zlib-devel \
    mesa-libGLU \
    mesa-libGLU-devel \
    mesa-libOSMesa \
    mesa-libOSMesa-devel \
    glew-devel \
    libXi-devel \
    libXmu-devel \
    mesa-libGL-devel \
    freeglut-devel \
    xorg-x11-server-devel \
    opencv \
    opencv-devel \
    patch \
    openssh-server \
    gdbm-devel \
    libuuid-devel \
    libnsl2-devel
RUN dnf config-manager --set-disabled devel
RUN dnf clean all

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python -m pip install --user --upgrade pip setuptools setuptools_scm wheel

WORKDIR /build/cmake

ENV CMAKE_VERSION="3.27.9"

RUN curl --location \
    --remote-name \
    https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz
RUN tar -zxvf cmake-$CMAKE_VERSION.tar.gz
WORKDIR /build/cmake/cmake-$CMAKE_VERSION
# RUN ls -al
RUN ./bootstrap && make -j$(nproc) && make install

WORKDIR /build/Qt

#Install Qt
# RUN wget https://download.qt.io/archive/online_installers/4.2/qt-unified-linux-x64-4.2.0-online.run
RUN curl --location \
    --remote-name \
    https://download.qt.io/archive/online_installers/4.2/qt-unified-linux-x64-4.2.0-online.run
RUN chmod +x qt-unified-linux-x64-4.2.0-online.run
RUN ./qt-unified-linux-x64-4.2.0-online.run \
        --verbose \
        --email $QT_EMAIL \
        --password $QT_PASSWORD \
        --root $QT_ROOT \
        --platform minimal \
        --confirm-command \
        --accept-licenses \
        --accept-obligations \
        --accept-messages \
        install \
        qt.qt5.5152.qtpdf \
        qt.qt5.5152.qtpurchasing \
        qt.qt5.5152.qtvirtualkeyboard \
        qt.qt5.5152.qtquicktimeline \
        qt.qt5.5152.qtlottie \
        qt.qt5.5152.debug_info \
        qt.qt5.5152.qtscript \
        qt.qt5.5152.qtcharts \
        qt.qt5.5152.qtwebengine \
        qt.qt5.5152.qtwebglplugin \
        qt.qt5.5152.qtnetworkauth \
        qt.qt5.5152.qtwaylandcompositor \
        qt.qt5.5152.qtdatavis3d \
        qt.qt5.5152.logs \
        qt.qt5.5152 \
        qt.qt5.5152.src \
        qt.qt5.5152.gcc_64 \
        qt.qt5.5152.qtquick3d
RUN $QT_ROOT/5.15.2/gcc_64/bin/qmake --version || { echo "Qt installation failed"; exit 1; }
# RUN rm /tmp/qt-installer.run

# Install OpenRV
ENV OPENRV_BUILD_DIR=/build/OpenRV
RUN git clone --recursive https://github.com/AcademySoftwareFoundation/OpenRV.git $OPENRV_BUILD_DIR
WORKDIR $OPENRV_BUILD_DIR
RUN pip install --upgrade pip
RUN python3 -m pip install --user --upgrade -r $OPENRV_BUILD_DIR/requirements.txt
RUN cmake \
    -B $OPENRV_BUILD_DIR/_build \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DRV_DEPS_QT5_LOCATION=$QT_ROOT/5.15.2/gcc_64
RUN cmake \
    --build $OPENRV_BUILD_DIR/_build \
    --config Release \
    -v \
    --target main_executable


# Determine build platform, version, and architecture for creation of rv tarball name
RUN echo "Determining build platform..." && \
    if [ -f /etc/os-release ]; then \
        . /etc/os-release; \
        if [ "$NAME" = "Rocky Linux" ]; then \
            BUILD_PLATFORM="Rocky${VERSION_ID%.*}"; \
        else \
            BUILD_PLATFORM=$(echo ${NAME}${VERSION_ID} | tr ' ' '_'); \
        fi \
    else \
        BUILD_PLATFORM=$(uname -s); \
    fi && \
    VERSION=$(/OpenRV/_build/stage/app/bin/rv -version) && \
    ARCHITECTURE=$(uname -m) && \
    echo "BUILD_PLATFORM=$BUILD_PLATFORM" > /etc/environment && \
    echo "VERSION=$VERSION" >> /etc/environment && \
    echo "ARCHITECTURE=$ARCHITECTURE" >> /etc/environment && \
    BUILD_NAME=OpenRV-${BUILD_PLATFORM}-${ARCHITECTURE}-${VERSION} && \
    echo "BUILD_NAME=$BUILD_NAME" >> /etc/environment && \
    echo "$BUILD_NAME" >> $OPENRV_BUILD_DIR/build_name.txt

# Source the environment variables file
RUN . /etc/environment && echo "Build Name: $BUILD_NAME"
RUN . /etc/environment && cmake --install $OPENRV_BUILD_DIR/_build --prefix /opt/OpenRV/${BUILD_NAME} --config Release
RUN . /etc/environment && cp /lib64/libcrypt.so.2 /opt/OpenRV/${BUILD_NAME}/lib
RUN . /etc/environment && tar -czvf ${BUILD_NAME}.tar.gz -C /opt/OpenRV ${BUILD_NAME}
RUN . /etc/environment && echo -e "\n\e[1;32mRun the following lines to copy your OpenRV build into your ~/Downloads folder:\e[0m" && \
    echo -e "\e[1;36msudo docker run -d --name openrv_container openrv_rocky9\e[0m" && \
    echo -e "\e[1;36msudo docker cp openrv_container:/opt/OpenRV/${BUILD_NAME}.tar.gz ~/Downloads/\e[0m\n\n"
