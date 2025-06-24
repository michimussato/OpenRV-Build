# Credits:
# - https://github.com/rubikstriangle/OpenRV-Rocky9-Docker

# https://hub.docker.com/r/amd64/rockylinux
# FROM amd64/rockylinux:9
# docker run -it amd64/rockylinux:9 /bin/bash
# https://hub.docker.com/r/rockylinux/rockylinux
FROM rockylinux/rockylinux:9
# docker run -it rockylinux/rockylinux:9 /bin/bash

SHELL ["/bin/bash", "-c"]

# Set the build arguments for Qt login credentials
ARG QT_EMAIL
ARG QT_PASSWORD

# https://bobcares.com/blog/dockerfile-arg-default-value-not-working/
ARG CMAKE_VERSION
# ARG CMAKE_VERSION="3.30.3"
# ARG CMAKE_VERSION=${CMAKE_VERSION}

ARG RV_INST
# ARG RV_INST="/opt/OpenRV"
# ARG RV_INST=${RV_INST}

ARG QT_INSTALLER_VERSION
# ARG QT_INSTALLER_VERSION="4.6.1"
# ARG QT_INSTALLER_VERSION=${QT_INSTALLER_VERSION}

ARG QT_ROOT
# ARG QT_ROOT="/opt/Qt"
# ARG QT_ROOT=${QT_ROOT}

ARG QT_HOME_VERSION
# ARG QT_HOME_VERSION="5.15.2"
# ARG QT_HOME_VERSION=${QT_HOME_VERSION}

ARG FFMPEG_NON_FREE_DECODERS_TO_ENABLE
# ARG FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc"
# ARG FFMPEG_NON_FREE_DECODERS_TO_ENABLE=${FFMPEG_NON_FREE_DECODERS_TO_ENABLE}

ARG FFMPEG_NON_FREE_ENCODERS_TO_ENABLE


USER root

WORKDIR /build

# Update PATH to include /root/.local/bin
# ENV PATH=$HOME/.local/bin:$PATH

# Install base packages and additional development tools
RUN dnf install -y git which epel-release
RUN dnf install -y epel-release
RUN dnf config-manager --set-enabled crb devel
RUN dnf install -y \
    alsa-lib-devel \
    autoconf \
    automake \
    avahi-compat-libdns_sd-devel \
    bison \
    bzip2-devel \
    cmake-gui \
    curl-devel \
    flex \
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
    python3 \
    python3-devel \
    qt5-qtbase-devel \
    readline-devel \
    sqlite-devel \
    systemd-devel \
    tcl-devel \
    tcsh \
    tk-devel \
    yasm \
    zip \
    zlib-devel
RUN dnf config-manager --set-disabled devel
RUN dnf install -y \
    mesa-libGLU \
    mesa-libGLU-devel
# RUN dnf clean all


ENV CMAKE_BUILD_DIR="/build/cmake"
WORKDIR $CMAKE_BUILD_DIR


RUN curl --location \
    --remote-name \
    https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz
RUN tar -zxvf cmake-${CMAKE_VERSION}.tar.gz

WORKDIR $CMAKE_BUILD_DIR/cmake-${CMAKE_VERSION}

RUN ./bootstrap && make -j$(nproc) && make install


ENV QT_BUILD_DIR="/build/Qt"
WORKDIR $QT_BUILD_DIR

#Install Qt
# RUN wget https://download.qt.io/archive/online_installers/4.2/qt-unified-linux-x64-4.2.0-online.run
RUN curl --location \
    --remote-name \
    https://download.qt.io/archive/online_installers/4.6/qt-unified-linux-x64-${QT_INSTALLER_VERSION}-online.run
#     https://download.qt.io/archive/online_installers/$(echo ${QT_INSTALLER_VERSION} | cut -d "." -f 1,2)/qt-unified-linux-x64-${QT_INSTALLER_VERSION}-online.run
RUN chmod a+x qt-unified-linux-x64-${QT_INSTALLER_VERSION}-online.run
RUN ./qt-unified-linux-x64-${QT_INSTALLER_VERSION}-online.run \
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


# Install OpenRV
ENV OPENRV_BUILD_DIR="/build/OpenRV"
WORKDIR $OPENRV_BUILD_DIR
RUN git clone \
    --recursive https://github.com/AcademySoftwareFoundation/OpenRV.git \
    .
RUN python3 -m pip install --requirement requirements.txt

# RUN python --version
# WORKDIR /usr/bin
# RUN ls -al python*
# RUN ls -sfn python3 python

ENV QT_HOME="$QT_ROOT/$QT_HOME_VERSION/gcc_64"

