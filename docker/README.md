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
source ../.env  # if there is one, otherwise fill in the args manually
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
