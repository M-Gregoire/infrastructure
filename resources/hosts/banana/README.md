# Banana Pi M1

## Install

``` sh
https://sd-card-images.johang.se/boards/banana_pi_m1.html
```

## Configuration
``` sh
apt update && apt upgrade -y && apt install -y fdisk nfs-kernel-server vim
echo "/dev/disk/by-uuid/c3a3426a-4421-4cd2-aa05-5e620f4e2fbb /nfs/Safe ext4 noauto,nofail,x-systemd.automount,x-systemd.device-timeout=30 0 2" >> /etc/fstab
cat << EOF > /etc/exports
/nfs         *(rw,fsid=0,no_subtree_check)
/nfs/Safe    192.168.3.30(rw,no_subtree_check,all_squash,anonuid=1000,anongid=1000) 
/nfs/Safe    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)EOF
```

Only allow NFSv4: edit `/etc/nfs.conf`
``` sh
[nfsd]

vers3=no
```

``` sh
systemctl mask --now rpc-statd.service rpcbind.service rpcbind.socket
service nfs-kernel-server restart
```
