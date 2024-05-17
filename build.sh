#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
#rpm-ostree install @base-x @standard @kde akmod-nvidia code firefox{,-langpacks} flatpak git google-noto-sans-cjk-fonts gwenview htop iwlwifi-mvm-firmware kcalc keepassxc krita libavcodec-freeworld mesa-va-drivers-freeworld mpv neofetch NetworkManager-wifi nmap nvtop okular plymouth-kcm snapper speedtest-cli strace tlp vim virt-viewer xorg-x11-drv-nvidia-cuda

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

#systemctl enable tlp
#systemctl set-default graphical.target
