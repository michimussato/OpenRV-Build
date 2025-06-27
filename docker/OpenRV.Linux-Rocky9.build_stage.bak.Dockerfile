FROM openstudiolandscapes/openrv_linux_rocky9_build_base:latest AS openrv_linux_rocky9_build_stage
# Build:
# docker build --file ./Dockerfile.Linux-Rocky9.build_stage --progress plain --build-arg FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc" --build-arg FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac" --tag openstudiolandscapes/openrv_linux_rocky9_build_stage:latest .
#
# Run (attached):
# Ref: https://stackoverflow.com/a/55734437/2207196
# docker run -v ${HOME}/openrv_build:/home/rv/OpenRV --hostname openrv_linux_rocky9_build_stage --rm --name openrv_linux_rocky9_build_stage openstudiolandscapes/openrv_linux_rocky9_build_stage:latest /bin/bash -c "trap : TERM INT; sleep infinity & wait"
#
# Exec:
# docker container exec --interactive --tty openrv_linux_rocky9_build_stage /bin/bash

# Process tested with user rv: [x]

# LABEL maintainer="Michael Mussato"

USER rv
ENV HOME="/home/rv"

ENV QT_HOME="${HOME}/Qt/5.15.2/gcc_64"
ENV OPENRV_REPO_DIR="${HOME}/OpenRV"
ENV RV_INST="${OPENRV_REPO_DIR}/_install"

ARG FFMPEG_NON_FREE_DECODERS_TO_ENABLE
ARG FFMPEG_NON_FREE_ENCODERS_TO_ENABLE

RUN <<-"EOT" ${HOME}/clone_openrv.sh
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

echo 'source ${OPENRV_REPO_DIR}/rvcmds.sh' >> ~/.bashrc

source ~/.bashrc

popd
EOT



RUN <<-"EOT" ${HOME}/prepare_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

echo "Starting build preparation..."
rvsetup
rvcfg -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="${FFMPEG_NON_FREE_DECODERS_TO_ENABLE}" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="${FFMPEG_NON_FREE_ENCODERS_TO_ENABLE}"
rvbuildt dependencies
rvbuildt main_executable

popd
EOT



RUN <<-"EOT" ${HOME}/build_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

echo "Starting build..."
rvbuildt dependencies
rvbuildt main_executable

popd
EOT



RUN <<-"EOT" ${HOME}/install_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}

echo "Installing OpenRV to ${RV_INST}..."
rvinst

popd
EOT


ENV ENVIRONMENT="${OPENRV_REPO_DIR}/environment"

RUN <<-"EOT" ${HOME}/package_prepare_openrv.sh
#!/usr/bin/env bash

pushd ${HOME}


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
ARCHITECTURE=$(uname -m) &&
echo "BUILD_PLATFORM=${BUILD_PLATFORM}" > ${ENVIRONMENT}
echo "VERSION=${VERSION}" >> ${ENVIRONMENT}
echo "ARCHITECTURE=${ARCHITECTURE}" >> ${ENVIRONMENT}
BUILD_NAME=OpenRV-${BUILD_PLATFORM}-${ARCHITECTURE}-${VERSION}
echo "BUILD_NAME=${BUILD_NAME}" >> ${ENVIRONMENT}
echo "${BUILD_NAME}" >> ${OPENRV_REPO_DIR}/build_name.txt

popd
EOT

# # Source the environment variables file
# RUN . ${ENVIRONMENT} && echo "Build Name: ${BUILD_NAME}"
# # rvinst
# # alias rvinst="rvenv && cmake --install ${RV_BUILD} --prefix ${RV_INST} --config Release"
# RUN . ${ENVIRONMENT} && . rvcmds.sh && rvinst
# RUN . ${ENVIRONMENT} && cp /lib64/libcrypt.so.2 $RV_INST/lib
# # RUN . ${ENVIRONMENT} && tar -czvf ${BUILD_NAME}.tar.gz -C ${RV_INST} ${BUILD_NAME}
# RUN . ${ENVIRONMENT} && tar -czvf ${BUILD_NAME}.tar.gz -C ${RV_INST} .
# RUN . ${ENVIRONMENT} && echo -e "\n\e[1;32mRun the following lines to copy your OpenRV build into your ~/Downloads folder:\e[0m" && \
#     echo -e "\e[1;36msudo docker run -d --name <your_container_name> <repo>/<container>:<tag>\e[0m" && \
#     echo -e "\e[1;36msudo docker cp <your_container_name>:${RV_INST}/${BUILD_NAME}.tar.gz ~/Downloads/\e[0m\n\n"


ENV RV_PACKAGE="${OPENRV_REPO_DIR}/_package"

RUN <<-"EOT" ${HOME}/package_openrv.sh
#!/usr/bin/env bash



pushd ${HOME}

cd ${OPENRV_REPO_DIR}

. ${ENVIRONMENT}

echo "Build Name: ${BUILD_NAME}"

# echo "Sourcing rvcmds.sh..."
# source ${OPENRV_REPO_DIR}/rvcmds.sh

# rvinst

cp /lib64/libcrypt.so.2 ${RV_INST}/lib

mkdir -p ${RV_PACKAGE}
tar -czvf ${RV_PACKAGE}/${BUILD_NAME}.tar.gz -C ${RV_INST} .

echo -e "\n\e[1;32mRun the following lines to copy your OpenRV build into your ~/Downloads folder:\e[0m"
echo -e "\e[1;36msudo docker run -d --name <your_container_name> <repo>/<container>:<tag>\e[0m"
echo -e "\e[1;36msudo docker cp <your_container_name>:${RV_INST}/${BUILD_NAME}.tar.gz ~/Downloads/\e[0m\n\n"

EOT


CMD ["/bin/bash"]
