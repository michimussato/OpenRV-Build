<!-- TOC -->
* [Apptainer](#apptainer)
  * [Arch](#arch)
  * [Debian](#debian)
* [Red Hat](#red-hat)
* [OpenRV](#openrv)
  * [Resources](#resources)
    * [Alternate Approaches](#alternate-approaches)
  * [Build](#build)
  * [Non Free Codecs](#non-free-codecs)
  * [Enable Non Free Codecs](#enable-non-free-codecs)
    * [AAC](#aac)
    * [HEVC](#hevc)
<!-- TOC -->

---

# Apptainer

Install

## Arch

```shell
sudo pacman -Syy apptainer
```

## Debian

```shell
sudo apt-get install apptainer
```

# Red Hat

```shell
sudo dnf install apptainer
```

# OpenRV

## Resources

- https://github.com/AcademySoftwareFoundation/OpenRV
- https://deepwiki.com/AcademySoftwareFoundation/OpenRV/2.2-building-openrv
- https://aswf-openrv.readthedocs.io/en/latest/

### Alternate Approaches

- https://github.com/col-one/OpenRV-Dockerfile
- https://github.com/rubikstriangle/OpenRV-Rocky9-Docker

## Build

```
time apptainer build --notest --build-arg-file ../.env --warn-unused-build-args OpenRV.sif OpenRV.def
```

## Non Free Codecs

Decoders:
- [NON_FREE_DECODERS_TO_DISABLE](https://github.com/AcademySoftwareFoundation/OpenRV/blob/c9932773d3a8953ec28d19a591f2fd892179da09/cmake/dependencies/ffmpeg.cmake#L277)
Encoders:
- [NON_FREE_ENCODERS_TO_DISABLE](https://github.com/AcademySoftwareFoundation/OpenRV/blob/c9932773d3a8953ec28d19a591f2fd892179da09/cmake/dependencies/ffmpeg.cmake#L308)

Refs: 
- https://github.com/AcademySoftwareFoundation/OpenRV/blob/c9932773d3a8953ec28d19a591f2fd892179da09/src/lib/image/mio_ffmpeg/init.cpp#L39

## Enable Non Free Codecs

https://github.com/AcademySoftwareFoundation/OpenRV/tree/main?tab=readme-ov-file#how-to-enable-non-free-ffmpeg-codecs

### AAC

```
rvcfg -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="aac" -DRV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE="aac"
```

### HEVC

```
rvcfg -DRV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE="hevc"
```
