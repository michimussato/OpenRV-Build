

```shell
source .env

sudo dnf install -y git

sudo dnf install -y epel-release
sudo dnf config-manager --set-enabled crb devel
sudo dnf install -y alsa-lib-devel autoconf automake avahi-compat-libdns_sd-devel bison bzip2-devel cmake-gui curl-devel flex gcc gcc-c++ libXcomposite libXi-devel libaio-devel libffi-devel nasm ncurses-devel nss libtool libxkbcommon libXcomposite libXdamage libXrandr libXtst libXcursor mesa-libOSMesa mesa-libOSMesa-devel meson ninja-build openssl-devel patch perl-FindBin pulseaudio-libs pulseaudio-libs-glib2 ocl-icd ocl-icd-devel opencl-headers python3 python3-devel qt5-qtbase-devel readline-devel sqlite-devel systemd-devel tcl-devel tcsh tk-devel yasm zip zlib-devel 

sudo dnf config-manager --set-disabled devel

sudo dnf install -y mesa-libGLU mesa-libGLU-devel

wget https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3.tar.gz
tar -zxvf cmake-3.30.3.tar.gz
pushd cmake-3.30.3
time ./bootstrap --parallel=$(nproc)
time make -j $(nproc)
sudo make install

# logout/login

cmake --version  # confirm the version of your newly installed version of CMake
cmake version3.30.3

popd

curl --location \
    --remote-name \
    https://d13lb3tujbc8s0.cloudfront.net/onlineinstallers/qt-unified-linux-x64-4.6.1-online.run
chmod a+x qt-unified-linux-x64-4.6.1-online.run
# Too many licenses?
# https://account.qt.io/s/active-installation-list
sudo ./qt-unified-linux-x64-4.6.1-online.run \
    --verbose \
    --email "${QT_EMAIL}" \
    --password "${QT_PASSWORD}" \
    --root "${QT_ROOT}" \
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

mkdir -p ~/git/repos
cd ~/git/repos

# from here to start over

mkdir -p OpenRV
pushd OpenRV
git clone --recursive https://github.com/AcademySoftwareFoundation/OpenRV.git .

python3 -m pip install -r requirements.txt

export QT_HOME="${QT_ROOT}/${QT_HOME_VERSION}/gcc_64"
# RV_HOME="${RV_HOME:-$SCRIPT_HOME}"
# RV_BUILD="${RV_BUILD:-${RV_HOME}/_build}"
# RV_BUILD_DEBUG="${RV_BUILD_DEBUG:-${RV_HOME}/_build_debug}"
# RV_INST="${RV_INST:-${RV_HOME}/_install}"
export RV_INST="${RV_ROOT}"
# RV_INST_DEBUG="${RV_INST_DEBUG:-${RV_HOME}/_install_debug}"
# RV_BUILD_PARALLELISM="${RV_BUILD_PARALLELISM:-$(python3 -c 'import os; print(os.cpu_count())')}"

source rvcmds.sh
time rvsetup

# Encoders
#   SET(NON_FREE_ENCODERS_TO_DISABLE
#       "aac"
#       "aac_mf"
#       "dnxhd"
#       "dvvideo"
#       "prores"
#       "qtrle"
#       "vp9_qsv"
#       "vp9_vaapi"
#   )
# Decoders:
#   SET(NON_FREE_DECODERS_TO_DISABLE
#       "aac"
#       "aac_at"
#       "aac_fixed"
#       "aac_latm"
#       "bink"
#       "binkaudio_dct"
#       "binkaudio_rdft"
#       "dnxhd"
#       "dvvideo"
#       "prores"
#       "qtrle"
#       "vp9"
#       "vp9_cuvid"
#       "vp9_mediacodec"
#       "vp9_qsv"
#       "vp9_rkmpp"
#       "vp9_v4l2m2m"
#   )
# - rvcfg
#   - [x] build
#   - [x] execute
# - rvcfg -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac"
#   - [ ] build
#   - [ ] execute
# - rvcfg -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc;prores" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac;prores"
#   - [x] build
#   - [-] execute
# - rvcfg -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc;dnxhd" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac;dnxhd"
#   - [x] build
#   - [x] execute
time rvbuildt dependencies
# rvenv && cmake --build _build --config Release -v --parallel=$(nproc) --target dependencies
time rvbuildt main_executable
# rvenv && cmake --build _build --config Release -v --parallel=$(nproc) --target main_executable
time rvinst
# rvenv && cmake --install ${RV_BUILD} --prefix ${RV_INST} --config Release
# cmake --install ${RV_BUILD} --prefix ${RV_INST}

# Clean:
# rvclean  # Not working correctly?
# rm -rf ~/git/repos/OpenRV

# ~/git/repos/OpenRV/_build/stage/app/bin/rv

# Issues
# ERROR: ******* NV-GLX Extension Missibng *******

# rvmk

popd

```