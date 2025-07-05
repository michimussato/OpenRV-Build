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
  * [Docker](#docker)
    * [Install Docker](#install-docker)
      * [Remove old Versions](#remove-old-versions)
      * [Install from Docker Repo](#install-from-docker-repo)
    * [Dependencies to Run OpenRV from resulting Tarball](#dependencies-to-run-openrv-from-resulting-tarball)
  * [Issues](#issues)
    * [No Audio in Apptainer?](#no-audio-in-apptainer)
<!-- TOC -->

---

# Rocky 9

## Setup

### Virtual Box

#### Guest Additions

Problem:

```
$ sudo '/run/media/user/VBox_GAs_7.1.10/VBoxLinuxAdditions.run' 
Verifying archive integrity...  100%   MD5 checksums are OK. All good.
Uncompressing VirtualBox 7.1.10 Guest Additions for Linux  100%  
VirtualBox Guest Additions installer
Removing installed version 7.1.10 of VirtualBox Guest Additions...
VirtualBox Guest Additions: Starting.
VirtualBox Guest Additions: Setting up modules
VirtualBox Guest Additions: Building the VirtualBox Guest Additions kernel 
modules.  This may take a while.
VirtualBox Guest Additions: To build modules for other installed kernels, run
VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup <version>
VirtualBox Guest Additions: or
VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup all
VirtualBox Guest Additions: Kernel headers not found for target kernel 
5.14.0-570.17.1.el9_6.x86_64. Please install them and execute
  /sbin/rcvboxadd setup
File context for /opt/VBoxGuestAdditions-7.1.10/other/mount.vboxsf already defined, modifying instead
VirtualBox Guest Additions: reloading kernel modules and services
VirtualBox Guest Additions: unable to load vboxguest kernel module, see dmesg
VirtualBox Guest Additions: kernel modules and services were not reloaded
The log file /var/log/vboxadd-setup.log may contain further information.
```

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
sudo dnf install -y \
    time \
    apptainer
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
        ./apptainer/.sif/OpenRV_${TIMESTAMP}.sif \
        ./apptainer/${APPTAINERFILE} \
        > >(tee -a ./apptainer/logs/${APPTAINERFILE}.${TIMESTAMP}.STDOUT.log) 2> >(tee -a ./apptainer/logs/${APPTAINERFILE}.${TIMESTAMP}.STDERR.log >&2) && \
    unset APPTAINERFILE TIMESTAMP
```

#### Help

```shell
apptainer run-help ./apptainer/.sif/OpenRV_<TIMESTAMP>.sif
```

### Container

#### Run

```shell
apptainer exec \
    --nv \
    --bind /run/user/$UID \
    ./apptainer/.sif/OpenRV_<TIMESTAMP>.sif \
    /opt/OpenRV/bin/rv
```

## Docker

### Install Docker

Resources:
- https://docs.docker.com/engine/install/rhel/
- https://docs.docker.com/engine/install/linux-postinstall/

#### Remove old Versions

```shell
sudo dnf remove -y \
    docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    podman \
    runc
```

#### Install from Docker Repo

```shell
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
```

```shell
sudo dnf install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
```

```shell
sudo systemctl enable --now docker
```

```shell
sudo groupadd docker
sudo usermod -aG docker $USER
```

### Dependencies to Run OpenRV from resulting Tarball

Reference: https://aswf-openrv.readthedocs.io/en/latest/build_system/config_linux_rocky89.html#install-other-dependencies

```shell
sudo dnf install -y alsa-lib-devel autoconf automake avahi-compat-libdns_sd-devel bison bzip2-devel cmake-gui curl-devel flex gcc gcc-c++ git libXcomposite libXi-devel libaio-devel libffi-devel nasm ncurses-devel nss libtool libxkbcommon libXcomposite libXdamage libXrandr libXtst libXcursor mesa-libOSMesa mesa-libOSMesa-devel meson openssl-devel patch pulseaudio-libs pulseaudio-libs-glib2 ocl-icd ocl-icd-devel opencl-headers qt5-qtbase-devel readline-devel sqlite-devel systemd-devel tcl-devel tcsh tk-devel yasm zip zlib-devel wget patchelf pcsc-lite libxkbfile perl-IPC-Cmd
```

## Issues

### No Audio in Apptainer?

```
WARNING: PulseAudioService: pa_context_connect() failed
```

https://stackoverflow.com/a/66568257/2207196