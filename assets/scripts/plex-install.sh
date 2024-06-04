#!/bin/bash
# Author: Joshua Ross
# Purpose: Plex Install Script

# Variables 
deubuntu_repo="/etc/apt/sources.list.d/plexmediaserver.list"
rhel_repo="/etc/yum.repos.d/plex.repo"


# Functions for type of OS.
install_plex_on_debubuntu() {
    # Add Plex repository and key
    echo "Adding Plex repository for Debian-based systems..."
    echo deb https://downloads.plex.tv/repo/deb public main | sudo tee $deubuntu_repo > /dev/null

    # Update package index
    sudo apt update

    # Install Plex Media Server
    echo "Installing Plex Media Server for Debian-based systems..."
    sudo apt install -y plexmediaserver
}

install_plex_on_rhel() {
    
# Define the repository configuration
REPO_CONFIG=$(cat <<EOF
[PlexRepo]
name=PlexRepo
baseurl=https://downloads.plex.tv/repo/rpm/\$basearch/
enabled=1
gpgkey=https://downloads.plex.tv/plex-keys/PlexSign.key
gpgcheck=1
EOF
)

# Write the repository configuration to a file in /etc/yum.repos.d
echo "$REPO_CONFIG" | sudo tee $rhel_repo > /dev/null
    #Updating System
    echo "Updating system..."
    sudo dnf makecache
    sudo dnf -y update 

    # Install Plex Media Server
    echo "Installing Plex Media Server for RHEL-based systems..."
    sudo dnf install -y plexmediaserver
}

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
else
    OS=$(uname -s)
fi

# Install Plex based on the distribution
case "$OS" in
    "Ubuntu")
       install_plex_on_debubuntu || echo "Error installing Plex Media Server on $OS"
        ;;
    "Debian GNU/Linux")
        install_plex_on_debubuntu || echo "Error installing Plex Media Server on $OS"
        ;;
    "Red Hat Enterprise Linux")
        install_plex_on_rhel || echo "Error installing Plex Media Server on $OS"
        ;;
    "Fedora")
        install_plex_on_rhel || echo "Error installing Plex Media Server on $OS"
        ;;
    "Rocky Linux")
        install_plex_on_rhel || echo "Error installing Plex Media Server on $OS"
        ;;
    "AlmaLinux")
        install_plex_on_rhel || echo "Error installing Plex Media Server on $OS"
        ;;

    *)
        echo "Unsupported distribution: $OS"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo "Plex Media Server has been installed successfully."
else
    echo "Installation of Plex Media Server failed. Please check the error messages above."
fi
    