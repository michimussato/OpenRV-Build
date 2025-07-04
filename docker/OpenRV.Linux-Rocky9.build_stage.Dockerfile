FROM openstudiolandscapes/openrv_linux_rocky9_build_base:latest AS openrv_linux_rocky9_build_stage
# Build:
# CMAKE_GENERATOR: "Ninja" or "Unix Makefiles" (https://aur.archlinux.org/packages/openrv-git)
# export DOCKERFILE="OpenRV.Linux-Rocky9.build_stage.Dockerfile" && /usr/bin/time -f 'Commandline Args: %C\nElapsed Time: %E\nPeak Memory: %M\nExit Code: %x' docker build --file ./docker/${DOCKERFILE} --progress plain --build-arg BUILD_ARGS="-Wno-dev" --build-arg CMAKE_GENERATOR="Ninja" --build-arg FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc" --build-arg FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac" --tag openstudiolandscapes/$(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g'):latest --tag openstudiolandscapes/$(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g'):$(date +"%Y-%m-%d_%H-%M-%S") --output ./docker/tarballs . > >(tee -a ./docker/${DOCKERFILE}.STDOUT.log) 2> >(tee -a ./docker/{DOCKERFILE}.STDERR.log >&2) && unset DOCKERFILE
#
# Run (attached):
# Ref: https://stackoverflow.com/a/55734437/2207196
# docker run --hostname openrv_linux_rocky9_build_stage --rm --name openrv_linux_rocky9_build_stage openstudiolandscapes/openrv_linux_rocky9_build_stage:latest /bin/bash -c "trap : TERM INT; sleep infinity & wait"
#
# Exec bash:
# docker container exec --interactive --tty openrv_linux_rocky9_build_stage /bin/bash
# # Exec rv:
# # docker container exec --interactive --tty openrv_linux_rocky9_build_stage /home/rv/OpenRV/_install/bin/rv
#
# Copy OpenRV tar to host:
# docker cp openrv_linux_rocky9_build_stage:/home/rv/OpenRV/OpenRV-Rocky9-x86_64-3.0.0.tar.gz ~/Downloads
#
# Export Docker image to tar:
# docker save --output openrv_linux_rocky9_build_stage.tar openstudiolandscapes/openrv_linux_rocky9_build_stage:latest
# Convert tar to Apptainer
# apptainer build openrv_linux_rocky9_build_stage.sif docker-archive:openrv_linux_rocky9_build_stage.tar
# Run OpenRV from Apptainer
# apptainer exec --nv --bind /run/user/$UID,/Volumes,/run/media/$USER openrv_linux_rocky9_build_stage.sif /home/rv/OpenRV/_install/bin/rv

# Process tested with user rv: [x]
# STATUS: WORKING

# LABEL maintainer="Michael Mussato"

# SHELL ["/bin/bash", "-c"]

USER rv
ENV HOME="/home/rv"

ARG FFMPEG_NON_FREE_DECODERS_TO_ENABLE=""
ARG FFMPEG_NON_FREE_ENCODERS_TO_ENABLE=""
ARG CMAKE_GENERATOR="Ninja"
ARG BUILD_ARGS=""

ENV QT_HOME="${HOME}/Qt/5.15.2/gcc_64"
ENV OPENRV_REPO_DIR="${HOME}/OpenRV"
ENV RV_INST="${OPENRV_REPO_DIR}/_install"
ENV RV_TARBALL="${OPENRV_REPO_DIR}/_tarball"

WORKDIR ${OPENRV_REPO_DIR}

RUN \
    git clone \
    --recursive \
    --depth 1 \
    https://github.com/AcademySoftwareFoundation/OpenRV.git \
    .

# RUN echo 'source ${OPENRV_REPO_DIR}/rvcmds.sh' >> ~/.bashrc

RUN echo "Starting build steps..."
# RUN . ${OPENRV_REPO_DIR}/rvcmds.sh
# Setup .venv
# rvenv_shell is a function, not an alias, hence, this works here.
# Bash aliases, however, work in an interactive session but not during a build process.
RUN . ${OPENRV_REPO_DIR}/rvcmds.sh && rvenv_shell

ENV ACTIVATE=${OPENRV_REPO_DIR}/.venv/bin/activate

# RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvenv]}
# -> rvenv_shell

# RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvsetup]}
# -> rvenv && SETUPTOOLS_USE_DISTUTILS= python3 -m pip install --upgrade -r /home/rv/OpenRV/requirements.txt
RUN \
    . ${ACTIVATE} && pip install --upgrade pip && \
    SETUPTOOLS_USE_DISTUTILS= python3 -m pip install --upgrade -r ${OPENRV_REPO_DIR}/requirements.txt && \
    \
    # RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvcfg]}
    # -> rvenv && cmake -B /home/rv/OpenRV/_build -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DRV_DEPS_QT5_LOCATION=/home/rv/Qt/5.15.2/gcc_64 -DRV_VFX_PLATFORM=CY2023 -DRV_DEPS_WIN_PERL_ROOT=
    # More Args (BUILD_ARGS):
    #  -Wno-dev
    cmake -B ${OPENRV_REPO_DIR}/_build -G "${CMAKE_GENERATOR}" ${BUILD_ARGS} -DCMAKE_BUILD_TYPE=Release -DRV_DEPS_QT5_LOCATION=${QT_HOME} -DRV_VFX_PLATFORM=CY2023 -DRV_DEPS_WIN_PERL_ROOT= -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="${FFMPEG_NON_FREE_DECODERS_TO_ENABLE}" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="${FFMPEG_NON_FREE_ENCODERS_TO_ENABLE}" && \
    \
    # RUN source ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvbuildt]}
    # -> rvenv && cmake --build /home/rv/OpenRV/_build --config Release -v --parallel=8 --target
    cmake --build ${OPENRV_REPO_DIR}/_build --config Release -v --parallel=$(nproc) --target dependencies && \
    cmake --build ${OPENRV_REPO_DIR}/_build --config Release -v --parallel=$(nproc) --target main_executable && \
    \
    # RUN . ${OPENRV_REPO_DIR}/rvcmds.sh && echo ${BASH_ALIASES[rvinst]}
    # -> rvenv && cmake --install /home/rv/OpenRV/_build --prefix /home/rv/OpenRV/_install --config Release
    cmake --install ${OPENRV_REPO_DIR}/_build --prefix ${RV_INST} --config Release && \
    # Todo
    # - [ ] Cleanup ${HOME}/OpenRV/_build
    # - [ ] Cleanup ${HOME}/OpenRV/_install
    # - [x] Cleanup ${HOME}/Qt
    # $ du -hs ${HOME}/OpenRV/_build
    # 14G     /home/rv/OpenRV/_build
    # $ du -hs ${HOME}/OpenRV/_install
    # 1.4G    /home/rv/OpenRV/_install
    # $ du -hs ${HOME}/Qt
    # 4.4G    /home/rv/Qt
    # rm -rf ${OPENRV_REPO_DIR}/_build && \
    rm -rf ${HOME}/Qt


ENV ENVIRONMENT="${OPENRV_REPO_DIR}/environment"

# Determine build platform, version, and architecture for creation of rv tarball name
RUN \
    echo "Determining build platform..." && \
    if [ -f /etc/os-release ]; then \
        . /etc/os-release; \
        BUILD_PLATFORM=$(echo ${NAME}${VERSION_ID} | tr ' ' '_'); \
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
    echo "${BUILD_NAME}" >> ${OPENRV_REPO_DIR}/build_name.txt && \
    echo "${BUILD_NAME}" >> ${RV_INST}/build_name.txt


# Create Tar
# Source the environment variables file
RUN . ${ENVIRONMENT} && echo "Build Name: ${BUILD_NAME}"
RUN . ${ENVIRONMENT} && cp /lib64/libcrypt.so.2 ${RV_INST}/lib
RUN . ${ENVIRONMENT} && mkdir -p ${RV_TARBALL} && tar -czvf "${RV_TARBALL}/${BUILD_NAME}.tar.gz" -C ${RV_INST} .



FROM scratch AS openrv_linux_rocky9_build_stage_export

ENV RV_TARBALL="/home/rv/OpenRV/_tarball"

COPY --from=openrv_linux_rocky9_build_stage ${RV_TARBALL} .

CMD ["/bin/bash"]
