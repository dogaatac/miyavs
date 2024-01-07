while true
do

fusermount -uz /root/.config/rclone/

sleep 5

rclone mount anam: /root/.config/rclone/ --vfs-read-chunk-size-limit 0 --no-checksum  --vfs-read-chunk-size 512K --no-modtime   --vfs-read-wait=0   --read-only   --daemon --buffer-size off --allow-non-empty --vfs-cache-mode full

sleep 600

done
