<!-- TOC -->
* [OpenRV-Rocky9-Docker](#openrv-rocky9-docker)
  * [Install Docker](#install-docker)
  * [3. Build image from this Dockerfile](#3-build-image-from-this-dockerfile)
      * [Troubleshooting](#troubleshooting)
  * [4. Copy your OpenRV build from the docker](#4-copy-your-openrv-build-from-the-docker)
  * [5. Untar and test your OpenRV build](#5-untar-and-test-your-openrv-build)
  * [6. Clean up](#6-clean-up)
  * [7. Trouble shooting.](#7-trouble-shooting)
* [Maximum Number of Qt Installation reached](#maximum-number-of-qt-installation-reached)
<!-- TOC -->

---

# OpenRV-Rocky9-Docker
A Dockerfile to build OpenRV with a Rocky 9 base, based on [OpenRV](https://github.com/AcademySoftwareFoundation/OpenRV.git). This setup is tested on Ubuntu 22.04 but should work just as well for other Linux distributions. Be sure that you have about 30GB of free space for the temporary build files. The total file size for rv is 468M and total compute time was about 33 minutes on a machine with 128 threads.

## Install Docker

https://docs.docker.com/engine/install/centos/

## 3. Build image from this Dockerfile
Build the image from the OpenRV-Rocky9-Docker directory. Replace your_qt_username and your_qt_password with your actual Qt login credentials. If you don't have an account, you can get a free account [here](https://login.qt.io/register).

```shell
set -a
source .env  # if there is one, otherwise fill in the args manually
set +a

/usr/bin/time -f 'Commandline Args: %C\nElapsed Time: %E\nPeak Memory: %M\nExit Code: %x' \
    docker build \
    --file ./Dockerfile \
    --progress plain \
    --build-arg QT_EMAIL=${QT_EMAIL} \
    --build-arg QT_PASSWORD=${QT_PASSWORD} \
    --build-arg CMAKE_VERSION=${CMAKE_VERSION} \
    --build-arg RV_INST=${RV_INST} \
    --build-arg QT_INSTALLER_VERSION=${QT_INSTALLER_VERSION} \
    --build-arg QT_ROOT=${QT_ROOT} \
    --build-arg FFMPEG_NON_FREE_DECODERS_TO_ENABLE=${FFMPEG_NON_FREE_DECODERS_TO_ENABLE} \
    --build-arg FFMPEG_NON_FREE_ENCODERS_TO_ENABLE=${FFMPEG_NON_FREE_ENCODERS_TO_ENABLE} \
    --tag openstudiolandscapes/openrv_rocky9:latest .
```
Note: You may need to use sudo, depending on your configuration.

#### Troubleshooting

- CMake Error: If you encounter a CMake error "Could not find a package configuration file provided by 'Qt5WebEngineCore'", your Qt installation likely failed. Check step 9 of 22 in the Docker build process for the reason why.
- Qt Installation Warning: If you get the warning "Maximum number of Qt installations reached", log in to your [qt account](https://account.qt.io/s/active-installation-list) and delete some of your existing installations. Ensure your username and password are correct.

## 4. Copy your OpenRV build from the docker
Run the below command to copy the OpenRV build from the docker to your current work directory.
```
docker run --name openrv_container -d openrv_rocky9 tail -f /dev/null
BUILD_NAME=$(docker exec openrv_container /bin/bash -c "source /etc/environment && echo \${BUILD_NAME}")
docker cp openrv_container:/OpenRV/${BUILD_NAME}.tar.gz $PWD/
docker stop openrv_container
docker rm -f openrv_container
```

## 5. Untar and test your OpenRV build
Use the tar command to decompress your OpenRV build and start up openRV:
```
tar -xvf OpenRV-Rocky9-x86_64-2.0.0.tar.gz
cd OpenRV-Rocky9-x86_64-2.0.0/bin
./rv
```
You should see your shiny new build of openRV!

## 6. Clean up
If everything went well with your docker build you can remove the files to free disk space with the following commands:
List all containers and images:
```
docker system df -v
docker ps -a
```
Delete the files associated with this build to free up drive space

```
docker stop openrv_container
docker rm openrv_container
docker rmi openrv_rocky9
```
## 7. Trouble shooting.
This is my first time with docker, just getting used to it so I'm leaving a few notes for future self.
If you need to trouble shoot your docker during the build you can get a shell like this:
```
docker run -it openrv_rocky9 /bin/bash

```



Docker log output

```
output clipped, log limit 2MiB reached
```

What do do?
https://github.com/docker/buildx/issues/484#issuecomment-767434491


# Maximum Number of Qt Installation reached

```
1.639 [1467] "<p><b style='color: rgb(255, 0, 0);'>Too many installations</b></p><p style='font-size:10pt; font-weight:400;'>Maximum number of Qt installation reached, please manage your installations via <a href='https://account.qt.io/s/active-installation-list' target='_blank'><b>Qt Account</b></a> or contact support via <a href='mailto:license-management@qt.io' target='_blank'><b>email</b></a></p>" [ "too_many_installation" ]
1.639 [1467] Warning: <p><b style='color: rgb(255, 0, 0);'>Too many installations</b></p><p style='font-size:10pt; font-weight:400;'>Maximum number of Qt installation reached, please manage your installations via <a href='https://account.qt.io/s/active-installation-list' target='_blank'><b>Qt Account</b></a> or contact support via <a href='mailto:license-management@qt.io' target='_blank'><b>email</b></a></p>
1.639 [1467] Warning: No valid license found.
```

Delete obsolete licenses via https://account.qt.io/s/active-installation-list
```#26 [23/35] RUN which python
#26 0.162 /build/OpenRV/.venv/bin/python
#26 DONE 0.2s

#27 [24/35] RUN python --version
#27 0.198 Python 3.9.21
#27 DONE 0.2s

#28 [25/35] RUN cmake     -B /build/OpenRV/_build     -G Ninja     -DCMAKE_BUILD_TYPE=Release     -DRV_DEPS_QT5_LOCATION=/opt/Qt//gcc_64     -DRV_VFX_PLATFORM=CY2023     -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc"     -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac"
#28 0.408 -- The CXX compiler identification is GNU 11.5.0
#28 0.500 -- The C compiler identification is GNU 11.5.0
#28 0.516 -- Detecting CXX compiler ABI info
#28 0.596 -- Detecting CXX compiler ABI info - done
#28 0.606 -- Check for working CXX compiler: /usr/bin/c++ - skipped
#28 0.607 -- Detecting CXX compile features
#28 0.608 -- Detecting CXX compile features - done
#28 0.614 -- Detecting C compiler ABI info
#28 0.659 -- Detecting C compiler ABI info - done
#28 0.672 -- Check for working C compiler: /usr/bin/cc - skipped
#28 0.672 -- Detecting C compile features
#28 0.672 -- Detecting C compile features - done
#28 0.673 PROJECT DIR /build/OpenRV
#28 0.673 -- Build type: Release
#28 0.674 -- Building RV for generic Linux OS
#28 0.676 -- Redhat Entreprise Linux version: Rocky Linux release 9.6 (Blue Onyx)
#28 0.676 
#28 0.680 -- Using build branch: main
#28 0.680 -- Using build hash: 62bbf5f
#28 0.681 -- RV_STAGE_ROOT_DIR: /build/OpenRV/_build/stage/app
#28 0.681 -- RV_STAGE_BIN_DIR: /build/OpenRV/_build/stage/app/bin
#28 0.681 -- RV_STAGE_LIB_DIR: /build/OpenRV/_build/stage/app/lib
#28 0.681 -- RV_STAGE_INCLUDE_DIR: /build/OpenRV/_build/stage/app/include
#28 0.681 -- RV_STAGE_SRC_DIR: /build/OpenRV/_build/stage/app/src
#28 0.681 -- RV_STAGE_RESOURCES_DIR: /build/OpenRV/_build/stage/app/resources
#28 0.681 -- RV_STAGE_PLUGINS_DIR: /build/OpenRV/_build/stage/app/plugins
#28 0.681 -- RV_STAGE_PLUGINS_CONFIGFILES_DIR: /build/OpenRV/_build/stage/app/plugins/ConfigFiles
#28 0.681 -- RV_STAGE_PLUGINS_IMAGEFORMATS_DIR: /build/OpenRV/_build/stage/app/plugins/ImageFormats
#28 0.682 -- RV_STAGE_PLUGINS_MOVIEFORMATS_DIR: /build/OpenRV/_build/stage/app/plugins/MovieFormats
#28 0.682 -- RV_STAGE_PLUGINS_MU_DIR: /build/OpenRV/_build/stage/app/plugins/Mu
#28 0.682 -- RV_STAGE_PLUGINS_NODES_DIR: /build/OpenRV/_build/stage/app/plugins/Nodes
#28 0.682 -- RV_STAGE_PLUGINS_OIIO_DIR: /build/OpenRV/_build/stage/app/plugins/OIIO
#28 0.682 -- RV_STAGE_PLUGINS_OUTPUT_DIR: /build/OpenRV/_build/stage/app/plugins/Output
#28 0.682 -- RV_STAGE_PLUGINS_MEDIALIBRARY_DIR: /build/OpenRV/_build/stage/app/plugins/MediaLibrary/
#28 0.682 -- RV_STAGE_PLUGINS_PACKAGES_DIR: /build/OpenRV/_build/stage/app/plugins/Packages
#28 0.682 -- RV_STAGE_PLUGINS_PROFILES_DIR: /build/OpenRV/_build/stage/app/plugins/Profiles
#28 0.682 -- RV_STAGE_PLUGINS_PYTHON_DIR: /build/OpenRV/_build/stage/app/plugins/Python
#28 0.682 -- RV_STAGE_PLUGINS_QT_DIR: /build/OpenRV/_build/stage/app/plugins/Qt
#28 0.682 -- RV_STAGE_PLUGINS_SUPPORTFILES_DIR: /build/OpenRV/_build/stage/app/plugins/SupportFiles
#28 0.699 -- Updating submodules
#28 0.734 CMake Error at /usr/lib64/cmake/Qt5/Qt5Config.cmake:28 (find_package):
#28 0.734   Could not find a package configuration file provided by "Qt5WebEngineCore"
#28 0.734   with any of the following names:
#28 0.734 
#28 0.734     Qt5WebEngineCoreConfig.cmake
#28 0.734     qt5webenginecore-config.cmake
#28 0.734 
#28 0.734   Add the installation prefix of "Qt5WebEngineCore" to CMAKE_PREFIX_PATH or
#28 0.734   set "Qt5WebEngineCore_DIR" to a directory containing one of the above
#28 0.734   files.  If "Qt5WebEngineCore" provides a separate development package or
#28 0.734   SDK, be sure it has been installed.
#28 0.734 Call Stack (most recent call first):
#28 0.734   cmake/dependencies/qt5.cmake:50 (FIND_PACKAGE)
#28 0.734   cmake/dependencies/CMakeLists.txt:51 (INCLUDE)
#28 0.734 
#28 0.734 
#28 0.734 -- Configuring incomplete, errors occurred!
#28 ERROR: process "/bin/bash -c cmake     -B ${OPENRV_BUILD_DIR}/_build     -G Ninja     -DCMAKE_BUILD_TYPE=Release     -DRV_DEPS_QT5_LOCATION=$QT_HOME     -DRV_VFX_PLATFORM=$RV_VFX_PLATFORM     -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE=\"$FFMPEG_NON_FREE_DECODERS_TO_ENABLE\"     -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE=\"$FFMPEG_NON_FREE_ENCODERS_TO_ENABLE\"" did not complete successfully: exit code: 1
------
 > [25/35] RUN cmake     -B /build/OpenRV/_build     -G Ninja     -DCMAKE_BUILD_TYPE=Release     -DRV_DEPS_QT5_LOCATION=/opt/Qt//gcc_64     -DRV_VFX_PLATFORM=CY2023     -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac;hevc"     -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac":
0.734   Add the installation prefix of "Qt5WebEngineCore" to CMAKE_PREFIX_PATH or
0.734   set "Qt5WebEngineCore_DIR" to a directory containing one of the above
0.734   files.  If "Qt5WebEngineCore" provides a separate development package or
0.734   SDK, be sure it has been installed.
0.734 Call Stack (most recent call first):
0.734   cmake/dependencies/qt5.cmake:50 (FIND_PACKAGE)
0.734   cmake/dependencies/CMakeLists.txt:51 (INCLUDE)
0.734 
0.734 
0.734 -- Configuring incomplete, errors occurred!
------

 1 warning found (use docker --debug to expand):
 - SecretsUsedInArgOrEnv: Do not use ARG or ENV instructions for sensitive data (ARG "QT_PASSWORD") (line 15)
Dockerfile:197
--------------------
 196 |     ENV RV_VFX_PLATFORM="CY2023"
 197 | >>> RUN cmake \
 198 | >>>     -B ${OPENRV_BUILD_DIR}/_build \
 199 | >>>     -G Ninja \
 200 | >>>     -DCMAKE_BUILD_TYPE=Release \
 201 | >>>     -DRV_DEPS_QT5_LOCATION=$QT_HOME \
 202 | >>>     -DRV_VFX_PLATFORM=$RV_VFX_PLATFORM \
 203 | >>>     -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="$FFMPEG_NON_FREE_DECODERS_TO_ENABLE" \
 204 | >>>     -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="$FFMPEG_NON_FREE_ENCODERS_TO_ENABLE"
 205 |     
--------------------
ERROR: failed to solve: process "/bin/bash -c cmake     -B ${OPENRV_BUILD_DIR}/_build     -G Ninja     -DCMAKE_BUILD_TYPE=Release     -DRV_DEPS_QT5_LOCATION=$QT_HOME     -DRV_VFX_PLATFORM=$RV_VFX_PLATFORM     -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE=\"$FFMPEG_NON_FREE_DECODERS_TO_ENABLE\"     -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE=\"$FFMPEG_NON_FREE_ENCODERS_TO_ENABLE\"" did not complete successfully: exit code: 1
Command exited with non-zero status 1
Commandline Args: docker build --file ./Dockerfile --progress plain --build-arg QT_EMAIL=michimussato@gmail.com --build-arg QT_PASSWORD=QqAnjCCV8wrZV --build-arg CMAKE_VERSION=3.30.3 --build-arg RV_INST=/opt/OpenRV --build-arg QT_INSTALLER_VERSION=4.6.1 --build-arg QT_ROOT=/opt/Qt --build-arg FFMPEG_NON_FREE_DECODERS_TO_ENABLE=aac;hevc --build-arg FFMPEG_NON_FREE_ENCODERS_TO_ENABLE=aac --tag openstudiolandscapes/openrv_rocky9:latest .
Elapsed Time: 34:32.45
Peak Memory: 60372
Exit Code: 1
[user@localhost docker]$ ```