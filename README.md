> [!NOTE]
> While these customisations are made for my use cases and hardware, you are free to either use it as is or to use it as a base for your own fork. You are at the whim of any changes I make, breaking or otherwise, which won't be communicated at all.

# Getting Started

Go to the [Universal Blue](https://github.com/ublue-os/image-template) repo and click on 'Use this template' to create your on copy (and also read the README).

The main important files are:
- `.github/workflows/build.yml` (Instructions for GitHub Actions)
- `Containerfile` (Docker/Podman container details)
- `build.sh` (Script to customise the OS remove/add packages, alter config files, etc.)
- `cosign.pub` (Public key for signing the container when it's pushed to GHCR)

The OCI image is based from `fedora-coreos:stable-nvidia` (currently version 40)

## List of Customisations
### Complete
- *Nothing yet*

### Pending
- Slim down CoreOS base image

### To-Do
- Install a minimal version of KDE Plasma
- Install small number of KDE related apps (apps TBD)
- *More to come*

