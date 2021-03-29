# Realtek RTL8125 NIC

This script addresses issues for adding driver support for the RTL8125 NIC specifically for proxmox-ve.

There are several methods to add support for this NIC scattered across forums. This script makes use of the deb pkg approach as with my experience produced the most consistent results.

My use case involved installing proxmox on several homelab servers so manually doing this on each one was really not a viable option. (please excuse my terrible bash :( )

## Installation instructions

Requirements: You will need 2 usb drives (one with proxmox-ve, and the other with these files) and a temporary network interface for this approach to work. You can use a phone's tethering feature or a usb-ethernet adapter to give internet access to the server during this process.

The script is meant to be run in 2 phases. Pre installation (i.e. in the debug shell) and post installation. The reason for this is that the installation process removes all of our scripts goodness so we need to do it again (with some slight modifications)


1) git clone or download this repo
2) copy contents to appropriate thumb drive
3) proceed to boot with installation drive
4) once at the appropriate screen drop into the debug shell by pressing `ctrl+d`
5) once in the shell you can mount the drive typically `sda1` or `sdb1` but ymmv 
6) once mounted copy the files to /tmp or ensure you can execute scripts from the mounted dir (permissions were weird for me I had to `chmod +x setup.sh`)
7) cd to the dir with the files and run `./setup.sh`
8) follow the onscreen instructions
9) once complete proceed with installation

For post installation repeat steps 5-8 once you've logged into the server. After the process completes just type `reboot` and you should be good to go.


## Gotchas

During the installation process after you run the script and are back in the GUI be sure to select the right NIC. If you goofed this up like I did in the first run you'll need to edit `/etc/network/interfaces` once booted into proxmox and set the appropriate nic after the script runs for `vmbr0` 

## Credit

Big thanks to the users in this proxmox [thread](https://forum.proxmox.com/threads/no-network-interface-found-for-rtl8125b.72378/) that had a very thorough step by step process on how to get this going.