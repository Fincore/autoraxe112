swapfile=$(losetup -f) #free loop device
truncate -s 8G /swap   #create 8G sparse swap file
losetup $swapfile /swap #mount file to loop
mkswap  $swapfile
swapon  $swapfile