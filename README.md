
# Alpine Active Directory Controller

This is an *extremely* simple attempt at an Active Directory domain controller container. It installs the minimal packages and:

* If /etc/samba/smb.conf is present, attempts to start the DC.
* If /etc/samba/smb.conf is *not* present, sleeps indefinitely for setup.

## Compose

The included `docker_compose.yml` gives an example of how to bring up this container for the existing `interfinitydynamics.info` domain on `192.168.0.35` with an already existing domain controller `maindc` at `192.168.0.30`.

* Pay attention to the DNS settings! You want to consult the main DC for DNS!

* It attempts to bridge to the `eth0` network interface. This should be changed if this is not the network interface of the Windows network!

## Setup

If no config is present, the container sleeps and waits to be setup. This can be done with `docker exec -it <container_name> sh`. From there, you can follow the Samba wiki instructions:

* [Joining a Samba DC to an Existing Active Directory](https://wiki.samba.org/index.php/Joining_a_Samba_DC_to_an_Existing_Active_Directory)

*or*

* [Setting up Samba as an Active Directory Domain Controller](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller)

...depending on your intention.

## Group Policies

Group policies are stored as XML files in `C:\WINDOWS\SYSVOL\domain` by default (that is the literal word, domain). To replicate them to our container, we can:

* Create an OpenSSH keypair as `root` on our container host.
* Install [CygSSH](https://github.com/Bill-Stewart/CygSSH) on your Windows domain controller, which includes SSH and rsync.
* Setup a `SysvolSync` service user in ADUC, adding it to the `SSH Users` domain group.
* Add the public key to `C:\Program Files\CygSSH\users\SysvolSync\.ssh\authorized_keys`, taking care to set read permissions for the `SysvolSync` user, per the CygSSH help file.
* Perform the command `rsync -lrstz --delete -e "ssh -q" "SysvolSync@maindc:/cygdrive/c/Windows/SYSVOL/domain/" /mnt/smbadp/sysvol/` once, to ensure that it works.
* Add the following to out container host's crontab (where `maindc` is your Windows DC and `domain` is the literal word, "domain"):

```
*/5 * * * * root rsync -lrstz --delete -e "ssh -q" "SysvolSync@maindc:/cygdrive/c/Windows/SYSVOL/domain/" /mnt/smbadp/sysvol/
```

You will need to ensure `domain` is mounted in the container at the correct mountpoint. Please see `docker_compose.yml` for details. Please note that your domain's name should be in lower case, here.

If this is all done properly, you should see your GPO files under `\\smbadp\sysvol\<your domain name>`.

## Samba Version and Support

This uses the "latest" version of Alpine Linux. As of this writing, this installs Samba 4.20. This should support up to Windows Server 2019's schema, according to Samba's [AD Schema Version Support](https://wiki.samba.org/index.php/AD_Schema_Version_Support) page.

Due to this container's minimal construction, hopefully it remains adaptable as procedures and requirements change with newer versions.

