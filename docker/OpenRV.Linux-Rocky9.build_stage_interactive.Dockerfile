FROM openstudiolandscapes/openrv_linux_rocky9_build_base:latest AS openrv_linux_rocky9_build_stage_interactive
# Build:
# docker build --file ./OpenRV.Linux-Rocky9.build_stage_interactive.Dockerfile --progress plain --tag openstudiolandscapes/openrv_linux_rocky9_build_stage_interactive:latest .
#
# Run (attached):
# Ref: https://stackoverflow.com/a/55734437/2207196
# docker run -it -e FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc" -e FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac" -v ${HOME}/openrv_build:/home/rv/export/OpenRV --hostname openrv_linux_rocky9_build_stage_interactive --rm --name openrv_linux_rocky9_build_stage_interactive openstudiolandscapes/openrv_linux_rocky9_build_stage_interactive:latest /bin/bash
#
# Exec:
# docker container exec --interactive --tty openrv_linux_rocky9_build_stage /bin/bash

# STATUS: NOT WORKING

# LABEL maintainer="Michael Mussato"

USER rv
ENV HOME="/home/rv"

ENV QT_HOME="${HOME}/Qt/5.15.2/gcc_64"
ENV OPENRV_REPO_DIR="${HOME}/OpenRV"
ENV RV_INST="${OPENRV_REPO_DIR}/_install"
# ENV RV_PACKAGE="${HOME}/export/OpenRV"

# WORKDIR ${RV_PACKAGE}
WORKDIR ${HOME}


# https://docs.docker.com/reference/dockerfile/#here-documents
COPY <<-"EOT" ${HOME}/01_clone_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

mkdir -p ${OPENRV_REPO_DIR}
cd ${OPENRV_REPO_DIR}

echo "Cloning Repo..."
git clone \
    --recursive \
    https://github.com/AcademySoftwareFoundation/OpenRV.git \
    .

# echo "Sourcing rvcmds.sh..."
# source rvcmds.sh

# echo 'source ${OPENRV_REPO_DIR}/rvcmds.sh' >> ~/.bashrc

# . ~/.bashrc

popd
EOT



COPY <<-"EOT" ${HOME}/02_configure_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

cd ${OPENRV_REPO_DIR}
set -a
. rvcmds.sh
set +a

# $ ./02_configure_openrv.sh
# ~ ~
# Using Qt 5 installation already set at /home/rv/Qt/5.15.2/gcc_64
# Please ensure you have installed any required dependencies from doc/build_system/config_[os]
#
# CMake parameters:
# RV_BUILD_PARALLELISM is 8
# RV_HOME is /home/rv/OpenRV
# RV_BUILD is /home/rv/OpenRV/_build
# RV_INST is /home/rv/OpenRV/_install
# CMAKE_GENERATOR is Ninja
# QT_HOME is /home/rv/Qt/5.15.2/gcc_64
# To override any of them do unset [name]; export [name]=value; source rvcmds.sh
#
# If this is your first time building RV try rvbootstrap (release) or rvbootstrapd (debug)
# To build quickly after bootstraping try rvmk (release) or rvmkd (debug)
# Starting build preparation...
# ./02_configure_openrv.sh: line 11: rvsetup: command not found
# ./02_configure_openrv.sh: line 12: rvcfg: command not found
# ~

echo "Starting build preparation..."
rvsetup
rvcfg -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="${FFMPEG_NON_FREE_DECODERS_TO_ENABLE}" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="${FFMPEG_NON_FREE_ENCODERS_TO_ENABLE}"

popd
EOT



COPY <<-"EOT" ${HOME}/03_build_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

cd ${OPENRV_REPO_DIR}
. rvcmds.sh

echo "Starting build..."
rvbuildt dependencies
rvbuildt main_executable

popd
EOT



COPY <<-"EOT" ${HOME}/04_install_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

cd ${OPENRV_REPO_DIR}
. rvcmds.sh

echo "Installing OpenRV to ${RV_INST}..."
rvinst

popd
EOT


# PACKAGE_PREPARE
ENV ENVIRONMENT="${OPENRV_REPO_DIR}/environment"

COPY <<-"EOT" ${HOME}/05_package_prepare_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

cd ${OPENRV_REPO_DIR}
. rvcmds.sh

# Determine build platform, version, and architecture for creation of rv tarball name
echo "Determining build platform..."

if [ -f /etc/os-release ]; then
    . /etc/os-release;
    if [ "${NAME}" = "Rocky Linux" ]; then
        BUILD_PLATFORM="Rocky${VERSION_ID%.*}";
    else
        BUILD_PLATFORM=$(echo ${NAME}${VERSION_ID} | tr ' ' '_');
    fi
else
    BUILD_PLATFORM=$(uname -s);
fi

ENVIRONMENT="${OPENRV_REPO_DIR}/environment"
VERSION=$(${OPENRV_REPO_DIR}/_build/stage/app/bin/rv -version)
ARCHITECTURE=$(uname -m)

echo "BUILD_PLATFORM=${BUILD_PLATFORM}" > ${ENVIRONMENT}
echo "VERSION=${VERSION}" >> ${ENVIRONMENT}
echo "ARCHITECTURE=${ARCHITECTURE}" >> ${ENVIRONMENT}

BUILD_NAME=OpenRV-${BUILD_PLATFORM}-${ARCHITECTURE}-${VERSION}

echo "BUILD_NAME=${BUILD_NAME}" >> ${ENVIRONMENT}
echo "${BUILD_NAME}" >> ${OPENRV_REPO_DIR}/build_name.txt

popd
EOT


# PACKAGE
COPY <<-"EOT" ${HOME}/06_package_openrv.sh
#!/usr/bin/env bash


pushd ${HOME}

cd ${OPENRV_REPO_DIR}
. rvcmds.sh

cd ${OPENRV_REPO_DIR}

. ${ENVIRONMENT}

echo "Build Name: ${BUILD_NAME}"

# echo "Sourcing rvcmds.sh..."
# source ${OPENRV_REPO_DIR}/rvcmds.sh

# rvinst

cp /lib64/libcrypt.so.2 ${RV_INST}/lib

mkdir -p ${RV_PACKAGE}
tar -czvf ${RV_PACKAGE}/${BUILD_NAME}.tar.gz -C ${RV_INST} .

popd
EOT


USER root
RUN chown rv:rv ${HOME}/*.sh
RUN chmod a+x ${HOME}/*.sh


USER rv


CMD ["/bin/bash"]
