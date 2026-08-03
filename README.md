# STProDact-Linux

The purpose of this project is to try to provide an automated Setup for STProDact for Linux-Systems via the usage of Docker Containers. The handling of dependencies in the environment is mainly done via the flake.nix which is being run through the .envrc. Make sure direnv is installed and properly set up for your shell for it to work.

# Manual Prequisites
Since flake.nix handles most dependencies this requires Nix to be installed on the system. You can download the Nix package manager [here](https://nixos.org/download/)\
For this to work direnv also has to be setup on the system. Basic Installation guide can be found [here](https://github.com/direnv/direnv#basic-installation)

**IMPORTANT!**\
While the flake.nix handles dependencies the docker daemon still needs to be installed and setup manually for your distribution.


