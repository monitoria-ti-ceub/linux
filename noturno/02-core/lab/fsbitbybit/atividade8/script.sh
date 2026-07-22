mount

df -h

dd if=/dev/zero of=image.iso bs=1M count=100

mkfs.ext4 image.iso

sudo mkdir -p /mnt/myimage
sudo mount -o loop image.iso /mnt/myimage

sudo cp ./fileToAddToDirectory.txt /mnt/myimage

sudo umount /mnt/myimage
