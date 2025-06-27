FROM openstudiolandscapes/openrv_linux_rocky9_build_base:latest AS openrv_linux_rocky9_build_stage
# Build:
# /usr/bin/time -f 'Commandline Args: %C\nElapsed Time: %E\nPeak Memory: %M\nExit Code: %x' docker build --file ./OpenRV.Linux-Rocky9.build_stage.Dockerfile --progress plain --build-arg FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc" --build-arg FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac" --tag openstudiolandscapes/openrv_linux_rocky9_build_stage:latest .
#
# Run (attached):
# Ref: https://stackoverflow.com/a/55734437/2207196
# docker run --hostname openrv_linux_rocky9_build_stage --rm --name openrv_linux_rocky9_build_stage openstudiolandscapes/openrv_linux_rocky9_build_stage:latest /bin/bash -c "trap : TERM INT; sleep infinity & wait"
#
# Exec:
# docker container exec --interactive --tty openrv_linux_rocky9_build_stage /bin/bash

# Process tested with user rv: [x]
# STATUS: WORKING

# LABEL maintainer="Michael Mussato"

# SHELL ["/bin/bash", "-c"]

USER rv
ENV HOME="/home/rv"

ARG FFMPEG_NON_FREE_DECODERS_TO_ENABLE=""
ARG FFMPEG_NON_FREE_ENCODERS_TO_ENABLE=""

ENV QT_HOME="${HOME}/Qt/5.15.2/gcc_64"
ENV OPENRV_REPO_DIR="${HOME}/OpenRV"
ENV RV_INST="${OPENRV_REPO_DIR}/_install"

WORKDIR ${OPENRV_REPO_DIR}

RUN git clone \
    --recursive \
    https://github.com/AcademySoftwareFoundation/OpenRV.git \
    .

# RUN echo 'source ${OPENRV_REPO_DIR}/rvcmds.sh' >> ~/.bashrc

RUN echo "Starting build steps..."
RUN . ${OPENRV_REPO_DIR}/rvcmds.sh
# Setup .venv
# rvenv_shell is a function, not an alias, hence, this works here.
# Bash aliases, however, work in an interactive session but not during a build process.
RUN . ${OPENRV_REPO_DIR}/rvcmds.sh && rvenv_shell

ENV ACTIVATE=${OPENRV_REPO_DIR}/.venv/bin/activate

# RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvenv]}
# -> rvenv_shell

# RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvsetup]}
# -> rvenv && SETUPTOOLS_USE_DISTUTILS= python3 -m pip install --upgrade -r /home/rv/OpenRV/requirements.txt
RUN . ${ACTIVATE} && SETUPTOOLS_USE_DISTUTILS= python3 -m pip install --upgrade -r ${OPENRV_REPO_DIR}/requirements.txt

# RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvcfg]}
# -> rvenv && cmake -B /home/rv/OpenRV/_build -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DRV_DEPS_QT5_LOCATION=/home/rv/Qt/5.15.2/gcc_64 -DRV_VFX_PLATFORM=CY2023 -DRV_DEPS_WIN_PERL_ROOT=
RUN . ${ACTIVATE} && cmake -B ${OPENRV_REPO_DIR}/_build -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DRV_DEPS_QT5_LOCATION=${QT_HOME} -DRV_VFX_PLATFORM=CY2023 -DRV_DEPS_WIN_PERL_ROOT= -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="${FFMPEG_NON_FREE_DECODERS_TO_ENABLE}" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="${FFMPEG_NON_FREE_ENCODERS_TO_ENABLE}"

# RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvbuildt]}
# -> rvenv && cmake --build /home/rv/OpenRV/_build --config Release -v --parallel=8 --target
RUN . ${ACTIVATE} && cmake --build ${OPENRV_REPO_DIR}/_build --config Release -v --parallel=$(nproc) --target dependencies
RUN . ${ACTIVATE} && cmake --build ${OPENRV_REPO_DIR}/_build --config Release -v --parallel=$(nproc) --target main_executable

# RUN . ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvinst]}
# -> rvenv && cmake --install /home/rv/OpenRV/_build --prefix /home/rv/OpenRV/_install --config Release
RUN . ${ACTIVATE} && cmake --install ${OPENRV_REPO_DIR}/_build --prefix ${RV_INST} --config Release

ENV ENVIRONMENT="${OPENRV_REPO_DIR}/environment"

# Determine build platform, version, and architecture for creation of rv tarball name
RUN echo "Determining build platform..." && \
    if [ -f /etc/os-release ]; then \
        . /etc/os-release; \
        if [ "${NAME}" = "Rocky Linux" ]; then \
            BUILD_PLATFORM="Rocky${VERSION_ID%.*}"; \
        else \
            BUILD_PLATFORM=$(echo ${NAME}${VERSION_ID} | tr ' ' '_'); \
        fi \
    else \
        BUILD_PLATFORM=$(uname -s); \
    fi && \
    ENVIRONMENT="${OPENRV_REPO_DIR}/environment" && \
    VERSION=$(${OPENRV_REPO_DIR}/_build/stage/app/bin/rv -version) && \
    ARCHITECTURE=$(uname -m) && \
    echo "BUILD_PLATFORM=${BUILD_PLATFORM}" > ${ENVIRONMENT} && \
    echo "VERSION=${VERSION}" >> ${ENVIRONMENT} && \
    echo "ARCHITECTURE=${ARCHITECTURE}" >> ${ENVIRONMENT} && \
    BUILD_NAME=OpenRV-${BUILD_PLATFORM}-${ARCHITECTURE}-${VERSION} && \
    echo "BUILD_NAME=${BUILD_NAME}" >> ${ENVIRONMENT} && \
    echo "${BUILD_NAME}" >> ${OPENRV_REPO_DIR}/build_name.txt


# Create Tar
# Source the environment variables file
RUN . ${ENVIRONMENT} && echo "Build Name: ${BUILD_NAME}"
# rvinst
# alias rvinst="rvenv && cmake --install ${RV_BUILD} --prefix ${RV_INST} --config Release"
# RUN . ${ENVIRONMENT} && . rvcmds.sh && rvinst
RUN . ${ENVIRONMENT} && cp /lib64/libcrypt.so.2 {$RV_INST}/lib
# RUN . ${ENVIRONMENT} && tar -czvf ${BUILD_NAME}.tar.gz -C ${RV_INST} ${BUILD_NAME}
RUN . ${ENVIRONMENT} && tar -czvf ${BUILD_NAME}.tar.gz -C ${RV_INST} .
RUN . ${ENVIRONMENT} && echo -e "\n\e[1;32mRun the following lines to copy your OpenRV build into your ~/Downloads folder:\e[0m" && \
    echo -e "\e[1;36msudo docker run -d --name <your_container_name> <repo>/<container>:<tag>\e[0m" && \
    echo -e "\e[1;36msudo docker cp <your_container_name>:${RV_INST}/${BUILD_NAME}.tar.gz ~/Downloads/\e[0m\n\n"


CMD ["/bin/bash"]
