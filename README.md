
# Alpine Active Directory Controller

This is an *extremely* simple attempt at an Active Directory server container. It installs the minimal packages and:

* If /etc/samba/smb.conf is present, attempts to start the DC.
* If /etc/samba/smb.conf is *not* present, sleeps indefinitely for setup.

## Compose

The included `docker_compose.yml` gives an example of how to bring up this container for the existing `interfinitydynamics.info` domain on `192.168.0.35` with an already existing domain controller `maindc` at `192.168.0.30`.

* Pay attention to the DNS settings! You want to consult the main DC for DNS!

* It attempts to bridge to the `eth0` network interface. This should be changed if this is not the network interface of the Windows network!

## Setup

If no config is present, the container sleeps and waits to be setup. This can be done with `docker exec -it \<container_name\> sh`. From there, you can follow the Samba wiki instructions:

* [Joining a Samba DC to an Existing Active Directory](https://wiki.samba.org/index.php/Joining_a_Samba_DC_to_an_Existing_Active_Directory)

*or*

* [Setting up Samba as an Active Directory Domain Controller](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller)

...depending on your intention.

## Samba Version and Support

This uses the "latest" version of Alpine Linux. As of this writing, this installs Samba 4.20. This should support up to Windows Server 2019's schema, according to Samba's [AD Schema Version Support](https://wiki.samba.org/index.php/AD_Schema_Version_Support) page.

Due to this container's minimal construction, hopefully it remains adaptable as procedures and requirements change with newer versions.

