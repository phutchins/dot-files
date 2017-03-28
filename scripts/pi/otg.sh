#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Please provide the location where the boot partition is mounted"
fi

BOOT_PARTITION=$1

# Check boot partition /config.txt for dtoverlay=dwc2 on the last line
CONFIG_FILE=$BOOT_PARTITION/config.txt
CONFIG_TXT=$(cat $CONFIG_FILE)
DTOVERLAY_RX="dtoverlay=dwc2"

if grep -Fxq "$DTOVERLAY_RX" $CONFIG_FILE; then
  echo "dtoverlay already exists in /config.txt"
else
  # If dtoverlay=dwc2 doesn't exist, add it
  echo "Adding dtoverlay to /config.txt"
  echo "dtoverlay=dwc2" >> $BOOT_PARTITION/config.txt
fi

# Add a file named 'ssh' to the root of boot partition to enable ssh
echo "Adding ssh file at root of boot partition"
touch $BOOT_PARTITION/ssh

# In cmdline.txt after rootwait, insert modules-load=dwc2,g_ether
CMDLINE_FILE=$BOOT_PARTITION/cmdline.txt
CMDLINE_CONTENTS=$(cat $CMDLINE_FILE)

if [[ $CMDLINE_CONTENTS =~ dwc2,g_ether ]]; then
  echo "dwc2 and g_ether already exist in cmdline.txt"
else
  echo "Adding dwc2 and g_ether to cmdline.txt"
  sed -ie 's/rootwait/rootwait modules-load=dwc2,g_ether/g' $CMDLINE_FILE
fi

# Done!
echo "Done!"

exit 0;
