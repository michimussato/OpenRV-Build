<!-- TOC -->
* [OpenRV-Rocky9-Docker](#openrv-rocky9-docker)
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

## 3. Build image from this Dockerfile
Build the image from the OpenRV-Rocky9-Docker directory. Replace your_qt_username and your_qt_password with your actual Qt login credentials. If you don't have an account, you can get a free account [here](https://login.qt.io/register).

```shell
source ../.env  # if there is one, otherwise fill in the args manually
time docker build \
    --file ./Dockerfile \
    --progress plain \
    --build-arg QT_EMAIL=${QT_EMAIL} \
    --build-arg QT_PASSWORD=${QT_PASSWORD} \
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


```
#32 1362.5       |              ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1362.5   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1362.5       |         ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1362.5   290 |     QLocale::Twi,
#32 1362.5       |              ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1362.5   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1362.5       |         ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1362.5   334 |     QLocale::SerboCroatian,
#32 1362.5       |              ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1362.5   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1362.5       |         ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1362.5   334 |     QLocale::SerboCroatian,
#32 1362.5       |              ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1362.5   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1362.5       |         ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1362.5   340 |     QLocale::Moldavian,
#32 1362.5       |              ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1362.5   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1362.5       |         ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1362.5   340 |     QLocale::Moldavian,
#32 1362.5       |              ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/merge.cpp:26:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1362.5   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1362.5       |         ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1362.5   215 |     QLocale::Bihari,
#32 1362.5       |              ^~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1362.5    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1362.5       |         ^~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1362.5   215 |     QLocale::Bihari,
#32 1362.5       |              ^~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1362.5    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1362.5       |         ^~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1362.5   262 |     QLocale::Norwegian,
#32 1362.5       |              ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1362.5   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1362.5       |         ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1362.5   262 |     QLocale::Norwegian,
#32 1362.5       |              ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1362.5   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1362.5       |         ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1362.5   281 |     QLocale::Tagalog,
#32 1362.5       |              ^~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1362.5   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1362.5       |         ^~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1362.5   281 |     QLocale::Tagalog,
#32 1362.5       |              ^~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1362.5   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1362.5       |         ^~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1362.5   290 |     QLocale::Twi,
#32 1362.5       |              ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1362.5   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1362.5       |         ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1362.5   290 |     QLocale::Twi,
#32 1362.5       |              ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1362.5   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1362.5       |         ^~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1362.5   334 |     QLocale::SerboCroatian,
#32 1362.5       |              ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1362.5   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1362.5       |         ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1362.5   334 |     QLocale::SerboCroatian,
#32 1362.5       |              ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1362.5   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1362.5       |         ^~~~~~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1362.5   340 |     QLocale::Moldavian,
#32 1362.5       |              ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1362.5   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1362.5       |         ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1362.5   340 |     QLocale::Moldavian,
#32 1362.5       |              ^~~~~~~~~
#32 1362.5 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.5                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/numberh.cpp:25:
#32 1362.5 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1362.5   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1362.5       |         ^~~~~~~~~
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp: In function ‘QMap<QString, QString> proFileTagMap(const QString&)’:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:122:51: warning: ‘QString::SkipEmptyParts’ is deprecated [-Wdeprecated-declarations]
#32 1362.6   122 |         QStringList lines = t.split(';', QString::SkipEmptyParts);
#32 1362.6       |                                                   ^~~~~~~~~~~~~~
#32 1362.6 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qhashfunctions.h:44,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qlist.h:47,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qmap.h:44,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.h:29,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:25:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:605:9: note: declared here
#32 1362.6   605 |         SkipEmptyParts Q_DECL_ENUMERATOR_DEPRECATED
#32 1362.6       |         ^~~~~~~~~~~~~~
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:122:51: warning: ‘QString::SkipEmptyParts’ is deprecated [-Wdeprecated-declarations]
#32 1362.6   122 |         QStringList lines = t.split(';', QString::SkipEmptyParts);
#32 1362.6       |                                                   ^~~~~~~~~~~~~~
#32 1362.6 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qhashfunctions.h:44,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qlist.h:47,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qmap.h:44,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.h:29,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:25:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:605:9: note: declared here
#32 1362.6   605 |         SkipEmptyParts Q_DECL_ENUMERATOR_DEPRECATED
#32 1362.6       |         ^~~~~~~~~~~~~~
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:122:36: warning: ‘QStringList QString::split(QChar, QString::SplitBehavior, Qt::CaseSensitivity) const’ is deprecated: Use Qt::SplitBehavior variant instead [-Wdeprecated-declarations]
#32 1362.6   122 |         QStringList lines = t.split(';', QString::SkipEmptyParts);
#32 1362.6       |                             ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#32 1362.6 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qhashfunctions.h:44,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qlist.h:47,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qmap.h:44,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.h:29,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:25:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:615:17: note: declared here
#32 1362.6   615 |     QStringList split(QChar sep, SplitBehavior behavior,
#32 1362.6       |                 ^~~~~
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:125:60: warning: ‘QString::SkipEmptyParts’ is deprecated [-Wdeprecated-declarations]
#32 1362.6   125 |             QStringList toks = (*line).split(' ', QString::SkipEmptyParts);
#32 1362.6       |                                                            ^~~~~~~~~~~~~~
#32 1362.6 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qhashfunctions.h:44,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qlist.h:47,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qmap.h:44,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.h:29,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:25:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:605:9: note: declared here
#32 1362.6   605 |         SkipEmptyParts Q_DECL_ENUMERATOR_DEPRECATED
#32 1362.6       |         ^~~~~~~~~~~~~~
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:125:60: warning: ‘QString::SkipEmptyParts’ is deprecated [-Wdeprecated-declarations]
#32 1362.6   125 |             QStringList toks = (*line).split(' ', QString::SkipEmptyParts);
#32 1362.6       |                                                            ^~~~~~~~~~~~~~
#32 1362.6 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qhashfunctions.h:44,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qlist.h:47,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qmap.h:44,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.h:29,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:25:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:605:9: note: declared here
#32 1362.6   605 |         SkipEmptyParts Q_DECL_ENUMERATOR_DEPRECATED
#32 1362.6       |         ^~~~~~~~~~~~~~
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:125:45: warning: ‘QStringList QString::split(QChar, QString::SplitBehavior, Qt::CaseSensitivity) const’ is deprecated: Use Qt::SplitBehavior variant instead [-Wdeprecated-declarations]
#32 1362.6   125 |             QStringList toks = (*line).split(' ', QString::SkipEmptyParts);
#32 1362.6       |                                ~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#32 1362.6 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qhashfunctions.h:44,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qlist.h:47,
#32 1362.6                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qmap.h:44,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.h:29,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/proparser.cpp:25:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:615:17: note: declared here
#32 1362.6   615 |     QStringList split(QChar sep, SplitBehavior behavior,
#32 1362.6       |                 ^~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1362.6   215 |     QLocale::Bihari,
#32 1362.6       |              ^~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1362.6    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1362.6       |         ^~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1362.6   215 |     QLocale::Bihari,
#32 1362.6       |              ^~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1362.6    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1362.6       |         ^~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1362.6   262 |     QLocale::Norwegian,
#32 1362.6       |              ^~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1362.6   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1362.6       |         ^~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1362.6   262 |     QLocale::Norwegian,
#32 1362.6       |              ^~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1362.6   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1362.6       |         ^~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1362.6   281 |     QLocale::Tagalog,
#32 1362.6       |              ^~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1362.6   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1362.6       |         ^~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1362.6   281 |     QLocale::Tagalog,
#32 1362.6       |              ^~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1362.6   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1362.6       |         ^~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1362.6   290 |     QLocale::Twi,
#32 1362.6       |              ^~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1362.6   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1362.6       |         ^~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1362.6   290 |     QLocale::Twi,
#32 1362.6       |              ^~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1362.6   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1362.6       |         ^~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1362.6   334 |     QLocale::SerboCroatian,
#32 1362.6       |              ^~~~~~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1362.6   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1362.6       |         ^~~~~~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1362.6   334 |     QLocale::SerboCroatian,
#32 1362.6       |              ^~~~~~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1362.6   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1362.6       |         ^~~~~~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1362.6   340 |     QLocale::Moldavian,
#32 1362.6       |              ^~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1362.6   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1362.6       |         ^~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1362.6   340 |     QLocale::Moldavian,
#32 1362.6       |              ^~~~~~~~~
#32 1362.6 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.h:31,
#32 1362.6                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:26:
#32 1362.6 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1362.6   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1362.6       |         ^~~~~~~~~
#32 1362.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:64:66: warning: ‘QXmlParseException’ is deprecated [-Wdeprecated-declarations]
#32 1362.8    64 |     virtual bool fatalError( const QXmlParseException& exception );
#32 1362.8       |                                                                  ^
#32 1362.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:201:65: warning: ‘QXmlParseException’ is deprecated [-Wdeprecated-declarations]
#32 1362.8   201 | bool TsHandler::fatalError( const QXmlParseException& exception )
#32 1362.8       |                                                                 ^
#32 1362.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp: In member function ‘bool MetaTranslator::load(const QString&)’:
#32 1362.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:379:23: warning: ‘QXmlInputSource’ is deprecated [-Wdeprecated-declarations]
#32 1362.8   379 |     QXmlInputSource in( &f );
#32 1362.8       |                       ^
#32 1362.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:34:
#32 1362.8 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:197:49: note: declared here
#32 1362.8   197 | class QT_DEPRECATED_VERSION(5, 15) Q_XML_EXPORT QXmlInputSource
#32 1362.8       |                                                 ^~~~~~~~~~~~~~~
#32 1362.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:380:22: warning: ‘QXmlSimpleReader’ is deprecated: Use QXmlStreamReader [-Wdeprecated-declarations]
#32 1362.8   380 |     QXmlSimpleReader reader;
#32 1362.8       |                      ^~~~~~
#32 1362.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:34:
#32 1362.8 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:275:75: note: declared here
#32 1362.8   275 | class QT_DEPRECATED_VERSION_X(5, 15, "Use QXmlStreamReader") Q_XML_EXPORT QXmlSimpleReader
#32 1362.8       |                                                                           ^~~~~~~~~~~~~~~~
#32 1362.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:384:61: warning: ‘QXmlDefaultHandler’ is deprecated [-Wdeprecated-declarations]
#32 1362.8   384 |     reader.setContentHandler( static_cast<QXmlDefaultHandler*>(hand) );
#32 1362.8       |                                                             ^
#32 1362.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:34:
#32 1362.8 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:407:49: note: declared here
#32 1362.8   407 | class QT_DEPRECATED_VERSION(5, 15) Q_XML_EXPORT QXmlDefaultHandler : public QXmlContentHandler,
#32 1362.8       |                                                 ^~~~~~~~~~~~~~~~~~
#32 1362.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:385:59: warning: ‘QXmlDefaultHandler’ is deprecated [-Wdeprecated-declarations]
#32 1362.8   385 |     reader.setErrorHandler( static_cast<QXmlDefaultHandler*>(hand) );
#32 1362.8       |                                                           ^
#32 1362.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/metatranslator.cpp:34:
#32 1362.8 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:407:49: note: declared here
#32 1362.8   407 | class QT_DEPRECATED_VERSION(5, 15) Q_XML_EXPORT QXmlDefaultHandler : public QXmlContentHandler,
#32 1362.8       |                                                 ^~~~~~~~~~~~~~~~~~
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:765:66: warning: ‘QXmlParseException’ is deprecated [-Wdeprecated-declarations]
#32 1363.4   765 |     virtual bool fatalError( const QXmlParseException& exception );
#32 1363.4       |                                                                  ^
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:767:57: warning: ‘QXmlLocator’ is deprecated [-Wdeprecated-declarations]
#32 1363.4   767 |     virtual void setDocumentLocator(QXmlLocator *locator)
#32 1363.4       |                                                         ^
#32 1363.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtXml/QtXml:6,
#32 1363.4                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:40:
#32 1363.4 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:321:49: note: declared here
#32 1363.4   321 | class QT_DEPRECATED_VERSION(5, 15) Q_XML_EXPORT QXmlLocator
#32 1363.4       |                                                 ^~~~~~~~~~~
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:771:18: warning: ‘QXmlLocator’ is deprecated [-Wdeprecated-declarations]
#32 1363.4   771 |     QXmlLocator *m_locator;
#32 1363.4       |                  ^~~~~~~~~
#32 1363.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtXml/QtXml:6,
#32 1363.4                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:40:
#32 1363.4 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:321:49: note: declared here
#32 1363.4   321 | class QT_DEPRECATED_VERSION(5, 15) Q_XML_EXPORT QXmlLocator
#32 1363.4       |                                                 ^~~~~~~~~~~
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:836:65: warning: ‘QXmlParseException’ is deprecated [-Wdeprecated-declarations]
#32 1363.4   836 | bool UiHandler::fatalError( const QXmlParseException& exception )
#32 1363.4       |                                                                 ^
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp: In function ‘void fetchtr_ui(const char*, MetaTranslator*, const char*, bool)’:
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:873:23: warning: ‘QXmlInputSource’ is deprecated [-Wdeprecated-declarations]
#32 1363.4   873 |     QXmlInputSource in( &f );
#32 1363.4       |                       ^
#32 1363.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtXml/QtXml:6,
#32 1363.4                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:40:
#32 1363.4 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:197:49: note: declared here
#32 1363.4   197 | class QT_DEPRECATED_VERSION(5, 15) Q_XML_EXPORT QXmlInputSource
#32 1363.4       |                                                 ^~~~~~~~~~~~~~~
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:874:22: warning: ‘QXmlSimpleReader’ is deprecated: Use QXmlStreamReader [-Wdeprecated-declarations]
#32 1363.4   874 |     QXmlSimpleReader reader;
#32 1363.4       |                      ^~~~~~
#32 1363.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtXml/QtXml:6,
#32 1363.4                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:40:
#32 1363.4 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:275:75: note: declared here
#32 1363.4   275 | class QT_DEPRECATED_VERSION_X(5, 15, "Use QXmlStreamReader") Q_XML_EXPORT QXmlSimpleReader
#32 1363.4       |                                                                           ^~~~~~~~~~~~~~~~
#32 1363.4 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:879:25: warning: ‘QXmlDefaultHandler’ is deprecated [-Wdeprecated-declarations]
#32 1363.4   879 |     QXmlDefaultHandler *hand = new UiHandler( tor, fileName );
#32 1363.4       |                         ^~~~
#32 1363.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtXml/QtXml:6,
#32 1363.4                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/fetchtr.cpp:40:
#32 1363.4 /root/Qt/5.15.2/gcc_64/include/QtXml/qxml.h:407:49: note: declared here
#32 1363.4   407 | class QT_DEPRECATED_VERSION(5, 15) Q_XML_EXPORT QXmlDefaultHandler : public QXmlContentHandler,
#32 1363.4       |                                                 ^~~~~~~~~~~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1363.7   215 |     QLocale::Bihari,
#32 1363.7       |              ^~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1363.7    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1363.7       |         ^~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1363.7   215 |     QLocale::Bihari,
#32 1363.7       |              ^~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1363.7    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1363.7       |         ^~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1363.7   262 |     QLocale::Norwegian,
#32 1363.7       |              ^~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1363.7   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1363.7       |         ^~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1363.7   262 |     QLocale::Norwegian,
#32 1363.7       |              ^~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1363.7   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1363.7       |         ^~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1363.7   281 |     QLocale::Tagalog,
#32 1363.7       |              ^~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1363.7   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1363.7       |         ^~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1363.7   281 |     QLocale::Tagalog,
#32 1363.7       |              ^~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1363.7   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1363.7       |         ^~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1363.7   290 |     QLocale::Twi,
#32 1363.7       |              ^~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1363.7   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1363.7       |         ^~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1363.7   290 |     QLocale::Twi,
#32 1363.7       |              ^~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1363.7   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1363.7       |         ^~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1363.7   334 |     QLocale::SerboCroatian,
#32 1363.7       |              ^~~~~~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1363.7   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1363.7       |         ^~~~~~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1363.7   334 |     QLocale::SerboCroatian,
#32 1363.7       |              ^~~~~~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1363.7   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1363.7       |         ^~~~~~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1363.7   340 |     QLocale::Moldavian,
#32 1363.7       |              ^~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1363.7   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1363.7       |         ^~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1363.7   340 |     QLocale::Moldavian,
#32 1363.7       |              ^~~~~~~~~
#32 1363.7 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.7                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/sources/pyside2-tools/pylupdate/translator.cpp:26:
#32 1363.7 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1363.7   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1363.7       |         ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1363.8   215 |     QLocale::Bihari,
#32 1363.8       |              ^~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1363.8    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1363.8       |         ^~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:215:14: warning: ‘QLocale::Bihari’ is deprecated: No locale data for this language [-Wdeprecated-declarations]
#32 1363.8   215 |     QLocale::Bihari,
#32 1363.8       |              ^~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:97:9: note: declared here
#32 1363.8    97 |         Bihari Q_DECL_ENUMERATOR_DEPRECATED_X("No locale data for this language") = 17,
#32 1363.8       |         ^~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1363.8   262 |     QLocale::Norwegian,
#32 1363.8       |              ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1363.8   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1363.8       |         ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:262:14: warning: ‘QLocale::Norwegian’ is deprecated: Obsolete name, use NorwegianBokmal [-Wdeprecated-declarations]
#32 1363.8   262 |     QLocale::Norwegian,
#32 1363.8       |              ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:506:9: note: declared here
#32 1363.8   506 |         Norwegian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use NorwegianBokmal") = NorwegianBokmal,
#32 1363.8       |         ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1363.8   281 |     QLocale::Tagalog,
#32 1363.8       |              ^~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1363.8   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1363.8       |         ^~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:281:14: warning: ‘QLocale::Tagalog’ is deprecated: Obsolete name, use Filipino [-Wdeprecated-declarations]
#32 1363.8   281 |     QLocale::Tagalog,
#32 1363.8       |              ^~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:511:9: note: declared here
#32 1363.8   511 |         Tagalog Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Filipino") = Filipino,
#32 1363.8       |         ^~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1363.8   290 |     QLocale::Twi,
#32 1363.8       |              ^~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1363.8   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1363.8       |         ^~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:290:14: warning: ‘QLocale::Twi’ is deprecated: Obsolete name, use Akan [-Wdeprecated-declarations]
#32 1363.8   290 |     QLocale::Twi,
#32 1363.8       |              ^~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:512:9: note: declared here
#32 1363.8   512 |         Twi Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Akan") = Akan,
#32 1363.8       |         ^~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1363.8   334 |     QLocale::SerboCroatian,
#32 1363.8       |              ^~~~~~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1363.8   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1363.8       |         ^~~~~~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:334:14: warning: ‘QLocale::SerboCroatian’ is deprecated: Obsolete name, use Serbian [-Wdeprecated-declarations]
#32 1363.8   334 |     QLocale::SerboCroatian,
#32 1363.8       |              ^~~~~~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:510:9: note: declared here
#32 1363.8   510 |         SerboCroatian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Serbian") = Serbian,
#32 1363.8       |         ^~~~~~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1363.8   340 |     QLocale::Moldavian,
#32 1363.8       |              ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1363.8   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1363.8       |         ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:340:14: warning: ‘QLocale::Moldavian’ is deprecated: Obsolete name, use Romanian [-Wdeprecated-declarations]
#32 1363.8   340 |     QLocale::Moldavian,
#32 1363.8       |              ^~~~~~~~~
#32 1363.8 In file included from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/../../../../sources/pyside2-tools/pylupdate/translator.h:32,
#32 1363.8                  from /OpenRV/_build/_deps/rv_deps_pyside2-src/pyside3_build/py3.10-qt5.15.2-64bit-release/pyside2-tools/pylupdate/moc_translator.cpp:10:
#32 1363.8 /root/Qt/5.15.2/gcc_64/include/QtCore/qlocale.h:505:9: note: declared here
#32 1363.8   505 |         Moldavian Q_DECL_ENUMERATOR_DEPRECATED_X("Obsolete name, use Romanian") = Romanian,
#32 1363.8       |         ^~~~~~~~~
#32 1367.3 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager, possibly rendering your system unusable. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv. Use the --root-user-action option if you know what you are doing and want to suppress this warning.
#32 1367.7 Cloning into 'imgui-bundle'...
#32 1378.2 HEAD is now at 76cbc649 v1.6.3
#32 1378.6 Cloning into 'imgui-bundle-pyimplot'...
#32 1389.5 HEAD is now at 76cbc649 v1.6.3
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp: In function 'const float& Imf_3_1::dwaCompressionLevel(const Imf_3_1::Header&)':
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:55:41: warning: 'const Imf_3_1::TypedAttribute<float>& Imf_3_1::dwaCompressionLevelAttribute(const Imf_3_1::Header&)' is deprecated: use compression method in ImfHeader [-Wdeprecated-declarations]
#32 1479.5    55 |         return IMF_NAME_ATTRIBUTE(name) (header).value();           \
#32 1479.5       |                                         ^
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:99:1: note: in expansion of macro 'IMF_STD_ATTRIBUTE_IMP'
#32 1479.5    99 | IMF_STD_ATTRIBUTE_IMP (dwaCompressionLevel, DwaCompressionLevel, float)
#32 1479.5       | ^~~~~~~~~~~~~~~~~~~~~
#32 1479.5 In file included from /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:12:
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:99:24: note: declared here
#32 1479.5    99 | IMF_STD_ATTRIBUTE_IMP (dwaCompressionLevel, DwaCompressionLevel, float)
#32 1479.5       |                        ^~~~~~~~~~~~~~~~~~~
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.h:46:34: note: in definition of macro 'IMF_NAME_ATTRIBUTE'
#32 1479.5    46 | #define IMF_NAME_ATTRIBUTE(name) name##Attribute
#32 1479.5       |                                  ^~~~
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:99:1: note: in expansion of macro 'IMF_STD_ATTRIBUTE_IMP'
#32 1479.5    99 | IMF_STD_ATTRIBUTE_IMP (dwaCompressionLevel, DwaCompressionLevel, float)
#32 1479.5       | ^~~~~~~~~~~~~~~~~~~~~
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp: In function 'float& Imf_3_1::dwaCompressionLevel(Imf_3_1::Header&)':
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:61:41: warning: 'Imf_3_1::TypedAttribute<float>& Imf_3_1::dwaCompressionLevelAttribute(Imf_3_1::Header&)' is deprecated: use compression method in ImfHeader [-Wdeprecated-declarations]
#32 1479.5    61 |         return IMF_NAME_ATTRIBUTE(name) (header).value();           \
#32 1479.5       |                                         ^
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:99:1: note: in expansion of macro 'IMF_STD_ATTRIBUTE_IMP'
#32 1479.5    99 | IMF_STD_ATTRIBUTE_IMP (dwaCompressionLevel, DwaCompressionLevel, float)
#32 1479.5       | ^~~~~~~~~~~~~~~~~~~~~
#32 1479.5 In file included from /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:12:
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:99:24: note: declared here
#32 1479.5    99 | IMF_STD_ATTRIBUTE_IMP (dwaCompressionLevel, DwaCompressionLevel, float)
#32 1479.5       |                        ^~~~~~~~~~~~~~~~~~~
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.h:46:34: note: in definition of macro 'IMF_NAME_ATTRIBUTE'
#32 1479.5    46 | #define IMF_NAME_ATTRIBUTE(name) name##Attribute
#32 1479.5       |                                  ^~~~
#32 1479.5 /OpenRV/_build/RV_DEPS_OPENEXR/src/src/lib/OpenEXR/ImfStandardAttributes.cpp:99:1: note: in expansion of macro 'IMF_STD_ATTRIBUTE_IMP'
#32 1479.5    99 | IMF_STD_ATTRIBUTE_IMP (dwaCompressionLevel, DwaCompressionLevel, float)
#32 1479.5       | ^~~~~~~~~~~~~~~~~~~~~
#32 1486.6 Cloning into 'expat_install'...
#32 1486.6 Cloning into 'pystring_install'...
#32 1486.6 Cloning into 'minizip-ng_install'...
#32 1486.6 Cloning into 'pybind11_install'...
#32 1486.6 Cloning into 'yaml-cpp_install'...
#32 1487.1 HEAD is now at c2de99d fix replace on empty strings
#32 1487.1 CMake Warning (dev) at CMakeLists.txt:4 (project):
#32 1487.1   cmake_minimum_required() should be called prior to this top-level project()
#32 1487.1   call.  Please see the cmake-commands(7) manual for usage documentation of
#32 1487.1   both commands.
#32 1487.1 This warning is for project developers.  Use -Wno-dev to suppress it.
#32 1487.1 
#32 1487.4 gmake[3]: warning: -j0 forced in submake: resetting jobserver mode.
#32 1487.7 HEAD is now at 0579ae3 Update version to 0.7.0.
#32 1487.8 CMake Deprecation Warning at CMakeLists.txt:2 (cmake_minimum_required):
#32 1487.8   Compatibility with CMake < 3.5 will be removed from a future version of
#32 1487.8   CMake.
#32 1487.8 
#32 1487.8   Update the VERSION argument <min> value or use a ...<max> suffix to tell
#32 1487.8   CMake that the project does not need compatibility with older versions.
#32 1487.8 
#32 1487.8 
#32 1488.0 CMake Warning:
#32 1488.0   Manually-specified variables were not used by the project:
#32 1488.0 
#32 1488.0     CMAKE_POLICY_DEFAULT_CMP0063
#32 1488.0 
#32 1488.0 
#32 1488.0 gmake[3]: warning: -j0 forced in submake: resetting jobserver mode.
#32 1488.8 HEAD is now at 2414288 Version 3.0.7.
#32 1489.5 HEAD is now at 914c06f chore: set to version 2.9.2
#32 1489.9 CMake Deprecation Warning at CMakeLists.txt:8 (cmake_minimum_required):
#32 1489.9   Compatibility with CMake < 3.5 will be removed from a future version of
#32 1489.9   CMake.
#32 1489.9 
#32 1489.9   Update the VERSION argument <min> value or use a ...<max> suffix to tell
#32 1489.9   CMake that the project does not need compatibility with older versions.
#32 1489.9 
#32 1489.9 
#32 1490.7 CMake Warning (dev) at tools/FindPythonLibsNew.cmake:98 (find_package):
#32 1490.7   Policy CMP0148 is not set: The FindPythonInterp and FindPythonLibs modules
#32 1490.7   are removed.  Run "cmake --help-policy CMP0148" for policy details.  Use
#32 1490.7   the cmake_policy command to set the policy and suppress this warning.
#32 1490.7 
#32 1490.7 Call Stack (most recent call first):
#32 1490.7   tools/pybind11Tools.cmake:50 (find_package)
#32 1490.7   tools/pybind11Common.cmake:206 (include)
#32 1490.7   CMakeLists.txt:200 (include)
#32 1490.7 This warning is for project developers.  Use -Wno-dev to suppress it.
#32 1490.7 
#32 1490.8 gmake[3]: warning: -j0 forced in submake: resetting jobserver mode.
#32 1491.7 gmake[3]: warning: -j0 forced in submake: resetting jobserver mode.
#32 1492.5 HEAD is now at a28238b Merge pull request #492 from libexpat/issue-491-prepare-release-2-4-1
#32 1492.6 CMake Deprecation Warning at CMakeLists.txt:35 (cmake_minimum_required):
#32 1492.6   Compatibility with CMake < 3.5 will be removed from a future version of
#32 1492.6   CMake.
#32 1492.6 
#32 1492.6   Update the VERSION argument <min> value or use a ...<max> suffix to tell
#32 1492.6   CMake that the project does not need compatibility with older versions.
#32 1492.6 
#32 1492.6 
#32 1493.7 gmake[3]: warning: -j0 forced in submake: resetting jobserver mode.
#32 1838.9 Cloning into 'mbedtls'...
#32 1876.1 Switched to a new branch 'fix-win-dll-cmake'
#32 1876.2 Submodule 'framework' (https://github.com/Mbed-TLS/mbedtls-framework) registered for path 'framework'
#32 1876.3 Cloning into '/OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-prefix/src/mbedtls/framework'...
#32 1919.1 In file included from /OpenRV/_build/RV_DEPS_AJA/src/ajaanc/src/ancillarylist.cpp:8:
#32 1919.1 /OpenRV/_build/RV_DEPS_AJA/src/ajaanc/includes/ancillarylist.h: In member function 'virtual AJAStatus AJAAncillaryList::GetHDMITransmitData(NTV2Buffer&, NTV2Buffer&, bool, uint32_t)':
#32 1919.1 /OpenRV/_build/RV_DEPS_AJA/src/ajaanc/includes/ancillarylist.h:452:99: warning: unused parameter 'F1Buffer' [-Wunused-parameter]
#32 1919.1   452 |         virtual inline AJAStatus                                GetHDMITransmitData (NTV2Buffer & F1Buffer, NTV2Buffer & F2Buffer,
#32 1919.1       |                                                                                      ~~~~~~~~~~~~~^~~~~~~~
#32 1919.1 /OpenRV/_build/RV_DEPS_AJA/src/ajaanc/includes/ancillarylist.h:452:122: warning: unused parameter 'F2Buffer' [-Wunused-parameter]
#32 1919.1   452 |         virtual inline AJAStatus                                GetHDMITransmitData (NTV2Buffer & F1Buffer, NTV2Buffer & F2Buffer,
#32 1919.1       |                                                                                                             ~~~~~~~~~~~~~^~~~~~~~
#32 1919.1 /OpenRV/_build/RV_DEPS_AJA/src/ajaanc/includes/ancillarylist.h:453:140: warning: unused parameter 'inIsProgressive' [-Wunused-parameter]
#32 1919.1   453 |                                                                                                                                 const bool inIsProgressive = true, const uint32_t inF2StartLine = 0)
#32 1919.1       |                                                                                                                                 ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
#32 1919.1 /OpenRV/_build/RV_DEPS_AJA/src/ajaanc/includes/ancillarylist.h:453:179: warning: unused parameter 'inF2StartLine' [-Wunused-parameter]
#32 1919.1   453 |                                                                                                                                 const bool inIsProgressive = true, const uint32_t inF2StartLine = 0)
#32 1919.1       |                                                                                                                                                                    ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
#32 1929.1 /OpenRV/_build/RV_DEPS_AJA/src/ajabase/pnp/linux/pnpimpl.cpp:13:10: fatal error: libudev.h: No such file or directory
#32 1929.1    13 | #include <libudev.h>
#32 1929.1       |          ^~~~~~~~~~~
#32 1929.1 compilation terminated.
#32 1929.1 gmake[2]: *** [ajantv2/CMakeFiles/ajantv2.dir/build.make:818: ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/pnp/linux/pnpimpl.cpp.o] Error 1
#32 1929.1 gmake[2]: *** Waiting for unfinished jobs....
#32 1944.2 /OpenRV/_build/RV_DEPS_AJA/src/ajabase/persistence/sqlite3.c: In function 'sqlite3SelectNew':
#32 1944.2 /OpenRV/_build/RV_DEPS_AJA/src/ajabase/persistence/sqlite3.c:121480:10: warning: function may return address of local variable [-Wreturn-local-addr]
#32 1944.2 121480 |   return pNew;
#32 1944.2        |          ^~~~
#32 1944.2 /OpenRV/_build/RV_DEPS_AJA/src/ajabase/persistence/sqlite3.c:121442:10: note: declared here
#32 1944.2 121442 |   Select standin;
#32 1944.2        |          ^~~~~~~
#32 1968.4 gmake[1]: *** [CMakeFiles/Makefile2:180: ajantv2/CMakeFiles/ajantv2.dir/all] Error 2
#32 1968.4 gmake: *** [Makefile:136: all] Error 2
#32 1972.4 nel.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/include/OpenEXR/ImfUtilExport.h
#32 1972.4 -- Creating symlink /OpenRV/_build/RV_DEPS_OPENEXR/install/lib64/libOpenEXRUtil.so -> libOpenEXRUtil-3_1.so
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/drawImage.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/drawImage.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/generalInterfaceExamples.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/generalInterfaceExamples.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/generalInterfaceTiledExamples.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/generalInterfaceTiledExamples.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/lowLevelIoExamples.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/lowLevelIoExamples.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/main.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/namespaceAlias.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/previewImageExamples.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/previewImageExamples.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/rgbaInterfaceExamples.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/rgbaInterfaceExamples.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/rgbaInterfaceTiledExamples.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OPENEXR/install/share/doc/OpenEXR/examples/rgbaInterfaceTiledExamples.h
#32 1972.4 [767/2153] cd /OpenRV/_build/RV_DEPS_OIIO && /usr/local/bin/cmake -P /OpenRV/_build/cmake/dependencies/RV_DEPS_OIIO-prefix/src/RV_DEPS_OIIO-stamp/download-RV_DEPS_OIIO.cmake && /usr/local/bin/cmake -P /OpenRV/_build/cmake/dependencies/RV_DEPS_OIIO-prefix/src/RV_DEPS_OIIO-stamp/verify-RV_DEPS_OIIO.cmake && /usr/local/bin/cmake -P /OpenRV/_build/cmake/dependencies/RV_DEPS_OIIO-prefix/src/RV_DEPS_OIIO-stamp/extract-RV_DEPS_OIIO.cmake && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_OIIO-prefix/src/RV_DEPS_OIIO-stamp/RV_DEPS_OIIO-download
#32 1972.4 -- Downloading...
#32 1972.4    dst='/OpenRV/_build/RV_DEPS_DOWNLOAD/RV_DEPS_OIIO_2.4.6.0.tar.gz'
#32 1972.4    timeout='none'
#32 1972.4    inactivity timeout='none'
#32 1972.4 -- Using src='https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v2.4.6.0.tar.gz'
#32 1972.4 -- verifying file...
#32 1972.4        file='/OpenRV/_build/RV_DEPS_DOWNLOAD/RV_DEPS_OIIO_2.4.6.0.tar.gz'
#32 1972.4 -- Downloading... done
#32 1972.4 -- extracting...
#32 1972.4      src='/OpenRV/_build/RV_DEPS_DOWNLOAD/RV_DEPS_OIIO_2.4.6.0.tar.gz'
#32 1972.4      dst='/OpenRV/_build/RV_DEPS_OIIO/src'
#32 1972.4 -- extracting... [tar xfz]
#32 1972.4 -- extracting... [analysis]
#32 1972.4 -- extracting... [rename]
#32 1972.4 -- extracting... [clean up]
#32 1972.4 -- extracting... done
#32 1972.4 [770/2153] cd /OpenRV/_build/RV_DEPS_OIIO/build && /usr/local/bin/cmake -DCMAKE_INSTALL_PREFIX=/OpenRV/_build/RV_DEPS_OIIO/install -DCMAKE_OSX_ARCHITECTURES= -DCMAKE_BUILD_TYPE=Release "-S /OpenRV/_build/RV_DEPS_OIIO/src" "-B /OpenRV/_build/RV_DEPS_OIIO/build" -DBUILD_TESTING=OFF -DUSE_PYTHON=0 -DUSE_OCIO=0 -DUSE_FREETYPE=0 -DUSE_GIF=OFF -DBoost_ROOT=/OpenRV/_build/RV_DEPS_BOOST/install -DOpenEXR_ROOT=/OpenRV/_build/RV_DEPS_OPENEXR/install -DImath_LIBRARY=/OpenRV/_build/RV_DEPS_IMATH/install/lib64/libImath-3_1.so.29.5.0 -DImath_INCLUDE_DIR=/OpenRV/_build/RV_DEPS_IMATH/install/include/Imath/.. -DImath_DIR=/OpenRV/_build/RV_DEPS_IMATH/install/lib64/cmake/Imath -DPNG_LIBRARY=/OpenRV/_build/RV_DEPS_PNG/install/lib64/libpng16.so.16.48.0 -DPNG_PNG_INCLUDE_DIR=/OpenRV/_build/RV_DEPS_PNG/install/include -DJPEG_LIBRARY=/OpenRV/_build/RV_DEPS_JPEGTURBO/install/lib64/libjpeg.so.62.3.0 -DJPEG_INCLUDE_DIR=/OpenRV/_build/RV_DEPS_JPEGTURBO/install/include -DJPEGTURBO_LIBRARY=/OpenRV/_build/RV_DEPS_JPEGTURBO/install/lib64/libturbojpeg.so.0.2.0 -DJPEGTURBO_INCLUDE_DIR=/OpenRV/_build/RV_DEPS_JPEGTURBO/install/include -DOpenJPEG_ROOT=/OpenRV/_build/RV_DEPS_OPENJPEG/install -DOPENJPEG_OPENJP2_LIBRARY=/OpenRV/_build/RV_DEPS_OPENJPEG/install/lib/libopenjp2.so.2.5.0 -DOPENJPEG_INCLUDE_DIR=/OpenRV/_build/RV_DEPS_OPENJPEG/install/include/openjpeg-2.5 -DTIFF_ROOT=/OpenRV/_build/RV_DEPS_TIFF/install -DFFMPEG_INCLUDE_DIR=/OpenRV/_build/RV_DEPS_FFMPEG/install/include -DFFMPEG_INCLUDES=/OpenRV/_build/RV_DEPS_FFMPEG/install/include -DFFMPEG_AVCODEC_INCLUDE_DIR=/OpenRV/_build/RV_DEPS_FFMPEG/install/include "-DFFMPEG_LIBRARIES=/OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libavcodec.so.60 /OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libavformat.so.60 /OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libavutil.so.58 /OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libswscale.so.7" -DFFMPEG_LIBAVCODEC=/OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libavcodec.so.60 -DFFMPEG_LIBAVFORMAT=/OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libavformat.so.60 -DFFMPEG_LIBAVUTIL=/OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libavutil.so.58 -DFFMPEG_LIBSWSCALE=/OpenRV/_build/RV_DEPS_FFMPEG/install/lib/libswscale.so.7 -DLibRaw_ROOT=/OpenRV/_build/RV_DEPS_RAW/install -DZLIB_ROOT=/OpenRV/_build/RV_DEPS_ZLIB/install -DOIIO_BUILD_TOOLS=OFF -DOIIO_BUILD_TESTS=OFF && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_OIIO-prefix/src/RV_DEPS_OIIO-stamp/RV_DEPS_OIIO-configure
#32 1972.4 -- The CXX compiler identification is GNU 11.5.0
#32 1972.4 -- The C compiler identification is GNU 11.5.0
#32 1972.4 -- Detecting CXX compiler ABI info
#32 1972.4 -- Detecting CXX compiler ABI info - done
#32 1972.4 -- Check for working CXX compiler: /usr/bin/c++ - skipped
#32 1972.4 -- Detecting CXX compile features
#32 1972.4 -- Detecting CXX compile features - done
#32 1972.4 -- Detecting C compiler ABI info
#32 1972.4 -- Detecting C compiler ABI info - done
#32 1972.4 -- Check for working C compiler: /usr/bin/cc - skipped
#32 1972.4 -- Detecting C compile features
#32 1972.4 -- Detecting C compile features - done
#32 1972.4 -- Configuring OpenImageIO 2.4.6.0
#32 1972.4 -- CMake 3.27.9
#32 1972.4 -- CMake system           = Linux-6.12.28-1-MANJARO
#32 1972.4 -- CMake system name      = Linux
#32 1972.4 -- Project source dir     = /OpenRV/_build/RV_DEPS_OIIO/src
#32 1972.4 -- Project build dir      = /OpenRV/_build/RV_DEPS_OIIO/build
#32 1972.4 -- Project install prefix = /OpenRV/_build/RV_DEPS_OIIO/install
#32 1972.4 -- Configuration types    = 
#32 1972.4 -- Build type             = Release
#32 1972.4 -- Supported release      = ON
#32 1972.4 -- CMAKE_UNITY_BUILD_MODE = 
#32 1972.4 -- CMAKE_UNITY_BUILD_BATCH_SIZE = 
#32 1972.4 -- Setting Namespace to: OpenImageIO_v2_4
#32 1972.4 -- CMAKE_CXX_COMPILER     = /usr/bin/c++
#32 1972.4 -- CMAKE_CXX_COMPILER_ID  = GNU
#32 1972.4 -- Building with C++14, downstream minimum C++14
#32 1972.4 -- Using Boost::filesystem
#32 1972.4 -- clang-format not found.
#32 1972.4 -- 
#32 1972.4 -- * Checking for dependencies...
#32 1972.4 -- *   - Missing a dependency 'Package'?
#32 1972.4 -- *     Try cmake -DPackage_ROOT=path or set environment var Package_ROOT=path
#32 1972.4 -- *     For many dependencies, we supply src/build-scripts/build_Package.bash
#32 1972.4 -- *   - To exclude an optional dependency (even if found),
#32 1972.4 -- *     -DUSE_Package=OFF or set environment var USE_Package=OFF 
#32 1972.4 -- 
#32 1972.4 -- Boost_COMPONENTS = thread;filesystem
#32 1972.4 -- Found Boost 108000 
#32 1972.4 -- Found ZLIB 1.3.1 
#32 1972.4 -- Found TIFF 4.6.0 
#32 1972.4 -- Found OpenEXR 3.1.7 
#32 1972.4 CMake Warning (dev) at /usr/local/share/cmake-3.27/Modules/FindPackageHandleStandardArgs.cmake:438 (message):
#32 1972.4   The package name passed to `find_package_handle_standard_args` (JPEG) does
#32 1972.4   not match the name of the calling package (JPEGTurbo).  This can lead to
#32 1972.4   problems in calling code that expects `find_package` result variables
#32 1972.4   (e.g., `_FOUND`) to follow a certain pattern.
#32 1972.4 Call Stack (most recent call first):
#32 1972.4   src/cmake/modules/FindJPEGTurbo.cmake:42 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
#32 1972.4   src/cmake/checked_find_package.cmake:127 (find_package)
#32 1972.4   src/cmake/externalpackages.cmake:139 (checked_find_package)
#32 1972.4   CMakeLists.txt:155 (include)
#32 1972.4 This warning is for project developers.  Use -Wno-dev to suppress it.
#32 1972.4 
#32 1972.4 -- Found JPEG: /OpenRV/_build/RV_DEPS_JPEGTURBO/install/lib64/libjpeg.so.62.3.0  
#32 1972.4 -- Found JPEGTurbo  
#32 1972.4 -- Using internal PugiXML
#32 1972.4 -- Not using Python -- disabled  
#32 1972.4 -- Found PNG 1.6.48 
#32 1972.4 -- Found BZip2 1.0.8 
#32 1972.4 -- Not using Freetype -- disabled  
#32 1972.4 -- Could NOT find OpenColorIO (missing: OpenColorIO_DIR)
#32 1972.4 -- OpenColorIO library not found 
#32 1972.4 --     Try setting OpenColorIO_ROOT ? 
#32 1972.4 --     Maybe this will help:  src/build-scripts/build_opencolorio.bash 
#32 1972.4 -- Found OpenCV 4.6.0 
#32 1972.4 -- Could NOT find TBB (missing: TBB_DIR)
#32 1972.4 -- TBB library not found 
#32 1972.4 --     Try setting TBB_ROOT ? 
#32 1972.4 -- DCMTK library not found 
#32 1972.4 --     Try setting DCMTK_ROOT ? 
#32 1972.4 -- Found FFmpeg 5.1 
#32 1972.4 -- Not using GIF -- disabled  
#32 1972.4 -- Libheif library not found 
#32 1972.4 --     Try setting Libheif_ROOT ? 
#32 1972.4 -- Found LibRaw 0.21.1 
#32 1972.4 -- Found OpenJPEG 2.5 
#32 1972.4 CMake Warning (dev) at src/cmake/checked_find_package.cmake:105 (set):
#32 1972.4   Cannot set "ENABLE_OpenVDB": current scope has no parent.
#32 1972.4 Call Stack (most recent call first):
#32 1972.4   src/cmake/externalpackages.cmake:228 (checked_find_package)
#32 1972.4   CMakeLists.txt:155 (include)
#32 1972.4 This warning is for project developers.  Use -Wno-dev to suppress it.
#32 1972.4 
#32 1972.4 -- Not using OpenVDB -- disabled (because TBB was not found) 
#32 1972.4 -- Could NOT find Ptex (missing: Ptex_DIR)
#32 1972.4 -- Ptex library not found 
#32 1972.4 --     Try setting Ptex_ROOT ? 
#32 1972.4 --     Maybe this will help:  src/build-scripts/build_Ptex.bash 
#32 1972.4 -- Ptex library not found 
#32 1972.4 --     Try setting Ptex_ROOT ? 
#32 1972.4 --     Maybe this will help:  src/build-scripts/build_Ptex.bash 
#32 1972.4 -- WebP library not found 
#32 1972.4 --     Try setting WebP_ROOT ? 
#32 1972.4 --     Maybe this will help:  src/build-scripts/build_webp.bash 
#32 1972.4 -- Not using R3DSDK -- disabled  
#32 1972.4 -- Nuke library not found 
#32 1972.4 --     Try setting Nuke_ROOT ? 
#32 1972.4 -- Found OpenGL  
#32 1972.4 -- Found Qt5 5.15.9 
#32 1972.4 -- Downloading local fmtlib/fmt
#32 1972.4 -- Found Git: /usr/bin/git (found version "2.47.1") 
#32 1972.4 Cloning into '/OpenRV/_build/RV_DEPS_OIIO/src/ext/fmt'...
#32 1972.4 Note: switching to '8.0.0'.
#32 1972.4 
#32 1972.4 You are in 'detached HEAD' state. You can look around, make experimental
#32 1972.4 changes and commit them, and you can discard any commits you make in this
#32 1972.4 state without impacting any branches by switching back to a branch.
#32 1972.4 
#32 1972.4 If you want to create a new branch to retain commits you create, you may
#32 1972.4 do so (now or later) by using -c with the switch command. Example:
#32 1972.4 
#32 1972.4   git switch -c <new-branch-name>
#32 1972.4 
#32 1972.4 Or undo this operation with:
#32 1972.4 
#32 1972.4   git switch -
#32 1972.4 
#32 1972.4 Turn off this advice by setting config variable advice.detachedHead to false
#32 1972.4 
#32 1972.4 HEAD is now at 9e8b86fd Update version
#32 1972.4 -- DOWNLOADED fmtlib/fmt to /OpenRV/_build/RV_DEPS_OIIO/src/ext/fmt.
#32 1972.4 Remove that dir to get rid of it.
#32 1972.4 -- Found fmt 80000 
#32 1972.4 -- Downloading local Tessil/robin-map
#32 1972.4 Cloning into '/OpenRV/_build/RV_DEPS_OIIO/src/ext/robin-map'...
#32 1972.4 Note: switching to 'v0.6.2'.
#32 1972.4 
#32 1972.4 You are in 'detached HEAD' state. You can look around, make experimental
#32 1972.4 changes and commit them, and you can discard any commits you make in this
#32 1972.4 state without impacting any branches by switching back to a branch.
#32 1972.4 
#32 1972.4 If you want to create a new branch to retain commits you create, you may
#32 1972.4 do so (now or later) by using -c with the switch command. Example:
#32 1972.4 
#32 1972.4   git switch -c <new-branch-name>
#32 1972.4 
#32 1972.4 Or undo this operation with:
#32 1972.4 
#32 1972.4   git switch -
#32 1972.4 
#32 1972.4 Turn off this advice by setting config variable advice.detachedHead to false
#32 1972.4 
#32 1972.4 HEAD is now at 908ccf9 Bump version to 0.6.2
#32 1972.4 -- DOWNLOADED Tessil/robin-map to /OpenRV/_build/RV_DEPS_OIIO/src/ext/robin-map.
#32 1972.4 Remove that dir to get rid of it.
#32 1972.4 -- Found Robinmap  
#32 1972.4 CMake Warning at src/dicom.imageio/CMakeLists.txt:11 (message):
#32 1972.4   DICOM plugin will not be built, no DCMTK
#32 1972.4 
#32 1972.4 
#32 1972.4 CMake Warning at src/gif.imageio/CMakeLists.txt:11 (message):
#32 1972.4   GIF plugin will not be built
#32 1972.4 
#32 1972.4 
#32 1972.4 CMake Warning at src/heif.imageio/CMakeLists.txt:11 (message):
#32 1972.4   heif plugin will not be built
#32 1972.4 
#32 1972.4 
#32 1972.4 -- WebP plugin will not be built
#32 1972.4 -- Configuring done (8.7s)
#32 1972.4 -- Generating done (0.1s)
#32 1972.4 CMake Warning:
#32 1972.4   Manually-specified variables were not used by the project:
#32 1972.4 
#32 1972.4     Imath_INCLUDE_DIR
#32 1972.4     Imath_LIBRARY
#32 1972.4     JPEGTURBO_INCLUDE_DIR
#32 1972.4     JPEGTURBO_LIBRARY
#32 1972.4     USE_OCIO
#32 1972.4 
#32 1972.4 
#32 1972.4 -- Build files have been written to: /OpenRV/_build/RV_DEPS_OIIO/build
#32 1972.4 [771/2153] cd /OpenRV/_build/RV_DEPS_OIIO/build && /usr/local/bin/cmake --build /OpenRV/_build/RV_DEPS_OIIO/build --config Release -j8 && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_OIIO-prefix/src/RV_DEPS_OIIO-stamp/RV_DEPS_OIIO-build
#32 1972.4 [  0%] Generating testsuite/runtest.py
#32 1972.4 [  3%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/benchmark.cpp.o
#32 1972.4 [  4%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/fmath.cpp.o
#32 1972.4 [  3%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/argparse.cpp.o
#32 1972.4 [  4%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/filesystem.cpp.o
#32 1972.4 [  4%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/errorhandler.cpp.o
#32 1972.4 [  5%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/farmhash.cpp.o
#32 1972.4 [  6%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/filter.cpp.o
#32 1972.4 [  6%] Built target CopyFiles
#32 1972.4 [  7%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/hashes.cpp.o
#32 1972.4 [  8%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/paramlist.cpp.o
#32 1972.4 [  9%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/plugin.cpp.o
#32 1972.4 [ 10%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/SHA1.cpp.o
#32 1972.4 [ 11%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/strutil.cpp.o
#32 1972.4 [ 11%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/sysutil.cpp.o
#32 1972.4 [ 12%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/thread.cpp.o
#32 1972.4 [ 13%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/timer.cpp.o
#32 1972.4 [ 14%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/typedesc.cpp.o
#32 1972.4 [ 15%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/ustring.cpp.o
#32 1972.4 [ 16%] Building CXX object src/libutil/CMakeFiles/OpenImageIO_Util.dir/xxhash.cpp.o
#32 1972.4 [ 17%] Linking CXX shared library ../../lib/libOpenImageIO_Util.so
#32 1972.4 [ 17%] Built target OpenImageIO_Util
#32 1972.4 [ 21%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_channels.cpp.o
#32 1972.4 [ 21%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_pixelmath.cpp.o
#32 1972.4 [ 21%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_deep.cpp.o
#32 1972.4 [ 22%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_draw.cpp.o
#32 1972.4 [ 23%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_addsub.cpp.o
#32 1972.4 [ 23%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo.cpp.o
#32 1972.4 [ 23%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_compare.cpp.o
#32 1972.4 [ 24%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_copy.cpp.o
#32 1972.4 [ 25%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_muldiv.cpp.o
#32 1972.4 [ 26%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_mad.cpp.o
#32 1972.4 [ 27%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_minmaxchan.cpp.o
#32 1972.4 [ 28%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_orient.cpp.o
#32 1972.4 [ 28%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_xform.cpp.o
#32 1972.4 [ 29%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_yee.cpp.o
#32 1972.4 [ 30%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebufalgo_opencv.cpp.o
#32 1972.4 [ 31%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/deepdata.cpp.o
#32 1972.4 [ 32%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/exif.cpp.o
#32 1972.4 [ 33%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/exif-canon.cpp.o
#32 1972.4 [ 34%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/formatspec.cpp.o
#32 1972.4 [ 34%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/icc.cpp.o
#32 1972.4 [ 35%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imagebuf.cpp.o
#32 1972.4 [ 36%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imageinput.cpp.o
#32 1972.4 [ 37%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imageio.cpp.o
#32 1972.4 [ 38%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imageioplugin.cpp.o
#32 1972.4 [ 39%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/imageoutput.cpp.o
#32 1972.4 [ 40%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/iptc.cpp.o
#32 1972.4 [ 40%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/xmp.cpp.o
#32 1972.4 [ 41%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/color_ocio.cpp.o
#32 1972.4 [ 42%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/maketexture.cpp.o
#32 1972.4 [ 43%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/bluenoise.cpp.o
#32 1972.4 [ 44%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/libtexture/texturesys.cpp.o
#32 1972.4 [ 45%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/libtexture/texture3d.cpp.o
#32 1972.4 [ 46%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/libtexture/environment.cpp.o
#32 1972.4 [ 46%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/libtexture/texoptions.cpp.o
#32 1972.4 [ 47%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/libtexture/imagecache.cpp.o
#32 1972.4 [ 48%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/bmp.imageio/bmpinput.cpp.o
#32 1972.4 [ 49%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/bmp.imageio/bmpoutput.cpp.o
#32 1972.4 [ 50%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/bmp.imageio/bmp_pvt.cpp.o
#32 1972.4 [ 51%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/cineoninput.cpp.o
#32 1972.4 [ 52%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/libcineon/Cineon.cpp.o
#32 1972.4 [ 52%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/libcineon/OutStream.cpp.o
#32 1972.4 [ 53%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/libcineon/Codec.cpp.o
#32 1972.4 [ 54%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/libcineon/Reader.cpp.o
#32 1972.4 [ 55%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/libcineon/CineonHeader.cpp.o
#32 1972.4 [ 56%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/libcineon/ElementReadStream.cpp.o
#32 1972.4 [ 57%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/cineon.imageio/libcineon/InStream.cpp.o
#32 1972.4 [ 58%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dds.imageio/ddsinput.cpp.o
#32 1972.4 [ 58%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/dpxinput.cpp.o
#32 1972.4 [ 59%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/dpxoutput.cpp.o
#32 1972.4 [ 60%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/DPX.cpp.o
#32 1972.4 [ 61%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/OutStream.cpp.o
#32 1972.4 [ 62%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/RunLengthEncoding.cpp.o
#32 1972.4 [ 63%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/Codec.cpp.o
#32 1972.4 [ 64%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/Reader.cpp.o
#32 1972.4 [ 64%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/Writer.cpp.o
#32 1972.4 [ 65%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/DPXHeader.cpp.o
#32 1972.4 [ 66%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/ElementReadStream.cpp.o
#32 1972.4 [ 67%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/InStream.cpp.o
#32 1972.4 [ 68%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/dpx.imageio/libdpx/DPXColorConverter.cpp.o
#32 1972.4 [ 69%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/ffmpeg.imageio/ffmpeginput.cpp.o
#32 1972.4 [ 69%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/fits.imageio/fitsinput.cpp.o
#32 1972.4 [ 70%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/fits.imageio/fitsoutput.cpp.o
#32 1972.4 [ 71%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/fits.imageio/fits_pvt.cpp.o
#32 1972.4 [ 72%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/hdr.imageio/hdrinput.cpp.o
#32 1972.4 [ 73%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/hdr.imageio/hdroutput.cpp.o
#32 1972.4 [ 74%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/ico.imageio/icoinput.cpp.o
#32 1972.4 [ 75%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/ico.imageio/icooutput.cpp.o
#32 1972.4 [ 75%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/iff.imageio/iffinput.cpp.o
#32 1972.4 [ 76%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/iff.imageio/iffoutput.cpp.o
#32 1972.4 [ 77%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/jpeg.imageio/jpeginput.cpp.o
#32 1972.4 [ 78%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/jpeg.imageio/jpegoutput.cpp.o
#32 1972.4 [ 79%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/jpeg2000.imageio/jpeg2000input.cpp.o
#32 1972.4 [ 80%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/jpeg2000.imageio/jpeg2000output.cpp.o
#32 1972.4 [ 81%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/null.imageio/nullimageio.cpp.o
#32 1972.4 [ 81%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/openexr.imageio/exrinput.cpp.o
#32 1972.4 [ 82%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/openexr.imageio/exroutput.cpp.o
#32 1972.4 [ 83%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/openexr.imageio/exrinput_c.cpp.o
#32 1972.4 [ 84%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/png.imageio/pnginput.cpp.o
#32 1972.4 [ 85%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/png.imageio/pngoutput.cpp.o
#32 1972.4 [ 86%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/pnm.imageio/pnminput.cpp.o
#32 1972.4 [ 87%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/pnm.imageio/pnmoutput.cpp.o
#32 1972.4 [ 87%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/psd.imageio/psdinput.cpp.o
#32 1972.4 [ 88%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/raw.imageio/rawinput.cpp.o
#32 1972.4 [ 89%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/rla.imageio/rlainput.cpp.o
#32 1972.4 [ 90%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/rla.imageio/rlaoutput.cpp.o
#32 1972.4 [ 91%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/sgi.imageio/sgiinput.cpp.o
#32 1972.4 [ 92%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/sgi.imageio/sgioutput.cpp.o
#32 1972.4 [ 93%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/softimage.imageio/softimageinput.cpp.o
#32 1972.4 [ 93%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/softimage.imageio/softimage_pvt.cpp.o
#32 1972.4 [ 94%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/targa.imageio/targainput.cpp.o
#32 1972.4 [ 95%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/targa.imageio/targaoutput.cpp.o
#32 1972.4 [ 96%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/term.imageio/termoutput.cpp.o
#32 1972.4 [ 97%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/tiff.imageio/tiffinput.cpp.o
#32 1972.4 [ 98%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/tiff.imageio/tiffoutput.cpp.o
#32 1972.4 [ 99%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/zfile.imageio/zfile.cpp.o
#32 1972.4 [ 99%] Building CXX object src/libOpenImageIO/CMakeFiles/OpenImageIO.dir/__/include/OpenImageIO/detail/pugixml/pugixml.cpp.o
#32 1972.4 [100%] Linking CXX shared library ../../lib/libOpenImageIO.so
#32 1972.4 [100%] Built target OpenImageIO
#32 1972.4 [772/2153] cd /OpenRV/_build/RV_DEPS_OCIO/build && /usr/local/bin/cmake --install /OpenRV/_build/RV_DEPS_OCIO/build --prefix /OpenRV/_build/RV_DEPS_OCIO/install --config Release && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_OCIO-prefix/src/RV_DEPS_OCIO-stamp/RV_DEPS_OCIO-install
#32 1972.4 -- Set runtime path of "/OpenRV/_build/RV_DEPS_OCIO/install/lib64/python3.10/site-packages/PyOpenColorIO.so" to "$ORIGIN/../..:$ORIGIN/../lib64:$ORIGIN"
#32 1972.4 -- Set runtime path of "/OpenRV/_build/RV_DEPS_OCIO/install/lib64/libOpenColorIO.so.2.2.1" to "$ORIGIN/../lib64:$ORIGIN"
#32 1972.4 [774/2153] cd /OpenRV/_build/cmake/dependencies && /usr/local/bin/cmake -E copy /OpenRV/_build/RV_DEPS_OCIO/install/lib64/python3.10/site-packages/PyOpenColorIO.so /OpenRV/_build/stage/app/plugins/Python && cd /OpenRV/_build/cmake/dependencies && /usr/local/bin/cmake -E copy_directory /OpenRV/_build/RV_DEPS_OCIO/install/lib64 /OpenRV/_build/stage/app/lib
#32 1972.4 [775/2153] cd /OpenRV/_build/RV_DEPS_SPDLOG/src && /usr/local/bin/cmake --build /OpenRV/_build/RV_DEPS_SPDLOG/build --config Release -j8 && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_SPDLOG-prefix/src/RV_DEPS_SPDLOG-stamp/RV_DEPS_SPDLOG-build
#32 1972.4 [ 37%] Building CXX object CMakeFiles/spdlog.dir/src/spdlog.cpp.o
#32 1972.4 [ 50%] Building CXX object CMakeFiles/spdlog.dir/src/stdout_sinks.cpp.o
#32 1972.4 [ 50%] Building CXX object CMakeFiles/spdlog.dir/src/async.cpp.o
#32 1972.4 [ 50%] Building CXX object CMakeFiles/spdlog.dir/src/color_sinks.cpp.o
#32 1972.4 [ 62%] Building CXX object CMakeFiles/spdlog.dir/src/cfg.cpp.o
#32 1972.4 [ 75%] Building CXX object CMakeFiles/spdlog.dir/src/file_sinks.cpp.o
#32 1972.4 [ 87%] Building CXX object CMakeFiles/spdlog.dir/src/bundled_fmtlib_format.cpp.o
#32 1972.4 [100%] Linking CXX static library libspdlog.a
#32 1972.4 [100%] Built target spdlog
#32 1972.4 [776/2153] cd /OpenRV/_build/RV_DEPS_OIIO/build && /usr/local/bin/cmake --install /OpenRV/_build/RV_DEPS_OIIO/build --prefix /OpenRV/_build/RV_DEPS_OIIO/install --config Release && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_OIIO-prefix/src/RV_DEPS_OIIO-stamp/RV_DEPS_OIIO-install
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/pkgconfig/OpenImageIO.pc
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/cmake/OpenImageIO/OpenImageIOConfig.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/cmake/OpenImageIO/OpenImageIOConfigVersion.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/cmake/OpenImageIO/OpenImageIOTargets.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/cmake/OpenImageIO/OpenImageIOTargets-release.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO_Util.so.2.4.6
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO_Util.so.2.4
#32 1972.4 -- Set runtime path of "/OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO_Util.so.2.4.6" to "/OpenRV/_build/RV_DEPS_OIIO/install/lib64:/OpenRV/_build/RV_DEPS_BOOST/install/lib:/OpenRV/_build/RV_DEPS_IMATH/install/lib64"
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO_Util.so
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO.so.2.4.6
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO.so.2.4
#32 1972.4 -- Set runtime path of "/OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO.so.2.4.6" to "/OpenRV/_build/RV_DEPS_OIIO/install/lib64:/OpenRV/_build/RV_DEPS_BOOST/install/lib:/OpenRV/_build/RV_DEPS_ZLIB/install/lib:/OpenRV/_build/RV_DEPS_FFMPEG/install/lib:/OpenRV/_build/RV_DEPS_PNG/install/lib64:/OpenRV/_build/RV_DEPS_OPENJPEG/install/lib:/OpenRV/_build/RV_DEPS_OPENEXR/install/lib64:/OpenRV/_build/RV_DEPS_RAW/install/lib:/OpenRV/_build/RV_DEPS_TIFF/install/lib64:/OpenRV/_build/RV_DEPS_IMATH/install/lib64:/OpenRV/_build/RV_DEPS_JPEGTURBO/install/lib64"
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/lib64/libOpenImageIO.so
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/argparse.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/array_view.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/atomic.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/attrdelegate.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/benchmark.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/color.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/dassert.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/deepdata.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/errorhandler.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/export.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/filesystem.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/filter.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/fmath.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/fstream_mingw.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/function_view.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/hash.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/image_view.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/imagebuf.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/imagebufalgo.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/imagebufalgo_util.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/imagecache.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/imageio.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/missing_math.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/optparser.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/parallel.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/paramlist.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/platform.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/plugin.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/refcnt.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/simd.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/span.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/strided_ptr.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/string_view.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/strongparam.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/strutil.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/sysutil.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/texture.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/thread.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/tiffutils.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/timer.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/type_traits.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/typedesc.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/unittest.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/unordered_map_concurrent.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/ustring.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/varyingref.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/vecparam.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/version.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/oiioversion.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/half.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/Imath.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/farmhash.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/fmt.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/fmt/core.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/fmt/format-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/fmt/format.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/fmt/ostream.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/fmt/printf.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/pugixml/pugixml.hpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/pugixml/pugiconfig.hpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/include/OpenImageIO/detail/pugixml/pugixml.cpp
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/share/doc/OpenImageIO/LICENSE.md
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/share/doc/OpenImageIO/THIRD-PARTY.md
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/share/doc/OpenImageIO/CHANGES.md
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/share/doc/OpenImageIO/CHANGES-0.x.md
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_OIIO/install/share/doc/OpenImageIO/CHANGES-1.x.md
#32 1972.4 [778/2153] cd /OpenRV/_build/cmake/dependencies && /usr/local/bin/cmake -E copy_directory /OpenRV/_build/RV_DEPS_OIIO/install/lib64 /OpenRV/_build/stage/app/lib
#32 1972.4 [779/2153] cd /OpenRV/_build/RV_DEPS_AJA/build && /usr/local/bin/cmake --build /OpenRV/_build/RV_DEPS_AJA/build --config Release -j8 && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_AJA-prefix/src/RV_DEPS_AJA-stamp/RV_DEPS_AJA-build
#32 1972.4 [  1%] Creating directories for 'mbedtls'
#32 1972.4 [  2%] Performing download step (git clone) for 'mbedtls'
#32 1972.4 branch 'fix-win-dll-cmake' set up to track 'origin/fix-win-dll-cmake'.
#32 1972.4 Submodule path 'framework': checked out '750634d3a51eb9d61b59fd5d801546927c946588'
#32 1972.4 [  3%] Performing update step for 'mbedtls'
#32 1972.4 [  4%] No patch step for 'mbedtls'
#32 1972.4 [  4%] Performing configure step for 'mbedtls'
#32 1972.4 -- The C compiler identification is GNU 11.5.0
#32 1972.4 -- Detecting C compiler ABI info
#32 1972.4 -- Detecting C compiler ABI info - done
#32 1972.4 -- Check for working C compiler: /usr/bin/cc - skipped
#32 1972.4 -- Detecting C compile features
#32 1972.4 -- Detecting C compile features - done
#32 1972.4 -- Found Python3: /usr/bin/python3.9 (found version "3.9.21") found components: Interpreter 
#32 1972.4 -- Performing Test CMAKE_HAVE_LIBC_PTHREAD
#32 1972.4 -- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success
#32 1972.4 -- Found Threads: TRUE  
#32 1972.4 -- Performing Test C_COMPILER_SUPPORTS_WFORMAT_SIGNEDNESS
#32 1972.4 -- Performing Test C_COMPILER_SUPPORTS_WFORMAT_SIGNEDNESS - Success
#32 1972.4 -- !!!! Using libs: 
#32 1972.4 -- Configuring done (1.5s)
#32 1972.4 -- Generating done (0.1s)
#32 1972.4 -- Build files have been written to: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-prefix/src/mbedtls-build
#32 1972.4 [  5%] Performing build step for 'mbedtls'
#32 1972.4 [  2%] Building C object 3rdparty/everest/CMakeFiles/everest.dir/library/Hacl_Curve25519_joined.c.o
#32 1972.4 [  2%] Building C object 3rdparty/p256-m/CMakeFiles/p256m.dir/p256-m_driver_entrypoints.c.o
#32 1972.4 [  3%] Building C object 3rdparty/everest/CMakeFiles/everest.dir/library/x25519.c.o
#32 1972.4 [  3%] Building C object 3rdparty/everest/CMakeFiles/everest.dir/library/everest.c.o
#32 1972.4 [  4%] Building C object 3rdparty/p256-m/CMakeFiles/p256m.dir/p256-m/p256-m.c.o
#32 1972.4 [  5%] Linking C static library libeverest.a
#32 1972.4 [  6%] Linking C static library libp256m.a
#32 1972.4 [  6%] Built target everest
#32 1972.4 [  6%] Built target p256m
#32 1972.4 [  7%] Building C object library/CMakeFiles/mbedcrypto.dir/aes.c.o
#32 1972.4 [  8%] Building C object library/CMakeFiles/mbedcrypto.dir/aesni.c.o
#32 1972.4 [  8%] Building C object library/CMakeFiles/mbedcrypto.dir/aesce.c.o
#32 1972.4 [  9%] Building C object library/CMakeFiles/mbedcrypto.dir/bignum.c.o
#32 1972.4 [ 10%] Building C object library/CMakeFiles/mbedcrypto.dir/aria.c.o
#32 1972.4 [ 11%] Building C object library/CMakeFiles/mbedcrypto.dir/asn1write.c.o
#32 1972.4 [ 12%] Building C object library/CMakeFiles/mbedcrypto.dir/asn1parse.c.o
#32 1972.4 [ 13%] Building C object library/CMakeFiles/mbedcrypto.dir/base64.c.o
#32 1972.4 [ 14%] Building C object library/CMakeFiles/mbedcrypto.dir/bignum_core.c.o
#32 1972.4 [ 14%] Building C object library/CMakeFiles/mbedcrypto.dir/bignum_mod.c.o
#32 1972.4 [ 15%] Building C object library/CMakeFiles/mbedcrypto.dir/bignum_mod_raw.c.o
#32 1972.4 [ 16%] Building C object library/CMakeFiles/mbedcrypto.dir/block_cipher.c.o
#32 1972.4 [ 17%] Building C object library/CMakeFiles/mbedcrypto.dir/camellia.c.o
#32 1972.4 [ 18%] Building C object library/CMakeFiles/mbedcrypto.dir/ccm.c.o
#32 1972.4 [ 19%] Building C object library/CMakeFiles/mbedcrypto.dir/chacha20.c.o
#32 1972.4 [ 19%] Building C object library/CMakeFiles/mbedcrypto.dir/chachapoly.c.o
#32 1972.4 [ 20%] Building C object library/CMakeFiles/mbedcrypto.dir/cipher.c.o
#32 1972.4 [ 21%] Building C object library/CMakeFiles/mbedcrypto.dir/cipher_wrap.c.o
#32 1972.4 [ 22%] Building C object library/CMakeFiles/mbedcrypto.dir/constant_time.c.o
#32 1972.4 [ 23%] Building C object library/CMakeFiles/mbedcrypto.dir/cmac.c.o
#32 1972.4 [ 24%] Building C object library/CMakeFiles/mbedcrypto.dir/ctr_drbg.c.o
#32 1972.4 [ 25%] Building C object library/CMakeFiles/mbedcrypto.dir/des.c.o
#32 1972.4 [ 25%] Building C object library/CMakeFiles/mbedcrypto.dir/dhm.c.o
#32 1972.4 [ 26%] Building C object library/CMakeFiles/mbedcrypto.dir/ecdh.c.o
#32 1972.4 [ 27%] Building C object library/CMakeFiles/mbedcrypto.dir/ecdsa.c.o
#32 1972.4 [ 28%] Building C object library/CMakeFiles/mbedcrypto.dir/ecjpake.c.o
#32 1972.4 [ 29%] Building C object library/CMakeFiles/mbedcrypto.dir/ecp.c.o
#32 1972.4 [ 30%] Building C object library/CMakeFiles/mbedcrypto.dir/ecp_curves.c.o
#32 1972.4 [ 30%] Building C object library/CMakeFiles/mbedcrypto.dir/ecp_curves_new.c.o
#32 1972.4 [ 31%] Building C object library/CMakeFiles/mbedcrypto.dir/entropy.c.o
#32 1972.4 [ 32%] Building C object library/CMakeFiles/mbedcrypto.dir/entropy_poll.c.o
#32 1972.4 [ 33%] Building C object library/CMakeFiles/mbedcrypto.dir/error.c.o
#32 1972.4 [ 34%] Building C object library/CMakeFiles/mbedcrypto.dir/gcm.c.o
#32 1972.4 [ 35%] Building C object library/CMakeFiles/mbedcrypto.dir/hkdf.c.o
#32 1972.4 [ 36%] Building C object library/CMakeFiles/mbedcrypto.dir/hmac_drbg.c.o
#32 1972.4 [ 36%] Building C object library/CMakeFiles/mbedcrypto.dir/lmots.c.o
#32 1972.4 [ 37%] Building C object library/CMakeFiles/mbedcrypto.dir/lms.c.o
#32 1972.4 [ 38%] Building C object library/CMakeFiles/mbedcrypto.dir/md.c.o
#32 1972.4 [ 39%] Building C object library/CMakeFiles/mbedcrypto.dir/md5.c.o
#32 1972.4 [ 40%] Building C object library/CMakeFiles/mbedcrypto.dir/memory_buffer_alloc.c.o
#32 1972.4 [ 41%] Building C object library/CMakeFiles/mbedcrypto.dir/nist_kw.c.o
#32 1972.4 [ 41%] Building C object library/CMakeFiles/mbedcrypto.dir/oid.c.o
#32 1972.4 [ 42%] Building C object library/CMakeFiles/mbedcrypto.dir/padlock.c.o
#32 1972.4 [ 43%] Building C object library/CMakeFiles/mbedcrypto.dir/pem.c.o
#32 1972.4 [ 44%] Building C object library/CMakeFiles/mbedcrypto.dir/pk.c.o
#32 1972.4 [ 45%] Building C object library/CMakeFiles/mbedcrypto.dir/pk_ecc.c.o
#32 1972.4 [ 46%] Building C object library/CMakeFiles/mbedcrypto.dir/pkcs12.c.o
#32 1972.4 [ 47%] Building C object library/CMakeFiles/mbedcrypto.dir/pk_wrap.c.o
#32 1972.4 [ 47%] Building C object library/CMakeFiles/mbedcrypto.dir/pkcs5.c.o
#32 1972.4 [ 48%] Building C object library/CMakeFiles/mbedcrypto.dir/pkparse.c.o
#32 1972.4 [ 49%] Building C object library/CMakeFiles/mbedcrypto.dir/pkwrite.c.o
#32 1972.4 [ 50%] Building C object library/CMakeFiles/mbedcrypto.dir/platform.c.o
#32 1972.4 [ 51%] Building C object library/CMakeFiles/mbedcrypto.dir/platform_util.c.o
#32 1972.4 [ 52%] Building C object library/CMakeFiles/mbedcrypto.dir/poly1305.c.o
#32 1972.4 [ 53%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto.c.o
#32 1972.4 [ 53%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_aead.c.o
#32 1972.4 [ 54%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_cipher.c.o
#32 1972.4 [ 55%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_client.c.o
#32 1972.4 [ 56%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_driver_wrappers_no_static.c.o
#32 1972.4 [ 57%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_ecp.c.o
#32 1972.4 [ 58%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_ffdh.c.o
#32 1972.4 [ 58%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_hash.c.o
#32 1972.4 [ 59%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_mac.c.o
#32 1972.4 [ 60%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_pake.c.o
#32 1972.4 [ 61%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_rsa.c.o
#32 1972.4 [ 62%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_se.c.o
#32 1972.4 [ 63%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_slot_management.c.o
#32 1972.4 [ 64%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_crypto_storage.c.o
#32 1972.4 [ 64%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_its_file.c.o
#32 1972.4 [ 65%] Building C object library/CMakeFiles/mbedcrypto.dir/psa_util.c.o
#32 1972.4 [ 66%] Building C object library/CMakeFiles/mbedcrypto.dir/ripemd160.c.o
#32 1972.4 [ 67%] Building C object library/CMakeFiles/mbedcrypto.dir/rsa.c.o
#32 1972.4 [ 68%] Building C object library/CMakeFiles/mbedcrypto.dir/rsa_alt_helpers.c.o
#32 1972.4 [ 69%] Building C object library/CMakeFiles/mbedcrypto.dir/sha1.c.o
#32 1972.4 [ 69%] Building C object library/CMakeFiles/mbedcrypto.dir/sha256.c.o
#32 1972.4 [ 70%] Building C object library/CMakeFiles/mbedcrypto.dir/sha512.c.o
#32 1972.4 [ 71%] Building C object library/CMakeFiles/mbedcrypto.dir/sha3.c.o
#32 1972.4 [ 72%] Building C object library/CMakeFiles/mbedcrypto.dir/threading.c.o
#32 1972.4 [ 73%] Building C object library/CMakeFiles/mbedcrypto.dir/timing.c.o
#32 1972.4 [ 74%] Building C object library/CMakeFiles/mbedcrypto.dir/version.c.o
#32 1972.4 [ 75%] Building C object library/CMakeFiles/mbedcrypto.dir/version_features.c.o
#32 1972.4 [ 75%] Linking C static library libmbedcrypto.a
#32 1972.4 [ 75%] Built target mbedcrypto
#32 1972.4 [ 76%] Building C object library/CMakeFiles/mbedx509.dir/pkcs7.c.o
#32 1972.4 [ 77%] Building C object library/CMakeFiles/mbedx509.dir/x509_create.c.o
#32 1972.4 [ 78%] Building C object library/CMakeFiles/mbedx509.dir/x509.c.o
#32 1972.4 [ 78%] Building C object library/CMakeFiles/mbedx509.dir/x509write.c.o
#32 1972.4 [ 79%] Building C object library/CMakeFiles/mbedx509.dir/x509_crl.c.o
#32 1972.4 [ 80%] Building C object library/CMakeFiles/mbedx509.dir/x509_crt.c.o
#32 1972.4 [ 81%] Building C object library/CMakeFiles/mbedx509.dir/x509_csr.c.o
#32 1972.4 [ 82%] Building C object library/CMakeFiles/mbedx509.dir/x509write_crt.c.o
#32 1972.4 [ 83%] Building C object library/CMakeFiles/mbedx509.dir/x509write_csr.c.o
#32 1972.4 [ 84%] Linking C static library libmbedx509.a
#32 1972.4 [ 84%] Built target mbedx509
#32 1972.4 [ 85%] Building C object library/CMakeFiles/mbedtls.dir/debug.c.o
#32 1972.4 [ 86%] Building C object library/CMakeFiles/mbedtls.dir/mps_trace.c.o
#32 1972.4 [ 87%] Building C object library/CMakeFiles/mbedtls.dir/net_sockets.c.o
#32 1972.4 [ 88%] Building C object library/CMakeFiles/mbedtls.dir/mps_reader.c.o
#32 1972.4 [ 89%] Building C object library/CMakeFiles/mbedtls.dir/ssl_ciphersuites.c.o
#32 1972.4 [ 89%] Building C object library/CMakeFiles/mbedtls.dir/ssl_client.c.o
#32 1972.4 [ 91%] Building C object library/CMakeFiles/mbedtls.dir/ssl_cache.c.o
#32 1972.4 [ 91%] Building C object library/CMakeFiles/mbedtls.dir/ssl_cookie.c.o
#32 1972.4 [ 92%] Building C object library/CMakeFiles/mbedtls.dir/ssl_debug_helpers_generated.c.o
#32 1972.4 [ 93%] Building C object library/CMakeFiles/mbedtls.dir/ssl_msg.c.o
#32 1972.4 [ 94%] Building C object library/CMakeFiles/mbedtls.dir/ssl_ticket.c.o
#32 1972.4 [ 95%] Building C object library/CMakeFiles/mbedtls.dir/ssl_tls.c.o
#32 1972.4 [ 95%] Building C object library/CMakeFiles/mbedtls.dir/ssl_tls12_client.c.o
#32 1972.4 [ 96%] Building C object library/CMakeFiles/mbedtls.dir/ssl_tls12_server.c.o
#32 1972.4 [ 97%] Building C object library/CMakeFiles/mbedtls.dir/ssl_tls13_keys.c.o
#32 1972.4 [ 98%] Building C object library/CMakeFiles/mbedtls.dir/ssl_tls13_server.c.o
#32 1972.4 [ 99%] Building C object library/CMakeFiles/mbedtls.dir/ssl_tls13_client.c.o
#32 1972.4 [100%] Building C object library/CMakeFiles/mbedtls.dir/ssl_tls13_generic.c.o
#32 1972.4 [100%] Linking C static library libmbedtls.a
#32 1972.4 [100%] Built target mbedtls
#32 1972.4 [  6%] Performing install step for 'mbedtls'
#32 1972.4 [  3%] Built target everest
#32 1972.4 [  6%] Built target p256m
#32 1972.4 [ 75%] Built target mbedcrypto
#32 1972.4 [ 84%] Built target mbedx509
#32 1972.4 [100%] Built target mbedtls
#32 1972.4 Install the project...
#32 1972.4 -- Install configuration: "Release"
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/cmake/MbedTLS/MbedTLSConfig.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/cmake/MbedTLS/MbedTLSConfigVersion.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/cmake/MbedTLS/MbedTLSTargets.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/cmake/MbedTLS/MbedTLSTargets-release.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/aes.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/aria.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/asn1.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/asn1write.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/base64.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/bignum.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/block_cipher.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/build_info.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/camellia.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ccm.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/chacha20.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/chachapoly.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/check_config.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/cipher.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/cmac.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/compat-2.x.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/config_adjust_legacy_crypto.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/config_adjust_legacy_from_psa.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/config_adjust_psa_from_legacy.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/config_adjust_psa_superset_legacy.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/config_adjust_ssl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/config_adjust_x509.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/config_psa.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/constant_time.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ctr_drbg.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/debug.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/des.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/dhm.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ecdh.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ecdsa.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ecjpake.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ecp.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/entropy.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/error.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/export.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/gcm.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/hkdf.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/hmac_drbg.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/lms.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/mbedtls_config.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/md.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/md5.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/memory_buffer_alloc.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/net_sockets.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/nist_kw.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/oid.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/pem.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/pk.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/pkcs12.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/pkcs5.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/pkcs7.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/platform.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/platform_time.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/platform_util.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/poly1305.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/private_access.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/psa_util.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ripemd160.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/rsa.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/sha1.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/sha256.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/sha3.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/sha512.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ssl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ssl_cache.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ssl_ciphersuites.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ssl_cookie.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/ssl_ticket.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/threading.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/timing.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/version.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/x509.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/x509_crl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/x509_crt.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/mbedtls/x509_csr.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/build_info.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_adjust_auto_enabled.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_adjust_config_key_pair_types.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_adjust_config_synonyms.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_builtin_composites.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_builtin_key_derivation.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_builtin_primitives.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_compat.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_config.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_driver_common.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_driver_contexts_composites.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_driver_contexts_key_derivation.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_driver_contexts_primitives.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_extra.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_legacy.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_platform.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_se_driver.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_sizes.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_struct.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_types.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/psa/crypto_values.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/Hacl_Curve25519.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/everest.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/vs2013
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/vs2013/inttypes.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/vs2013/Hacl_Curve25519.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/vs2013/stdbool.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlib.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/c_endianness.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal/types.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal/builtin.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal/target.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal/debug.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal/compat.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal/wasmsupport.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlin/internal/callconv.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlib
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlib/FStar_UInt64_FStar_UInt32_FStar_UInt16_FStar_UInt8.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/kremlib/FStar_UInt128.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/include/everest/x25519.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libeverest.a
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libp256m.a
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedcrypto.a
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedx509.a
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedtls.a
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/pkgconfig/mbedcrypto.pc
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/pkgconfig/mbedtls.pc
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/pkgconfig/mbedx509.pc
#32 1972.4 [  7%] Completed 'mbedtls'
#32 1972.4 [  7%] Built target mbedtls
#32 1972.4 [  7%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata.cpp.o
#32 1972.4 [  8%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydatafactory.cpp.o
#32 1972.4 [  9%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_cea608_vanc.cpp.o
#32 1972.4 [ 10%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_cea608_line21.cpp.o
#32 1972.4 [ 11%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_cea608.cpp.o
#32 1972.4 [ 12%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_cea708.cpp.o
#32 1972.4 [ 13%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_framestatusinfo5251.cpp.o
#32 1972.4 [ 13%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_framestatusinfo524D.cpp.o
#32 1972.4 [ 14%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_hdr_hdr10.cpp.o
#32 1972.4 [ 15%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_hdr_hlg.cpp.o
#32 1972.4 [ 16%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_hdr_sdr.cpp.o
#32 1972.4 [ 17%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_timecode.cpp.o
#32 1972.4 [ 17%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_timecode_atc.cpp.o
#32 1972.4 [ 18%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_timecode_vitc.cpp.o
#32 1972.4 [ 19%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarydata_hdmi_aux.cpp.o
#32 1972.4 [ 20%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajaanc/src/ancillarylist.cpp.o
#32 1972.4 [ 21%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/audioutilities.cpp.o
#32 1972.4 [ 22%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/buffer.cpp.o
#32 1972.4 [ 22%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/commandline.cpp.o
#32 1972.4 [ 23%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/common.cpp.o
#32 1972.4 [ 24%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/dpxfileio.cpp.o
#32 1972.4 [ 25%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/dpx_hdr.cpp.o
#32 1972.4 [ 26%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/guid.cpp.o
#32 1972.4 [ 27%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/options_popt.cpp.o
#32 1972.4 [ 27%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/performance.cpp.o
#32 1972.4 [ 28%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/pixelformat.cpp.o
#32 1972.4 [ 29%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/timebase.cpp.o
#32 1972.4 [ 30%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/timecode.cpp.o
#32 1972.4 [ 31%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/timecodeburn.cpp.o
#32 1972.4 [ 32%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/timer.cpp.o
#32 1972.4 [ 32%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/variant.cpp.o
#32 1972.4 [ 33%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/videoutilities.cpp.o
#32 1972.4 [ 34%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/common/wavewriter.cpp.o
#32 1972.4 [ 35%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/network/ip_socket.cpp.o
#32 1972.4 [ 36%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/network/network.cpp.o
#32 1972.4 [ 37%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/network/tcp_socket.cpp.o
#32 1972.4 [ 37%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/network/udp_socket.cpp.o
#32 1972.4 [ 38%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/persistence/persistence.cpp.o
#32 1972.4 [ 39%] Building C object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/persistence/sqlite3.c.o
#32 1972.4 [ 40%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/pnp/pnp.cpp.o
#32 1972.4 [ 41%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/atomic.cpp.o
#32 1972.4 [ 42%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/debug.cpp.o
#32 1972.4 [ 42%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/diskstatus.cpp.o
#32 1972.4 [ 43%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/event.cpp.o
#32 1972.4 [ 44%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/file_io.cpp.o
#32 1972.4 [ 45%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/info.cpp.o
#32 1972.4 [ 46%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/lock.cpp.o
#32 1972.4 [ 47%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/log.cpp.o
#32 1972.4 [ 47%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/memory.cpp.o
#32 1972.4 [ 48%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/process.cpp.o
#32 1972.4 [ 49%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/system.cpp.o
#32 1972.4 [ 50%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/systemtime.cpp.o
#32 1972.4 [ 51%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/system/thread.cpp.o
#32 1972.4 [ 52%] Building CXX object ajantv2/CMakeFiles/ajantv2.dir/__/ajabase/pnp/linux/pnpimpl.cpp.o
#32 1972.4 [780/2153] cd /OpenRV/_build/RV_DEPS_SPDLOG/src && /usr/local/bin/cmake --install /OpenRV/_build/RV_DEPS_SPDLOG/build --prefix /OpenRV/_build/RV_DEPS_SPDLOG/install --config Release && /usr/local/bin/cmake -E copy_directory /OpenRV/_build/RV_DEPS_SPDLOG/install/lib64 /OpenRV/_build/stage/app/lib && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_SPDLOG-prefix/src/RV_DEPS_SPDLOG-stamp/RV_DEPS_SPDLOG-install
#32 1972.4 -- Up-to-date: /OpenRV/_build/RV_DEPS_SPDLOG/install/include
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/spdlog-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/cfg
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/cfg/helpers-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/cfg/helpers.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/cfg/argv.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/cfg/env.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/pattern_formatter-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/version.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/compile.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/xchar.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/fmt.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/chrono.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/ranges.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bin_to_hex.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/ostr.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fwd.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/async_logger.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/logger-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/ansicolor_sink-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/rotating_file_sink-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/systemd_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/daily_file_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/mongo_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/stdout_color_sinks.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/dup_filter_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/qt_sinks.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/msvc_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/ringbuffer_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/win_eventlog_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/stdout_sinks-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/hourly_file_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/syslog_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/wincolor_sink-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/stdout_color_sinks-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/sink-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/wincolor_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/base_sink-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/android_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/null_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/basic_file_sink-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/ansicolor_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/stdout_sinks.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/udp_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/ostream_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/base_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/rotating_file_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/tcp_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/dist_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/sinks/basic_file_sink.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/common-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/logger.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/tweakme.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/tweakme.h.orig
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/os.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/registry-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/null_mutex.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/log_msg.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/circular_q.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/mpmc_blocking_q.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/registry.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/log_msg_buffer.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/tcp_client.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/fmt_helper.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/periodic_worker.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/thread_pool-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/udp_client-windows.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/file_helper.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/thread_pool.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/udp_client.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/os-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/console_globals.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/synchronous_factory.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/backtracer-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/file_helper-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/windows_include.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/backtracer.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/log_msg-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/periodic_worker-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/log_msg_buffer-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/details/tcp_client-windows.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/async.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/async_logger-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/pattern_formatter.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/stopwatch.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/formatter.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/common.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/spdlog.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/lib64/libspdlog.a
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled/
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//os.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//locale.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//compile.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//xchar.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//format-inl.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//printf.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//ostream.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//core.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//args.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//format.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//chrono.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//ranges.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//fmt.license.rst
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/include/spdlog/fmt/bundled//color.h
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/lib64/pkgconfig/spdlog.pc
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/lib64/cmake/spdlog/spdlogConfigTargets.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/lib64/cmake/spdlog/spdlogConfigTargets-release.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/lib64/cmake/spdlog/spdlogConfig.cmake
#32 1972.4 -- Installing: /OpenRV/_build/RV_DEPS_SPDLOG/install/lib64/cmake/spdlog/spdlogConfigVersion.cmake
#32 1972.4 [823/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_NO_DEBUG -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/app/PyTwkApp -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/mu/MuPy -I/OpenRV/src/lib/app/MuTwkApp -I/OpenRV/src/lib/app/TwkApp -I/OpenRV/src/lib/audio/TwkAudio -I/OpenRV/src/lib/base/TwkMath -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/python/TwkPython -I/OpenRV/src/lib/app/ImGuiPythonBridge -isystem /OpenRV/_build/RV_DEPS_PYTHON3/install/include/python3.10 -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /OpenRV/_build/RV_DEPS_IMGUI/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/app/PyTwkApp/CMakeFiles/PyTwkApp.dir/PyInterface.cpp.o -MF src/lib/app/PyTwkApp/CMakeFiles/PyTwkApp.dir/PyInterface.cpp.o.d -o src/lib/app/PyTwkApp/CMakeFiles/PyTwkApp.dir/PyInterface.cpp.o -c /OpenRV/src/lib/app/PyTwkApp/PyInterface.cpp
#32 1972.4 /OpenRV/src/lib/app/PyTwkApp/PyInterface.cpp: In function 'void TwkApp::initPython(int, char**)':
#32 1972.4 /OpenRV/src/lib/app/PyTwkApp/PyInterface.cpp:295:27: warning: 'void PyEval_InitThreads()' is deprecated [-Wdeprecated-declarations]
#32 1972.4   295 |         PyEval_InitThreads();
#32 1972.4       |         ~~~~~~~~~~~~~~~~~~^~
#32 1972.4 In file included from /OpenRV/_build/RV_DEPS_PYTHON3/install/include/python3.10/Python.h:130,
#32 1972.4                  from /OpenRV/src/lib/app/PyTwkApp/PyTwkApp/PyEventType.h:10,
#32 1972.4                  from /OpenRV/src/lib/app/PyTwkApp/PyInterface.cpp:10:
#32 1972.4 /OpenRV/_build/RV_DEPS_PYTHON3/install/include/python3.10/ceval.h:122:37: note: declared here
#32 1972.4   122 | Py_DEPRECATED(3.9) PyAPI_FUNC(void) PyEval_InitThreads(void);
#32 1972.4       |                                     ^~~~~~~~~~~~~~~~~~
#32 1972.4 [839/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_NO_DEBUG -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/app/QTBundle -I/OpenRV/src/lib/app/TwkApp -I/OpenRV/src/lib/audio/TwkAudio -I/OpenRV/src/lib/base/TwkMath -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/base/TwkUtil -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -DPYTHON_VERSION=\"3.10.13\" -MD -MT src/lib/app/QTBundle/CMakeFiles/QTBundle.dir/QTBundle.cpp.o -MF src/lib/app/QTBundle/CMakeFiles/QTBundle.dir/QTBundle.cpp.o.d -o src/lib/app/QTBundle/CMakeFiles/QTBundle.dir/QTBundle.cpp.o -c /OpenRV/src/lib/app/QTBundle/QTBundle.cpp
#32 1972.4 /OpenRV/src/lib/app/QTBundle/QTBundle.cpp: In member function 'void TwkApp::QTBundle::init()':
#32 1972.4 /OpenRV/src/lib/app/QTBundle/QTBundle.cpp:47:54: warning: 'QDir& QDir::operator=(const QString&)' is deprecated: Use QDir::setPath() instead [-Wdeprecated-declarations]
#32 1972.4    47 |         m_bin = QCoreApplication::applicationDirPath();
#32 1972.4       |                                                      ^
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:70,
#32 1972.4                  from /OpenRV/src/lib/app/QTBundle/QTBundle/QTBundle.h:11,
#32 1972.4                  from /OpenRV/src/lib/app/QTBundle/QTBundle.cpp:8:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdir.h:110:11: note: declared here
#32 1972.4   110 |     QDir &operator=(const QString &path);
#32 1972.4       |           ^~~~~~~~
#32 1972.4 /OpenRV/src/lib/app/QTBundle/QTBundle.cpp:48:33: warning: 'QDir& QDir::operator=(const QString&)' is deprecated: Use QDir::setPath() instead [-Wdeprecated-declarations]
#32 1972.4    48 |         m_home = QDir::homePath();
#32 1972.4       |                                 ^
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:70,
#32 1972.4                  from /OpenRV/src/lib/app/QTBundle/QTBundle/QTBundle.h:11,
#32 1972.4                  from /OpenRV/src/lib/app/QTBundle/QTBundle.cpp:8:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdir.h:110:11: note: declared here
#32 1972.4   110 |     QDir &operator=(const QString &path);
#32 1972.4       |           ^~~~~~~~
#32 1972.4 [875/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QToolBoxType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QToolBoxType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QToolBoxType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [876/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDateType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDateType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDateType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [877/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDockWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDockWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDockWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [878/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDialogType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDialogType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDialogType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [879/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDesktopWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDesktopWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDesktopWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [880/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDialType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDialType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDialType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [881/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDragEnterEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDragEnterEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDragEnterEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [882/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDragLeaveEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDragLeaveEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDragLeaveEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [883/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDirType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDirType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDirType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [884/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFileDeviceType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileDeviceType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileDeviceType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [885/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFileDialogType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileDialogType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileDialogType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [887/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWebEnginePageType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEnginePageType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEnginePageType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [888/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFileInfoType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileInfoType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileInfoType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [889/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDragMoveEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDragMoveEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDragMoveEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [891/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDropEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDropEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDropEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [892/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [894/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QEventLoopType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QEventLoopType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QEventLoopType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [895/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDesktopServicesType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDesktopServicesType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDesktopServicesType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [896/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QQuickWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QQuickWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QQuickWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [897/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFontType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFontType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFontType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [898/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFocusEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFocusEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFocusEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [899/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFormLayoutType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFormLayoutType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFormLayoutType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [900/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QGradientType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QGradientType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QGradientType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [901/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFrameType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFrameType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFrameType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [902/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QRadioButtonType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QRadioButtonType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QRadioButtonType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [903/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QGestureEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QGestureEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QGestureEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [904/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_Bridge.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/Bridge.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/Bridge.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [905/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_HintLayout.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/HintLayout.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/HintLayout.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [906/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_HintWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/HintWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/HintWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [907/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFileOpenEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileOpenEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileOpenEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [908/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QFileType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QFileType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [910/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QQmlContextType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QQmlContextType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QQmlContextType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [911/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractButtonType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractButtonType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractButtonType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [912/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractItemModelType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractItemModelType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractItemModelType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [913/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractItemViewType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractItemViewType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractItemViewType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [914/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractListModelType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractListModelType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractListModelType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [915/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractSliderType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractSliderType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractSliderType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [916/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractScrollAreaType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractScrollAreaType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractScrollAreaType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [917/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractSocketType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractSocketType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractSocketType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [918/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractSpinBoxType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractSpinBoxType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractSpinBoxType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [919/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QAbstractTableModelType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractTableModelType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QAbstractTableModelType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [920/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QActionGroupType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QActionGroupType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QActionGroupType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [921/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QActionType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QActionType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QActionType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [922/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QBitmapType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QBitmapType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QBitmapType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [923/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QApplicationType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QApplicationType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QApplicationType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [924/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QBoxLayoutType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QBoxLayoutType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QBoxLayoutType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [925/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QBrushType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QBrushType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QBrushType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [926/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QButtonGroupType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QButtonGroupType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QButtonGroupType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [927/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QByteArrayType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QByteArrayType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QByteArrayType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [928/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QCalendarType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QCalendarType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QCalendarType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [929/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QCheckBoxType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QCheckBoxType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QCheckBoxType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [930/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QCloseEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QCloseEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QCloseEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [931/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QColorType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QColorType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QColorType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [932/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QClipboardType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QClipboardType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QClipboardType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [933/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QColorDialogType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QColorDialogType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QColorDialogType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [934/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QColumnViewType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QColumnViewType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QColumnViewType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [935/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QComboBoxType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QComboBoxType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QComboBoxType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [936/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QConicalGradientType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QConicalGradientType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QConicalGradientType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [937/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QResizeEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QResizeEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QResizeEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [938/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QCompleterType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QCompleterType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QCompleterType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [939/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QContextMenuEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QContextMenuEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QContextMenuEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [940/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QDateTimeType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QDateTimeType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QDateTimeType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [941/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QCoreApplicationType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QCoreApplicationType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QCoreApplicationType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [942/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QHideEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QHideEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QHideEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [943/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QCursorType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QCursorType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QCursorType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [944/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QGroupBoxType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QGroupBoxType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QGroupBoxType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [945/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QGuiApplicationType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QGuiApplicationType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QGuiApplicationType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [946/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QGridLayoutType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QGridLayoutType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QGridLayoutType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [947/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QHBoxLayoutType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QHBoxLayoutType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QHBoxLayoutType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [948/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QScrollAreaType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QScrollAreaType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QScrollAreaType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [949/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QHeaderViewType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QHeaderViewType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QHeaderViewType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [950/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QShowEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QShowEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QShowEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [951/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QHelpEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QHelpEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QHelpEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [952/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QHostAddressType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QHostAddressType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QHostAddressType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [953/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QHoverEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QHoverEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QHoverEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [954/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QHostInfoType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QHostInfoType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QHostInfoType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [955/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QIODeviceType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QIODeviceType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QIODeviceType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [956/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QIconType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QIconType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QIconType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [957/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QImageType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QImageType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QImageType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [958/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QInputDialogType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QInputDialogType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QInputDialogType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [959/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QInputEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QInputEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QInputEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [960/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QItemSelectionModelType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QItemSelectionModelType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QItemSelectionModelType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [961/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QItemSelectionRangeType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QItemSelectionRangeType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QItemSelectionRangeType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [962/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QItemSelectionType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QItemSelectionType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QItemSelectionType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [963/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QKeyEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QKeyEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QKeyEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [964/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QJSEngineType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QJSEngineType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QJSEngineType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [965/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QKeySequenceType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QKeySequenceType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QKeySequenceType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [966/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QLayoutItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QLayoutItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QLayoutItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [967/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QLabelType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QLabelType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QLabelType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [968/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QLayoutType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QLayoutType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QLayoutType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [969/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QLinearGradientType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QLinearGradientType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QLinearGradientType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [970/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QLineEditType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QLineEditType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QLineEditType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [971/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QListViewType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QListViewType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QListViewType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [972/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QListWidgetItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QListWidgetItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QListWidgetItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [973/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QListWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QListWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QListWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [974/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMainWindowType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMainWindowType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMainWindowType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [975/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMarginsType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMarginsType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMarginsType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [976/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QLocalSocketType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QLocalSocketType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QLocalSocketType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [977/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMatrixType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMatrixType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMatrixType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [978/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMenuBarType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMenuBarType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMenuBarType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [979/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMenuType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMenuType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMenuType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [980/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QModelIndexType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QModelIndexType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QModelIndexType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [981/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMimeDataType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMimeDataType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMimeDataType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [982/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMouseEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMouseEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMouseEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [983/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QMoveEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QMoveEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QMoveEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [984/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QNetworkAccessManagerType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkAccessManagerType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkAccessManagerType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [985/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QNetworkCookieJarType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkCookieJarType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkCookieJarType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [986/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_MuQt.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/MuQt.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/MuQt.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [987/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QObjectType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [988/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QNetworkReplyType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkReplyType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkReplyType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [989/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QNetworkCookieType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkCookieType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QNetworkCookieType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [990/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPaintDevice.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaintDevice.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaintDevice.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [991/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPaintEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaintEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaintEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [992/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPaletteType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaletteType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaletteType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [993/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPaintDeviceType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaintDeviceType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPaintDeviceType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [994/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPixmapType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPixmapType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPixmapType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [995/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPointFType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPointFType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPointFType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [996/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPointType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPointType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPointType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [997/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_qtModuleIncludes.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/qtModuleIncludes.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/qtModuleIncludes.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [998/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPlainTextEditType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPlainTextEditType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPlainTextEditType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [999/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QProcessEnvironmentType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QProcessEnvironmentType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QProcessEnvironmentType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1000/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QProcessType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QProcessType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QProcessType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1001/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QProgressBarType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QProgressBarType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QProgressBarType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1002/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QQmlApplicationEngineType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QQmlApplicationEngineType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QQmlApplicationEngineType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1003/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QQmlEngineType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QQmlEngineType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QQmlEngineType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1004/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QPushButtonType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QPushButtonType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QPushButtonType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1005/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QQuickItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QQuickItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QQuickItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1006/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QRadialGradientType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QRadialGradientType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QRadialGradientType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1007/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QRectFType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QRectFType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QRectFType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1008/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QRectType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QRectType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QRectType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1009/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QRegExpType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QRegExpType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QRegExpType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1010/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QRegionType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QRegionType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QRegionType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1011/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QShortcutEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QShortcutEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QShortcutEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1012/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QSizeType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QSizeType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QSizeType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1013/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QSliderType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QSliderType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QSliderType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1014/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QSpacerItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QSpacerItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QSpacerItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1015/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QSplitterType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QSplitterType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QSplitterType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1016/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QSpinBoxType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QSpinBoxType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QSpinBoxType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1017/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QStackedLayoutType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QStackedLayoutType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QStackedLayoutType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1018/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QStackedWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QStackedWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QStackedWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1019/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QStandardItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QStandardItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QStandardItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1020/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QStandardItemModelType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QStandardItemModelType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QStandardItemModelType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1021/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QStatusBarType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QStatusBarType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QStatusBarType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1022/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QStringType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QStringType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QStringType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1023/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QSvgWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QSvgWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QSvgWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1024/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTabBarType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTabBarType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTabBarType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1025/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTabWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTabWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTabWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1026/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTableViewType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTableViewType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTableViewType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1027/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTableWidgetItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTableWidgetItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTableWidgetItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1028/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTableWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTableWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTableWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1029/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTabletEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTabletEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTabletEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1030/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTcpSocketType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTcpSocketType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTcpSocketType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1031/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextBlockType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextBlockType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextBlockType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1032/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTcpServerType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTcpServerType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTcpServerType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1033/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextBrowserType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextBrowserType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextBrowserType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1034/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextCodecType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextCodecType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextCodecType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1035/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextCursorType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextCursorType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextCursorType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1036/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextDocumentType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextDocumentType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextDocumentType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1037/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextEditType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextEditType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextEditType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1038/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextOptionType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextOptionType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextOptionType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1039/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTextStreamType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextStreamType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTextStreamType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1040/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTimeType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimeType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimeType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1041/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTimeZoneType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimeZoneType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimeZoneType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1042/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTimerEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimerEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimerEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1043/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTimerType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimerType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTimerType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1044/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QToolBarType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QToolBarType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QToolBarType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1045/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QToolButtonType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QToolButtonType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QToolButtonType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1046/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTouchEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTouchEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTouchEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1047/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTransformType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTransformType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTransformType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1048/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTreeViewType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTreeViewType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTreeViewType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1049/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTreeWidgetItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTreeWidgetItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTreeWidgetItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1050/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QUrlQueryType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QUrlQueryType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QUrlQueryType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1051/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QTreeWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QTreeWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QTreeWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1052/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QUdpSocketType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QUdpSocketType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QUdpSocketType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1053/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QUrlType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QUrlType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QUrlType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1054/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QVBoxLayoutType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QVBoxLayoutType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QVBoxLayoutType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1055/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QVariantType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QVariantType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QVariantType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1056/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWebChannelType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebChannelType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebChannelType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1057/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWebEngineCookieStoreType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineCookieStoreType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineCookieStoreType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1058/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWebEngineHistoryType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineHistoryType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineHistoryType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1059/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWebEngineSettingsType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineSettingsType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineSettingsType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1060/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWebEngineProfileType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineProfileType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineProfileType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1061/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWheelEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWheelEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWheelEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1062/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWebEngineViewType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineViewType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWebEngineViewType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1063/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWidgetItemType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWidgetItemType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWidgetItemType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1064/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWindowStateChangeEventType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWindowStateChangeEventType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWindowStateChangeEventType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1065/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWidgetActionType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWidgetActionType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWidgetActionType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1066/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QtColorTriangleType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QtColorTriangleType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QtColorTriangleType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1067/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_QWidgetType.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/QWidgetType.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/QWidgetType.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1068/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_qtGlobals.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/qtGlobals.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/qtGlobals.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1069/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_qtModule.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/qtModule.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/qtModule.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1071/2153] cd /OpenRV/_build/src/lib/mu/MuQt5 && /root/Qt/5.15.2/gcc_64/bin/moc -I /OpenRV/src/lib/mu/MuQt5 -o /OpenRV/src/lib/mu/MuQt5/MuQt5/generated/moc_qtUtils.cpp /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:0: Note: No relevant classes found. No output generated.
#32 1972.4 [1093/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/qtModule.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/qtModule.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/qtModule.cpp.o -c /OpenRV/src/lib/mu/MuQt5/qtModule.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/qtModule.cpp: In member function 'virtual void Mu::qtModule::load()':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/qtModule.cpp:651:48: warning: 'Qt::SystemLocaleDate' is deprecated: Use QLocale [-Wdeprecated-declarations]
#32 1972.4   651 |                                  Value(int(Qt::SystemLocaleDate))),
#32 1972.4       |                                                ^~~~~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qobjectdefs.h:48,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qobject.h:46,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractanimation.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/qtModule.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qnamespace.h:1279:9: note: declared here
#32 1972.4  1279 |         SystemLocaleDate Q_DECL_ENUMERATOR_DEPRECATED_X("Use QLocale"),
#32 1972.4       |         ^~~~~~~~~~~~~~~~
#32 1972.4 [1099/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QFontType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QFontType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QFontType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QFontType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QFontType.cpp: In function 'void* Mu::qt_QFont_lastResortFamily_string_QFont(Mu::Thread&, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:197:51: warning: 'QString QFont::lastResortFamily() const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   197 |         return makestring(c, arg0.lastResortFamily());
#32 1972.4       |                              ~~~~~~~~~~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qfont.h:295:27: note: declared here
#32 1972.4   295 |     QT_DEPRECATED QString lastResortFamily() const;
#32 1972.4       |                           ^~~~~~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QFontType.cpp: In function 'void* Mu::qt_QFont_lastResortFont_string_QFont(Mu::Thread&, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:205:49: warning: 'QString QFont::lastResortFont() const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   205 |         return makestring(c, arg0.lastResortFont());
#32 1972.4       |                              ~~~~~~~~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qfont.h:296:27: note: declared here
#32 1972.4   296 |     QT_DEPRECATED QString lastResortFont() const;
#32 1972.4       |                           ^~~~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QFontType.cpp: In member function 'virtual void Mu::QFontType::load()':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:1190:51: warning: 'QFont::OpenGLCompatible' is deprecated [-Wdeprecated-declarations]
#32 1972.4  1190 |                                  Value(int(QFont::OpenGLCompatible))),
#32 1972.4       |                                                   ^~~~~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qfont.h:84:9: note: declared here
#32 1972.4    84 |         OpenGLCompatible Q_DECL_ENUMERATOR_DEPRECATED = 0x0200,
#32 1972.4       |         ^~~~~~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:1190:51: warning: 'QFont::OpenGLCompatible' is deprecated [-Wdeprecated-declarations]
#32 1972.4  1190 |                                  Value(int(QFont::OpenGLCompatible))),
#32 1972.4       |                                                   ^~~~~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QFontType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qfont.h:84:9: note: declared here
#32 1972.4    84 |         OpenGLCompatible Q_DECL_ENUMERATOR_DEPRECATED = 0x0200,
#32 1972.4       |         ^~~~~~~~~~~~~~~~
#32 1972.4 [1102/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPixmapType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPixmapType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPixmapType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QPixmapType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QPixmapType.cpp: In function 'void* Mu::qt_QPixmap_transformed_QPixmap_QPixmap_QMatrix_int(Mu::Thread&, Mu::Pointer, Mu::Pointer, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QPixmapType.cpp:385:58: warning: 'QPixmap QPixmap::transformed(const QMatrix&, Qt::TransformationMode) const' is deprecated: Use transformed(const QTransform &, Qt::TransformationMode mode) [-Wdeprecated-declarations]
#32 1972.4   385 |         return makeqtype<QPixmapType>(c, arg0.transformed(arg1, arg2),
#32 1972.4       |                                          ~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qbrush.h:52,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qpen.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:49,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QPixmapType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qpixmap.h:134:13: note: declared here
#32 1972.4   134 |     QPixmap transformed(const QMatrix &, Qt::TransformationMode mode = Qt::FastTransformation) const;
#32 1972.4       |             ^~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QPixmapType.cpp: In function 'void* Mu::qt_QPixmap_trueMatrix_QMatrix_QMatrix_int_int(Mu::Thread&, Mu::Pointer, int, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QPixmapType.cpp:441:61: warning: 'static QMatrix QPixmap::trueMatrix(const QMatrix&, int, int)' is deprecated: Use trueMatrix(const QTransform &m, int w, int h) [-Wdeprecated-declarations]
#32 1972.4   441 |         return makeqtype<QMatrixType>(c, QPixmap::trueMatrix(arg0, arg1, arg2),
#32 1972.4       |                                          ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qbrush.h:52,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qpen.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:49,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QPixmapType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qpixmap.h:136:20: note: declared here
#32 1972.4   136 |     static QMatrix trueMatrix(const QMatrix &m, int w, int h);
#32 1972.4       |                    ^~~~~~~~~~
#32 1972.4 [1104/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QVariantType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QVariantType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QVariantType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp: In function 'bool Mu::qt_QVariant_operatorLT__bool_QVariant_QVariant(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:445:30: warning: 'bool QVariant::operator<(const QVariant&) const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   445 |         return arg0.operator<(arg1);
#32 1972.4       |                ~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractitemmodel.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:10,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qvariant.h:467:31: note: declared here
#32 1972.4   467 |     QT_DEPRECATED inline bool operator<(const QVariant &v) const
#32 1972.4       |                               ^~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp: In function 'bool Mu::qt_QVariant_operatorLT_EQ__bool_QVariant_QVariant(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:454:31: warning: 'bool QVariant::operator<=(const QVariant&) const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   454 |         return arg0.operator<=(arg1);
#32 1972.4       |                ~~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractitemmodel.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:10,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qvariant.h:469:31: note: declared here
#32 1972.4   469 |     QT_DEPRECATED inline bool operator<=(const QVariant &v) const
#32 1972.4       |                               ^~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp: In function 'bool Mu::qt_QVariant_operatorGT__bool_QVariant_QVariant(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:473:30: warning: 'bool QVariant::operator>(const QVariant&) const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   473 |         return arg0.operator>(arg1);
#32 1972.4       |                ~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractitemmodel.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:10,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qvariant.h:471:31: note: declared here
#32 1972.4   471 |     QT_DEPRECATED inline bool operator>(const QVariant &v) const
#32 1972.4       |                               ^~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp: In function 'bool Mu::qt_QVariant_operatorGT_EQ__bool_QVariant_QVariant(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:482:31: warning: 'bool QVariant::operator>=(const QVariant&) const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   482 |         return arg0.operator>=(arg1);
#32 1972.4       |                ~~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractitemmodel.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:10,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QVariantType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qvariant.h:473:31: note: declared here
#32 1972.4   473 |     QT_DEPRECATED inline bool operator>=(const QVariant &v) const
#32 1972.4       |                               ^~~~~~~~
#32 1972.4 [1105/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QUrlType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QUrlType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QUrlType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QUrlType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QUrlType.cpp: In function 'void* Mu::qt_QUrl_topLevelDomain_string_QUrl_int(Mu::Thread&, Mu::Pointer, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QUrlType.cpp:494:49: warning: 'QString QUrl::topLevelDomain(QUrl::ComponentFormattingOptions) const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   494 |         return makestring(c, arg0.topLevelDomain(arg1));
#32 1972.4       |                              ~~~~~~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:51,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QUrlType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qurl.h:238:27: note: declared here
#32 1972.4   238 |     QT_DEPRECATED QString topLevelDomain(ComponentFormattingOptions options = FullyDecoded) const;
#32 1972.4       |                           ^~~~~~~~~~~~~~
#32 1972.4 [1109/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QDateTimeType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QDateTimeType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QDateTimeType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QDateTimeType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateTimeType.cpp: In function 'void* Mu::qt_QDateTime_QDateTime_QDateTime_QDateTime_QDate(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateTimeType.cpp:113:54: warning: 'QDateTime::QDateTime(const QDate&)' is deprecated: Use QDate::startOfDay() [-Wdeprecated-declarations]
#32 1972.4   113 |     setqtype<QDateTimeType>(param_this,QDateTime(arg1));
#32 1972.4       |                                                      ^
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateTimeType.cpp:9:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:298:57: note: declared here
#32 1972.4   298 |     QT_DEPRECATED_X("Use QDate::startOfDay()") explicit QDateTime(const QDate &);
#32 1972.4       |                                                         ^~~~~~~~~
#32 1972.4 [1110/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QDateType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QDateType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QDateType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QDateType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp: In function 'void* Mu::qt_QDate_longDayName_string_int_int(Mu::Thread&, int, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:363:37: warning: 'static QString QDate::longDayName(int, QDate::MonthNameType)' is deprecated: Use QLocale::dayName or QLocale::standaloneDayName [-Wdeprecated-declarations]
#32 1972.4   363 |         return makestring(c, QDate::longDayName(arg0, arg1));
#32 1972.4       |                                     ^~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:112:24: note: declared here
#32 1972.4   112 |         static QString longDayName(int weekday, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:363:48: warning: 'static QString QDate::longDayName(int, QDate::MonthNameType)' is deprecated: Use QLocale::dayName or QLocale::standaloneDayName [-Wdeprecated-declarations]
#32 1972.4   363 |         return makestring(c, QDate::longDayName(arg0, arg1));
#32 1972.4       |                              ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:112:24: note: declared here
#32 1972.4   112 |         static QString longDayName(int weekday, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp: In function 'void* Mu::qt_QDate_longMonthName_string_int_int(Mu::Thread&, int, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:373:37: warning: 'static QString QDate::longMonthName(int, QDate::MonthNameType)' is deprecated: Use QLocale::monthName or QLocale::standaloneMonthName [-Wdeprecated-declarations]
#32 1972.4   373 |         return makestring(c, QDate::longMonthName(arg0, arg1));
#32 1972.4       |                                     ^~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:110:24: note: declared here
#32 1972.4   110 |         static QString longMonthName(int month, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:373:50: warning: 'static QString QDate::longMonthName(int, QDate::MonthNameType)' is deprecated: Use QLocale::monthName or QLocale::standaloneMonthName [-Wdeprecated-declarations]
#32 1972.4   373 |         return makestring(c, QDate::longMonthName(arg0, arg1));
#32 1972.4       |                              ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:110:24: note: declared here
#32 1972.4   110 |         static QString longMonthName(int month, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp: In function 'void* Mu::qt_QDate_shortDayName_string_int_int(Mu::Thread&, int, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:383:37: warning: 'static QString QDate::shortDayName(int, QDate::MonthNameType)' is deprecated: Use QLocale::dayName or QLocale::standaloneDayName [-Wdeprecated-declarations]
#32 1972.4   383 |         return makestring(c, QDate::shortDayName(arg0, arg1));
#32 1972.4       |                                     ^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:108:24: note: declared here
#32 1972.4   108 |         static QString shortDayName(int weekday, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:383:49: warning: 'static QString QDate::shortDayName(int, QDate::MonthNameType)' is deprecated: Use QLocale::dayName or QLocale::standaloneDayName [-Wdeprecated-declarations]
#32 1972.4   383 |         return makestring(c, QDate::shortDayName(arg0, arg1));
#32 1972.4       |                              ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:108:24: note: declared here
#32 1972.4   108 |         static QString shortDayName(int weekday, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp: In function 'void* Mu::qt_QDate_shortMonthName_string_int_int(Mu::Thread&, int, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:393:37: warning: 'static QString QDate::shortMonthName(int, QDate::MonthNameType)' is deprecated: Use QLocale::monthName or QLocale::standaloneMonthName [-Wdeprecated-declarations]
#32 1972.4   393 |         return makestring(c, QDate::shortMonthName(arg0, arg1));
#32 1972.4       |                                     ^~~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:106:24: note: declared here
#32 1972.4   106 |         static QString shortMonthName(int month, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:393:51: warning: 'static QString QDate::shortMonthName(int, QDate::MonthNameType)' is deprecated: Use QLocale::monthName or QLocale::standaloneMonthName [-Wdeprecated-declarations]
#32 1972.4   393 |         return makestring(c, QDate::shortMonthName(arg0, arg1));
#32 1972.4       |                              ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QDateType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:106:24: note: declared here
#32 1972.4   106 |         static QString shortMonthName(int month, MonthNameType type = DateFormat);
#32 1972.4       |                        ^~~~~~~~~~~~~~
#32 1972.4 [1111/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTimeType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTimeType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTimeType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp: In function 'int Mu::qt_QTime_elapsed_int_QTime(Mu::Thread&, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp:118:28: warning: 'int QTime::elapsed() const' is deprecated: Use QElapsedTimer instead [-Wdeprecated-declarations]
#32 1972.4   118 |         return arg0.elapsed();
#32 1972.4       |                ~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:237:54: note: declared here
#32 1972.4   237 |     QT_DEPRECATED_X("Use QElapsedTimer instead") int elapsed() const;
#32 1972.4       |                                                      ^~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp: In function 'int Mu::qt_QTime_restart_int_QTime(Mu::Thread&, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp:178:28: warning: 'int QTime::restart()' is deprecated: Use QElapsedTimer instead [-Wdeprecated-declarations]
#32 1972.4   178 |         return arg0.restart();
#32 1972.4       |                ~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:236:54: note: declared here
#32 1972.4   236 |     QT_DEPRECATED_X("Use QElapsedTimer instead") int restart();
#32 1972.4       |                                                      ^~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp: In function 'void Mu::qt_QTime_start_void_QTime(Mu::Thread&, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp:215:19: warning: 'void QTime::start()' is deprecated: Use QElapsedTimer instead [-Wdeprecated-declarations]
#32 1972.4   215 |         arg0.start();
#32 1972.4       |         ~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborvalue.h:44,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qcborarray.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:38,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QTimeType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qdatetime.h:235:55: note: declared here
#32 1972.4   235 |     QT_DEPRECATED_X("Use QElapsedTimer instead") void start();
#32 1972.4       |                                                       ^~~~~
#32 1972.4 [1114/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QByteArrayType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QByteArrayType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QByteArrayType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp: In function 'void* Mu::qt_QByteArray_append_QByteArray_QByteArray_string(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:101:56: warning: 'QByteArray& QByteArray::append(const QString&)' is deprecated: Use QString's toUtf8(), toLatin1() or toLocal8Bit() [-Wdeprecated-declarations]
#32 1972.4   101 |         return makeqtype<QByteArrayType>(c, arg0.append(arg1), "qt.QByteArray");
#32 1972.4       |                                             ~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qobject.h:47,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractanimation.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:1507:20: note: declared here
#32 1972.4  1507 | inline QByteArray &QByteArray::append(const QString &s)
#32 1972.4       |                    ^~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp: In function 'int Mu::qt_QByteArray_indexOf_int_QByteArray_string_int(Mu::Thread&, Mu::Pointer, Mu::Pointer, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:187:28: warning: 'int QByteArray::indexOf(const QString&, int) const' is deprecated: Use QString's toUtf8(), toLatin1() or toLocal8Bit() [-Wdeprecated-declarations]
#32 1972.4   187 |         return arg0.indexOf(arg1, arg2);
#32 1972.4       |                ~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qobject.h:47,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractanimation.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:1519:12: note: declared here
#32 1972.4  1519 | inline int QByteArray::indexOf(const QString &s, int from) const
#32 1972.4       |            ^~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp: In function 'void* Mu::qt_QByteArray_insert_QByteArray_QByteArray_int_string(Mu::Thread&, Mu::Pointer, int, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:210:56: warning: 'QByteArray& QByteArray::insert(int, const QString&)' is deprecated: Use QString's toUtf8(), toLatin1() or toLocal8Bit() [-Wdeprecated-declarations]
#32 1972.4   210 |         return makeqtype<QByteArrayType>(c, arg0.insert(arg1, arg2),
#32 1972.4       |                                             ~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qobject.h:47,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractanimation.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:1509:20: note: declared here
#32 1972.4  1509 | inline QByteArray &QByteArray::insert(int i, const QString &s)
#32 1972.4       |                    ^~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp: In function 'int Mu::qt_QByteArray_lastIndexOf_int_QByteArray_string_int(Mu::Thread&, Mu::Pointer, Mu::Pointer, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:249:32: warning: 'int QByteArray::lastIndexOf(const QString&, int) const' is deprecated: Use QString's toUtf8(), toLatin1() or toLocal8Bit() [-Wdeprecated-declarations]
#32 1972.4   249 |         return arg0.lastIndexOf(arg1, arg2);
#32 1972.4       |                ~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qobject.h:47,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractanimation.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:1521:12: note: declared here
#32 1972.4  1521 | inline int QByteArray::lastIndexOf(const QString &s, int from) const
#32 1972.4       |            ^~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp: In function 'void* Mu::qt_QByteArray_replace_QByteArray_QByteArray_string_QByteArray(Mu::Thread&, Mu::Pointer, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:366:57: warning: 'QByteArray& QByteArray::replace(const QString&, const QByteArray&)' is deprecated: Use QString's toUtf8(), toLatin1() or toLocal8Bit() [-Wdeprecated-declarations]
#32 1972.4   366 |         return makeqtype<QByteArrayType>(c, arg0.replace(arg1, arg2),
#32 1972.4       |                                             ~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qobject.h:47,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractanimation.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:1515:20: note: declared here
#32 1972.4  1515 | inline QByteArray &QByteArray::replace(const QString &before, const QByteArray &after)
#32 1972.4       |                    ^~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp: In function 'void* Mu::qt_QByteArray_operatorPlus_EQ__QByteArray_QByteArray_string(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:547:60: warning: 'QByteArray& QByteArray::operator+=(const QString&)' is deprecated: Use QString's toUtf8(), toLatin1() or toLocal8Bit() [-Wdeprecated-declarations]
#32 1972.4   547 |         return makeqtype<QByteArrayType>(c, arg0.operator+=(arg1),
#32 1972.4       |                                             ~~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qobject.h:47,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractanimation.h:43,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QByteArrayType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qstring.h:1517:20: note: declared here
#32 1972.4  1517 | inline QByteArray &QByteArray::operator+=(const QString &s)
#32 1972.4       |                    ^~~~~~~~~~
#32 1972.4 [1115/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QModelIndexType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QModelIndexType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QModelIndexType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QModelIndexType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QModelIndexType.cpp: In function 'void* Mu::qt_QModelIndex_child_QModelIndex_QModelIndex_int_int(Mu::Thread&, Mu::Pointer, int, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QModelIndexType.cpp:93:56: warning: 'QModelIndex QModelIndex::child(int, int) const' is deprecated: Use QAbstractItemModel::index [-Wdeprecated-declarations]
#32 1972.4    93 |         return makeqtype<QModelIndexType>(c, arg0.child(arg1, arg2),
#32 1972.4       |                                              ~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:10,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QModelIndexType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qabstractitemmodel.h:455:20: note: declared here
#32 1972.4   455 | inline QModelIndex QModelIndex::child(int arow, int acolumn) const
#32 1972.4       |                    ^~~~~~~~~~~
#32 1972.4 [1116/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QImageType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QImageType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QImageType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QImageType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QImageType.cpp: In function 'int Mu::qt_QImage_byteCount_int_QImage(Mu::Thread&, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QImageType.cpp:135:30: warning: 'int QImage::byteCount() const' is deprecated: Use sizeInBytes [-Wdeprecated-declarations]
#32 1972.4   135 |         return arg0.byteCount();
#32 1972.4       |                ~~~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qbrush.h:51,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qpen.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:49,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QImageType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qimage.h:221:44: note: declared here
#32 1972.4   221 |     QT_DEPRECATED_X("Use sizeInBytes") int byteCount() const;
#32 1972.4       |                                            ^~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QImageType.cpp: In function 'void* Mu::qt_QImage_transformed_QImage_QImage_QMatrix_int(Mu::Thread&, Mu::Pointer, Mu::Pointer, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QImageType.cpp:657:57: warning: 'QImage QImage::transformed(const QMatrix&, Qt::TransformationMode) const' is deprecated: Use transformed(const QTransform &matrix, Qt::TransformationMode mode) [-Wdeprecated-declarations]
#32 1972.4   657 |         return makeqtype<QImageType>(c, arg0.transformed(arg1, arg2),
#32 1972.4       |                                         ~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qbrush.h:51,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qpen.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:49,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QImageType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qimage.h:288:12: note: declared here
#32 1972.4   288 |     QImage transformed(const QMatrix &matrix, Qt::TransformationMode mode = Qt::FastTransformation) const;
#32 1972.4       |            ^~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QImageType.cpp: In function 'void* Mu::qt_QImage_trueMatrix_QMatrix_QMatrix_int_int(Mu::Thread&, Mu::Pointer, int, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QImageType.cpp:729:60: warning: 'static QMatrix QImage::trueMatrix(const QMatrix&, int, int)' is deprecated: trueMatrix(const QTransform &, int w, int h) [-Wdeprecated-declarations]
#32 1972.4   729 |         return makeqtype<QMatrixType>(c, QImage::trueMatrix(arg0, arg1, arg2),
#32 1972.4       |                                          ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qbrush.h:51,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qpen.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:49,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QImageType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qimage.h:290:20: note: declared here
#32 1972.4   290 |     static QMatrix trueMatrix(const QMatrix &, int w, int h);
#32 1972.4       |                    ^~~~~~~~~~
#32 1972.4 [1117/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QLayoutItemType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QLayoutItemType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QLayoutItemType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QLayoutItemType.cpp
#32 1972.4 In file included from /OpenRV/src/lib/mu/MuQt5/QLayoutItemType.cpp:7:
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h: In instantiation of 'T Mu::defaultValue() [with T = QFlags<Qt::Orientation>]':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QLayoutItemType.cpp:96:50:   required from here
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:478:60: warning: 'constexpr QFlags<T>::QFlags(QFlags<T>::Zero) [with Enum = Qt::Orientation; QFlags<T>::Zero = int QFlags<Qt::Orientation>::Private::*]' is deprecated: Use default constructor instead [-Wdeprecated-declarations]
#32 1972.4   478 |     template <typename T> inline T defaultValue() { return T(0); }
#32 1972.4       |                                                            ^~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qglobal.h:1304,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:4,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QLayoutItemType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qflags.h:123:80: note: declared here
#32 1972.4   123 |     QT_DEPRECATED_X("Use default constructor instead") Q_DECL_CONSTEXPR inline QFlags(Zero) noexcept : i(0) {}
#32 1972.4       |                                                                                ^~~~~~
#32 1972.4 [1119/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTextOptionType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTextOptionType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTextOptionType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QTextOptionType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTextOptionType.cpp: In function 'void Mu::qt_QTextOption_setTabStop_void_QTextOption_double(Mu::Thread&, Mu::Pointer, double)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTextOptionType.cpp:135:24: warning: 'void QTextOption::setTabStop(qreal)' is deprecated [-Wdeprecated-declarations]
#32 1972.4   135 |         arg0.setTabStop(arg1);
#32 1972.4       |         ~~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:51,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QTextOptionType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qtextoption.h:158:13: note: declared here
#32 1972.4   158 | inline void QTextOption::setTabStop(qreal atabStop)
#32 1972.4       |             ^~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTextOptionType.cpp: In function 'double Mu::qt_QTextOption_tabStop_double_QTextOption(Mu::Thread&, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTextOptionType.cpp:174:28: warning: 'qreal QTextOption::tabStop() const' is deprecated [-Wdeprecated-declarations]
#32 1972.4   174 |         return arg0.tabStop();
#32 1972.4       |                ~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextformat.h:51,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qtextlayout.h:50,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/qabstracttextdocumentlayout.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtGui/QtGui:5,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:13,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QTextOptionType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtGui/qtextoption.h:122:32: note: declared here
#32 1972.4   122 |     QT_DEPRECATED inline qreal tabStop() const { return tabStopDistance(); }
#32 1972.4       |                                ^~~~~~~
#32 1972.4 [1125/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QWidgetType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QWidgetType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QWidgetType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QWidgetType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QWidgetType.cpp: In function 'void* Mu::_n_QWidget_getContentsMargins(const Mu::Node&, Mu::Thread&)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QWidgetType.cpp:3170:33: warning: 'void QWidget::getContentsMargins(int*, int*, int*, int*) const' is deprecated: use contentsMargins() [-Wdeprecated-declarations]
#32 1972.4  3170 |         arg0->getContentsMargins(&tuple->a, &tuple->b, &tuple->c, &tuple->d);
#32 1972.4       |         ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtWidgets/qabstractbutton.h:46,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtWidgets/QtWidgets:6,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QWidgetType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtWidgets/qwidget.h:530:10: note: declared here
#32 1972.4   530 |     void getContentsMargins(int *left, int *top, int *right, int *bottom) const;
#32 1972.4       |          ^~~~~~~~~~~~~~~~~~
#32 1972.4 [1170/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTreeWidgetType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTreeWidgetType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QTreeWidgetType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QTreeWidgetType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTreeWidgetType.cpp: In function 'bool Mu::qt_QTreeWidget_isFirstItemColumnSpanned_bool_QTreeWidget_QTreeWidgetItem(Mu::Thread&, Mu::Pointer, Mu::Pointer)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTreeWidgetType.cpp:1108:46: warning: 'bool QTreeWidget::isFirstItemColumnSpanned(const QTreeWidgetItem*) const' is deprecated: Use QTreeWidgetItem::isFirstColumnSpanned() instead [-Wdeprecated-declarations]
#32 1972.4  1108 |         return arg0->isFirstItemColumnSpanned(arg1);
#32 1972.4       |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtWidgets/QtWidgets:297,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QTreeWidgetType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtWidgets/qtreewidget.h:340:10: note: declared here
#32 1972.4   340 |     bool isFirstItemColumnSpanned(const QTreeWidgetItem *item) const;
#32 1972.4       |          ^~~~~~~~~~~~~~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTreeWidgetType.cpp: In function 'void Mu::qt_QTreeWidget_setFirstItemColumnSpanned_void_QTreeWidget_QTreeWidgetItem_bool(Mu::Thread&, Mu::Pointer, Mu::Pointer, bool)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QTreeWidgetType.cpp:1244:40: warning: 'void QTreeWidget::setFirstItemColumnSpanned(const QTreeWidgetItem*, bool)' is deprecated: Use QTreeWidgetItem::setFirstColumnSpanned() instead [-Wdeprecated-declarations]
#32 1972.4  1244 |         arg0->setFirstItemColumnSpanned(arg1, arg2);
#32 1972.4       |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtWidgets/QtWidgets:297,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QTreeWidgetType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtWidgets/qtreewidget.h:342:10: note: declared here
#32 1972.4   342 |     void setFirstItemColumnSpanned(const QTreeWidgetItem *item, bool span);
#32 1972.4       |          ^~~~~~~~~~~~~~~~~~~~~~~~~
#32 1972.4 [1173/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QApplicationType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QApplicationType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QApplicationType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp: In function 'int Mu::qt_QApplication_colorSpec_int(Mu::Thread&)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:168:30: warning: 'static int QApplication::colorSpec()' is deprecated [-Wdeprecated-declarations]
#32 1972.4   168 |         return QApplication::colorSpec();
#32 1972.4       |                              ^~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtWidgets/QtWidgets:24,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtWidgets/qapplication.h:105:30: note: declared here
#32 1972.4   105 |     QT_DEPRECATED static int colorSpec();
#32 1972.4       |                              ^~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:168:39: warning: 'static int QApplication::colorSpec()' is deprecated [-Wdeprecated-declarations]
#32 1972.4   168 |         return QApplication::colorSpec();
#32 1972.4       |                ~~~~~~~~~~~~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtWidgets/QtWidgets:24,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtWidgets/qapplication.h:105:30: note: declared here
#32 1972.4   105 |     QT_DEPRECATED static int colorSpec();
#32 1972.4       |                              ^~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp: In function 'void Mu::qt_QApplication_setColorSpec_void_int(Mu::Thread&, int)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:235:23: warning: 'static void QApplication::setColorSpec(int)' is deprecated [-Wdeprecated-declarations]
#32 1972.4   235 |         QApplication::setColorSpec(arg0);
#32 1972.4       |                       ^~~~~~~~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtWidgets/QtWidgets:24,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtWidgets/qapplication.h:106:31: note: declared here
#32 1972.4   106 |     QT_DEPRECATED static void setColorSpec(int);
#32 1972.4       |                               ^~~~~~~~~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:235:35: warning: 'static void QApplication::setColorSpec(int)' is deprecated [-Wdeprecated-declarations]
#32 1972.4   235 |         QApplication::setColorSpec(arg0);
#32 1972.4       |         ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtWidgets/QtWidgets:24,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QApplicationType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtWidgets/qapplication.h:106:31: note: declared here
#32 1972.4   106 |     QT_DEPRECATED static void setColorSpec(int);
#32 1972.4       |                               ^~~~~~~~~~~~
#32 1972.4 [1174/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QCoreApplicationType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QCoreApplicationType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QCoreApplicationType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QCoreApplicationType.cpp
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QCoreApplicationType.cpp: In function 'void Mu::qt_QCoreApplication_flush_void(Mu::Thread&)':
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QCoreApplicationType.cpp:336:27: warning: 'static void QCoreApplication::flush()' is deprecated [-Wdeprecated-declarations]
#32 1972.4   336 |         QCoreApplication::flush();
#32 1972.4       |                           ^~~~~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcommandlineparser.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:55,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QCoreApplicationType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qcoreapplication.h:169:31: note: declared here
#32 1972.4   169 |     QT_DEPRECATED static void flush();
#32 1972.4       |                               ^~~~~
#32 1972.4 /OpenRV/src/lib/mu/MuQt5/QCoreApplicationType.cpp:336:32: warning: 'static void QCoreApplication::flush()' is deprecated [-Wdeprecated-declarations]
#32 1972.4   336 |         QCoreApplication::flush();
#32 1972.4       |         ~~~~~~~~~~~~~~~~~~~~~~~^~
#32 1972.4 In file included from /root/Qt/5.15.2/gcc_64/include/QtCore/qcommandlineparser.h:45,
#32 1972.4                  from /root/Qt/5.15.2/gcc_64/include/QtCore/QtCore:55,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/QObjectType.h:12,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/MuQt5/qtUtils.h:14,
#32 1972.4                  from /OpenRV/src/lib/mu/MuQt5/QCoreApplicationType.cpp:7:
#32 1972.4 /root/Qt/5.15.2/gcc_64/include/QtCore/qcoreapplication.h:169:31: note: declared here
#32 1972.4   169 |     QT_DEPRECATED static void flush();
#32 1972.4       |                               ^~~~~
#32 1972.4 FAILED: cmake/dependencies/RV_DEPS_AJA-prefix/src/RV_DEPS_AJA-stamp/RV_DEPS_AJA-build RV_DEPS_AJA/install/lib64/libajantv2.so RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedtls.a RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedx509.a RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedcrypto.a /OpenRV/_build/cmake/dependencies/RV_DEPS_AJA-prefix/src/RV_DEPS_AJA-stamp/RV_DEPS_AJA-build /OpenRV/_build/RV_DEPS_AJA/install/lib64/libajantv2.so /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedtls.a /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedx509.a /OpenRV/_build/RV_DEPS_AJA/build/ajantv2/mbedtls-install/lib64/libmbedcrypto.a 
#32 1972.4 cd /OpenRV/_build/RV_DEPS_AJA/build && /usr/local/bin/cmake --build /OpenRV/_build/RV_DEPS_AJA/build --config Release -j8 && /usr/local/bin/cmake -E touch /OpenRV/_build/cmake/dependencies/RV_DEPS_AJA-prefix/src/RV_DEPS_AJA-stamp/RV_DEPS_AJA-build
#32 1972.4 [1176/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QLabelType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QLabelType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QLabelType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QLabelType.cpp
#32 1972.4 [1177/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPlainTextEditType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPlainTextEditType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPlainTextEditType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QPlainTextEditType.cpp
#32 1972.4 [1178/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QProgressBarType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QProgressBarType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QProgressBarType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QProgressBarType.cpp
#32 1972.4 [1179/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QMenuBarType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QMenuBarType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QMenuBarType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QMenuBarType.cpp
#32 1972.4 [1180/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QScrollAreaType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QScrollAreaType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QScrollAreaType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QScrollAreaType.cpp
#32 1972.4 [1181/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStackedWidgetType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStackedWidgetType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStackedWidgetType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QStackedWidgetType.cpp
#32 1972.4 [1182/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSplitterType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSplitterType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSplitterType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QSplitterType.cpp
#32 1972.4 [1183/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSpinBoxType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSpinBoxType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSpinBoxType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QSpinBoxType.cpp
#32 1972.4 [1184/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStatusBarType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStatusBarType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStatusBarType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QStatusBarType.cpp
#32 1972.4 ninja: build stopped: subcommand failed.
#32 1972.4 
#32 ERROR: process "/bin/bash -c cmake     --build /OpenRV/_build     --config Release     -v     --target main_executable" did not complete successfully: exit code: 1
------
 > [28/34] RUN cmake     --build /OpenRV/_build     --config Release     -v     --target main_executable:
1972.4 [1177/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPlainTextEditType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPlainTextEditType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QPlainTextEditType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QPlainTextEditType.cpp
1972.4 [1178/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QProgressBarType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QProgressBarType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QProgressBarType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QProgressBarType.cpp
1972.4 [1179/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QMenuBarType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QMenuBarType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QMenuBarType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QMenuBarType.cpp
1972.4 [1180/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QScrollAreaType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QScrollAreaType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QScrollAreaType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QScrollAreaType.cpp
1972.4 [1181/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStackedWidgetType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStackedWidgetType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStackedWidgetType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QStackedWidgetType.cpp
1972.4 [1182/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSplitterType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSplitterType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSplitterType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QSplitterType.cpp
1972.4 [1183/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSpinBoxType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSpinBoxType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QSpinBoxType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QSpinBoxType.cpp
1972.4 [1184/2153] /usr/bin/c++ -DQT_CORE_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_POSITIONING_LIB -DQT_PRINTSUPPORT_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB -DQT_QUICKWIDGETS_LIB -DQT_QUICK_LIB -DQT_SVG_LIB -DQT_TESTCASE_BUILDDIR=\"/OpenRV/_build\" -DQT_TESTLIB_LIB -DQT_UITOOLS_LIB -DQT_WEBCHANNEL_LIB -DQT_WEBENGINECORE_LIB -DQT_WEBENGINEWIDGETS_LIB -DQT_WEBENGINE_LIB -DQT_WIDGETS_LIB -DQT_XMLPATTERNS_LIB -DQT_XML_LIB -DRV_FFMPEG_6 -DRV_VFX_CY2023 -I/OpenRV/src/lib/mu/MuQt5 -I/OpenRV/_build/src/lib/mu/MuQt5 -I/OpenRV/src/pub/qtcolortriangle -I/OpenRV/src/lib/mu/Mu -I/OpenRV/src/lib/base/stl_ext -I/OpenRV/src/pub/nedmalloc -I/OpenRV/src/lib/mu/MuLang -I/OpenRV/src/lib/qt/TwkQtCoreUtil -I/OpenRV/src/lib/base/TwkUtil -I/OpenRV/src/lib/base/TwkExc -I/OpenRV/src/lib/base/TwkMath -isystem /OpenRV/_build/src/lib/mu/MuQt5/MuQt5_autogen/include -isystem /root/Qt/5.15.2/gcc_64/include -isystem /root/Qt/5.15.2/gcc_64/include/QtCore -isystem /root/Qt/5.15.2/gcc_64/./mkspecs/linux-g++ -isystem /root/Qt/5.15.2/gcc_64/include/QtGui -isystem /root/Qt/5.15.2/gcc_64/include/QtNetwork -isystem /root/Qt/5.15.2/gcc_64/include/QtOpenGL -isystem /root/Qt/5.15.2/gcc_64/include/QtWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtQml -isystem /root/Qt/5.15.2/gcc_64/include/QtQuick -isystem /root/Qt/5.15.2/gcc_64/include/QtQmlModels -isystem /root/Qt/5.15.2/gcc_64/include/QtQuickWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtSvg -isystem /root/Qt/5.15.2/gcc_64/include/QtTest -isystem /root/Qt/5.15.2/gcc_64/include/QtWebChannel -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngine -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineCore -isystem /root/Qt/5.15.2/gcc_64/include/QtPositioning -isystem /root/Qt/5.15.2/gcc_64/include/QtWebEngineWidgets -isystem /root/Qt/5.15.2/gcc_64/include/QtPrintSupport -isystem /root/Qt/5.15.2/gcc_64/include/QtXml -isystem /root/Qt/5.15.2/gcc_64/include/QtXmlPatterns -isystem /OpenRV/_build/RV_DEPS_GC/install/include -isystem /OpenRV/_build/RV_DEPS_IMATH/install/include/Imath -isystem /root/Qt/5.15.2/gcc_64/include/QtUiTools -isystem /OpenRV/_build/RV_DEPS_BOOST/install/include -isystem /OpenRV/_build/RV_DEPS_SPDLOG/install/include -O3 -DNDEBUG -std=gnu++17 -DARCH_IA32_64 -DPLATFORM_LINUX -DTWK_LITTLE_ENDIAN -D__LITTLE_ENDIAN__ -DTWK_NO_SGI_BYTE_ORDER -DGL_GLEXT_PROTOTYPES -DPLATFORM_OPENGL=1 -DMAJOR_VERSION=3 -DMINOR_VERSION=0 -DREVISION_NUMBER=0 -fPIC -fno-schedule-insns -fno-schedule-insns2 -msse -msse2 -mmmx -mfpmath=sse -DNDEBUG -O3 -MD -MT src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStatusBarType.cpp.o -MF src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStatusBarType.cpp.o.d -o src/lib/mu/MuQt5/CMakeFiles/MuQt5.dir/QStatusBarType.cpp.o -c /OpenRV/src/lib/mu/MuQt5/QStatusBarType.cpp
1972.4 ninja: build stopped: subcommand failed.
1972.4 
------

 1 warning found (use docker --debug to expand):
 - SecretsUsedInArgOrEnv: Do not use ARG or ENV instructions for sensitive data (ARG "QT_PASSWORD") (line 13)
Dockerfile:164
--------------------
 163 |         -DRV_DEPS_QT5_LOCATION=$QT_ROOT/5.15.2/gcc_64
 164 | >>> RUN cmake \
 165 | >>>     --build /OpenRV/_build \
 166 | >>>     --config Release \
 167 | >>>     -v \
 168 | >>>     --target main_executable
 169 |     
--------------------
ERROR: failed to solve: process "/bin/bash -c cmake     --build /OpenRV/_build     --config Release     -v     --target main_executable" did not complete successfully: exit code: 1

real    52m28.422s
user    0m2.988s
sys     0m1.994s

```