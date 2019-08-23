    1. You will need access to an existing Pengwin or Debian-based distro for this step. If you do not already have Pengwin installed, I recommend the following steps:
        - Enable WSL on Windows if you have not already.
        - Install the [Debian for WSL app](https://www.microsoft.com/en-us/p/debian-gnu-linux/9msvkqc78pk6?activetab=pivot%3Aoverviewtab) from the Microsoft Store.
        - Run, let it finish installing, configure your username and password.
        - Then you will need to update apt, upgrade existing packages, and then install git:
            - ` $ sudo apt-get update ; sudo apt-get upgrade -y ; sudo apt-get install git -y`
    1. With your Pengwin (or configured/updated Debian) distro in place, execute the following:
        - ` $ git clone https://github.com/WhitewaterFoundry/Pengwin.git `
        - ` $ cd Pengwin`
        - ` $ chmod u+x create-targz-x64.sh`
        - ` $ ./create-targz-x64.sh`
    1. You should find an install.tar.gz in the /x64/ directory of your build directory.
        - If you are targeting ARM64, you'll also need repeat the last two steps for `create-targz-arm64.sh`.