RUN python3 -m venv .venv

# instead of 'ls -al /usr/bin/python /usr/bin/python3'
# and constant 'source .venv/bin/activate'
ENV PATH="$OPENRV_BUILD_DIR/.venv/bin:$PATH"

# rvsetup
RUN python3 -m pip install --upgrade -r $OPENRV_BUILD_DIR/requirements.txt

# rvcfg
ENV RV_VFX_PLATFORM="CY2023"
RUN cmake \
    -B ${OPENRV_BUILD_DIR}/_build \
    -G \"Ninja\" \
    -DCMAKE_BUILD_TYPE=Release \
    -DRV_DEPS_QT5_LOCATION=$QT_HOME \
    -DRV_VFX_PLATFORM=$RV_VFX_PLATFORM \
    -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="$FFMPEG_NON_FREE_DECODERS_TO_ENABLE" \
    -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="$FFMPEG_NON_FREE_ENCODERS_TO_ENABLE"

# rvbuildt
# alias rvbuildt="rvenv && cmake --build ${RV_BUILD} --config Release -v --parallel=${RV_BUILD_PARALLELISM} --target "
RUN cmake \
    --build ${OPENRV_BUILD_DIR}/_build \
    --config Release \
    -v \
    --parallel=$(nproc) \
    --target dependencies
# RUN . ./rvcmds.sh && rvbuildt dependencies
# # RUN cmake \
# #     -B $OPENRV_BUILD_DIR/_build \
# #     -G Ninja \
# #     -DCMAKE_BUILD_TYPE=Release \
# #     -DRV_DEPS_QT5_LOCATION=$QT_ROOT/5.15.2/gcc_64

RUN cmake \
    --build ${OPENRV_BUILD_DIR}/_build \
    --config Release \
    -v \
    --parallel=$(nproc) \
    --target main_executable

# RUN . ./rvcmds.sh && rvbuildt main_executable
# # RUN cmake \
# #     --build $OPENRV_BUILD_DIR/_build \
# #     --config Release \
# #     -v \
# #     --target main_executable

# Installation is not necessary, just create tarball
# RUN . ./rvcmds.sh && rvinst


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
    VERSION=$($OPENRV_BUILD_DIR/_build/stage/app/bin/rv -version) && \
    ARCHITECTURE=$(uname -m) && \
    echo "BUILD_PLATFORM=$BUILD_PLATFORM" > /etc/environment && \
    echo "VERSION=$VERSION" >> /etc/environment && \
    echo "ARCHITECTURE=$ARCHITECTURE" >> /etc/environment && \
    BUILD_NAME=OpenRV-${BUILD_PLATFORM}-${ARCHITECTURE}-${VERSION} && \
    echo "BUILD_NAME=$BUILD_NAME" >> /etc/environment && \
    echo "$BUILD_NAME" >> $OPENRV_BUILD_DIR/build_name.txt

# Source the environment variables file
RUN . /etc/environment && echo "Build Name: $BUILD_NAME"
# rvinst
# alias rvinst="rvenv && cmake --install ${RV_BUILD} --prefix ${RV_INST} --config Release"
# RUN . /etc/environment && cmake --install $OPENRV_BUILD_DIR/_build --prefix /opt/OpenRV/${BUILD_NAME} --config Release
# RUN . $OPENRV_BUILD_DIR/rvcmds.sh && . /etc/environment && rvinst
RUN . /etc/environment \
    && cmake \
    --install ${OPENRV_BUILD_DIR}/_build \
    --prefix ${RV_INST}  \
    --config Release
# RUN . $OPENRV_BUILD_DIR/rvcmds.sh && . /etc/environment && rvenv && cmake --install $OPENRV_BUILD_DIR/_build --prefix $RV_INST/${BUILD_NAME} --config Release
RUN . /etc/environment && cp /lib64/libcrypt.so.2 $RV_INST/${BUILD_NAME}/lib
RUN . /etc/environment && tar -czvf ${BUILD_NAME}.tar.gz -C $RV_INST ${BUILD_NAME}
RUN . /etc/environment && echo -e "\n\e[1;32mRun the following lines to copy your OpenRV build into your ~/Downloads folder:\e[0m" && \
    echo -e "\e[1;36msudo docker run -d --name <your_container_name> <repo>/<container>:<tag>\e[0m" && \
    echo -e "\e[1;36msudo docker cp <your_container_name>:$RV_INST/${BUILD_NAME}.tar.gz ~/Downloads/\e[0m\n\n"


RUN rm -rf /build
RUN dnf autoremove -y && dnf clean all
