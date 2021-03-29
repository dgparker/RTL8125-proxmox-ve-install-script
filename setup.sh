#!/usr/bin/env bash

# *******************************
# *                            **
# *                            **
# * setup temporary networking **
# *                            **
# *                            **
# *******************************
PS3="are we in debug shell or post installation: "

select env in debugShell postInstallation
do
    case $env in
        "debugShell")
            break
            ;;
        "postInstallation")
            echo "stopping networking service"
            /etc/init.d/networking stop
            break
            ;;
    esac
done

interfaces=$(ip link | awk -F: '$0 !~ "lo|vir|veth|^[^0-9]"{print $2;getline}')

PS3="select temporary network device: "

select opt in $interfaces;
do
    tmpnic=$opt
    break
done

echo "selected ${tmpnic} running ip link set for selected network device"

linkcmd=$(ip link set $tmpnic)

dhclientcmd=$(dhclient $tmpnic)

ping -c 5 1.1.1.1

# *******************************
# *                            **
# *                            **
# * install dependencies       **
# *                            **
# *                            **
# *******************************

chmod 1777 /tmp

echo "deb [trusted=yes] http://download.proxmox.com/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list

apt update

apt install -y pve-headers-$(uname -r)

apt install -y build-essential

apt install -y dkms

# *******************************
# *                            **
# *                            **
# * install the deb driver     **
# *                            **
# *                            **
# *******************************

dpkg -i ./*.deb

# *******************************
# *                            **
# *                            **
# * initialize RTL8125 nic     **
# *                            **
# *                            **
# *******************************

read -p "Disconnect the temporary network device and make sure RTL8125 nic is connected then press enter to continue"

ip link set $tmpnic down

interfaces=$(ip link | awk -F: '$0 !~ "lo|vir|veth|^[^0-9]"{print $2;getline}')

PS3="select RTL8125 interface: "

select opt in $interfaces;
do
    nic=$opt
    break
done

linkcmd=$(ip link set $nic)

dhclientcmd=$(dhclient $nic)

ping -c 5 1.1.1.1

echo "if ping was successful and you're in the debug shell type exit and proceed with installation as normal"

echo "if ping was successful and you're post installation type reboot"
