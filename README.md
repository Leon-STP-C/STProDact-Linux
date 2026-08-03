# STProDact-Linux

The purpose of this project is to try to provide an automated Setup for STProDact for Linux-Systems via the usage of Docker Containers. The STProDact.iss in this repo is the Windows setup equivalent to serve as a reference. The handling of dependencies in the environment is mainly done via `flake.nix` which is being run through the `.envrc.` Make sure to follow the [Prerequisites](#prerequisites) section to ensure proper functionality.

# Prerequisites

## Manual
Since flake.nix handles most dependencies this requires Nix to be installed on the system. You can download the Nix package manager [here](https://nixos.org/download/)\
For this to work direnv also has to be setup on the system. Basic Installation guide can be found [here](https://github.com/direnv/direnv#basic-installation)

**IMPORTANT!**\
While Nix handles docker the docker daemon still needs to be installed and setup manually for your distribution.

## Debian/Ubuntu
For Debian/Ubuntu based distributions you can run the provided script in `bootstrap/Debian-Ubuntu-Setup.sh`
Note that its best to run this script outside of the dev shell as it may introduce bugs.
> To bypass the Docker install method prompt you may also set the DOCKER_INSTALL_METHOD environment variable to either "official" or "apt"\
> As example:
```bash
DOCKER_INSTALL_METHOD=official ./bootstrap/Debian-Ubuntu-Setup.sh
```

# Getting Started