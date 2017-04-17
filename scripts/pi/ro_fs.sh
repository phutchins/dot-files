#!/bin/bash

# Disable Swap
dphys-swapfile swapoff
dphys-swapfile uninstall
update-rc.d dphys-swapfile disable

# Install UnionFS
aptitude install unionfs-fuse

# Create mount script
cat >/usr/local/bin/mount_unionfs << EOL
#!/bin/sh
[ -z "$1" ] && exit 1 || DIR=$1
ROOT_MOUNT=$(grep -v "^#" /etc/fstab | awk '$2=="/" {print substr($4,1,2)}')
if [ "$ROOT_MOUNT" != "ro" ]; then
  /bin/mount --bind ${DIR}_org ${DIR}
else
  /bin/mount -t tmpfs ramdisk ${DIR}_rw
  /usr/bin/unionfs-fuse -o cow,allow_other,suid,dev,nonempty ${DIR}_rw=RW:${DIR}_org=RO ${DIR}
fi
EOL

# Make the mount script executable
chmod +x /usr/local/bin/mount_unionfs

# Update fstab
  # make / ro,noatime
  # make /boot ro
  # add the following
  # mount_unionfs   /etc            fuse    defaults          0       0
  # mount_unionfs   /var            fuse    defaults          0       0
  # none            /tmp            tmpfs   defaults          0       0

# Prepare directories
cp -al /etc /etc_org
mv /var /var_org
mkdir /etc_rw
mkdir /var /var_rw

# Reboot
echo "Please reboot now. When the system comes back up, run the second part of this script."

# Check `mount` to make sure things are mounted ro
mount

# Clean up the log directory
mount -o remount,rw /
for f in $(find . -name \*log); do > $f; done
cd /var_org/log
rm -f *.gz

# Reboot one last time
echo "Please reboot once more..."

# For making changes, you can do one of the following...
# mount -o remount,rw /

# or

# Run the remount_rw.sh script which mounts everything in a chroot
