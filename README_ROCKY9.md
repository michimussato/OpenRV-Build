<!-- TOC -->
* [Rocky 9](#rocky-9)
  * [Setup](#setup)
    * [Virtual Box](#virtual-box)
      * [Guest Additions](#guest-additions)
    * [Dependencies](#dependencies)
    * [Repo](#repo)
  * [Apptainer](#apptainer)
    * [.env](#env)
    * [Image](#image)
      * [Build](#build)
      * [Help](#help)
    * [Container](#container)
      * [Run](#run)
<!-- TOC -->

---

# Rocky 9

## Setup

### Virtual Box

#### Guest Additions

> This is probably not working (to be confirmed):
> ```
> 1. Installing the latest virtual box 7.1.4
> 2. sudo dnf groupinstall "Development Tools"
> 3. sudo dnf install kernel-devel elfutils-libelf-devel
> 4. Install VBox_GAs_7.1.4 VBoxLinuxAdditions.run
> ```

Reference: https://computingforgeeks.com/install-virtualbox-guest-additions-rocky/

```shell
sudo dnf install epel-release -y
sudo dnf install dkms kernel-devel kernel-headers gcc make bzip2 perl elfutils-libelf-devel
```

```
$ rpm -q kernel-devel	
kernel-devel-5.14.0-70.17.1.el9_0.x86_64

$ uname -r
5.14.0-70.13.1.el9_0.x86_64
```

```shell
sudo dnf update -y
sudo reboot now
```

### Dependencies

```shell
sudo dnf install time apptainer -y
```

### Repo

```shell
mkdir -p ~/git/repos
cd ~/git/repos/
git clone https://github.com/michimussato/OpenRV-Build.git
cd OpenRV-Build
```

## Apptainer

### .env

Create `.env` file first (see `TEMPLATE.env`).

### Image

#### Build

```shell
export APPTAINERFILE="OpenRV.def" TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S") && \
    /usr/bin/time -f 'Commandline Args: %C\nElapsed Time: %E\nPeak Memory: %M\nExit Code: %x' \
    apptainer \
        --config ./apptainer/conf/apptainer.conf \
        --verbose \
        build \
        --build-arg-file .env \
        --warn-unused-build-args \
        ./apptainer/sif/OpenRV_${TIMESTAMP}.sif \
        ./apptainer/${APPTAINERFILE} \
        > >(tee -a ./apptainer/logs/${APPTAINERFILE}.${TIMESTAMP}.STDOUT.log) 2> >(tee -a ./apptainer/logs/${APPTAINERFILE}.${TIMESTAMP}.STDERR.log >&2) && \
    unset APPTAINERFILE TIMESTAMP
```

#### Help

```shell
apptainer run-help ./apptainer/sif/OpenRV.sif
```

### Container

#### Run

```shell
export APPTAINERFILE="OpenRV.def" && \
    apptainer exec \
        --nv \
        --bind /run/user/$UID,/Volumes,/run/media/$USER \
        ./apptainer/sif/OpenRV.sif \
        /opt/rv/bin/rv && \
    unset APPTAINERFILE
```
