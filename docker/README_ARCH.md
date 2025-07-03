

---`

# osmesa

https://bbs.archlinux.org/viewtopic.php?id=231899
https://aur.archlinux.org/packages/mesa-git

https://wiki.archlinux.org/title/Creating_packages

```shell
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/mesa-git.git
cd mesa-git
# add '--enable-gallium-osmesa' to PKGBUILD
makepkg --syncdeps # -s
# -p <file>        Use an alternate build script (instead of 'PKGBUILD')
# -r, --rmdeps     Remove installed dependencies after a successful build
# -S, --source     Generate a source-only tarball without downloaded sources
# These options can be passed to pacman:
#   --asdeps         Install packages as non-explicitly installed
#   --needed         Do not reinstall the targets that are already up to date
#   --noconfirm      Do not ask for confirmation when resolving dependencies
#   --noprogressbar  Do not show a progress bar when downloading files
```

# pkgfile

```shell
# https://stackoverflow.com/questions/66486937/where-can-i-get-libglu-so-1-on-arch-linux
# sudo pacman -Syyu --noconfirm pkgfile
# sudo pkgfile --update
# $ pkgfile libOSMesa.so
# extra/mesa-amber
# multilib/lib32-mesa-amber
# $ pkgfile libGLU.so
# extra/glu
# multilib/lib32-glu
```