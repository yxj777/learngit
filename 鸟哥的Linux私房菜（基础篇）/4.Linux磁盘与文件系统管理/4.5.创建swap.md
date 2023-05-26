## 使用实体分区创建swap
1. 分区：先使用 gdisk 在你的磁盘中分区出一个分区给系统作为 swap 
   - 由于 Linux 的 gdisk 默认会将分区的 ID 设置为 Linux 的文件系统，所以可能还得要设置一下 system ID 
    ```
    root@yxj-computer:~# gdisk /dev/nvme0n1
    Command (? for help): n

    Partition number (13-128, default 13): 
    First sector (34-1000215182, default = 924917760) or {+-}size{KMGTP}: 
    Last sector (924917760-955990015, default = 955990015) or {+-}size{KMGTP}: +512M
    Current type is 8300 (Linux filesystem)
    Hex code or GUID (L to show codes, Enter = 8300): 8200
    Changed type of partition to 'Linux swap'

    Command (? for help): p
    13       924917760       925966335   512.0 MiB   8200  Linux swap
    Command (? for help): w
    Do you want to proceed? (Y/N): y
    root@yxj-computer:~# partprobe -s

    root@yxj-computer:~# lsblk
    └─nvme0n1p13 259:13   0   512M  0 part 
    ```
2. 创建（格式化） swap 格式
    ```
    root@yxj-computer:~# mkswap /dev/nvme0n1p13
    mkswap: /dev/nvme0n1p13：警告，将擦除旧的 xfs 签名。
    正在设置交换空间版本 1，大小 = 512 MiB (536866816  个字节)
    无标签， UUID=f74306c7-e111-4eb4-bc89-25befa26e51b

    root@yxj-computer:~# blkid /dev/nvme0n1p13
    /dev/nvme0n1p13: UUID="f74306c7-e111-4eb4-bc89-25befa26e51b" TYPE="swap" 
    PARTLABEL="Linux swap" PARTUUID="66832dd3-f600-4887-a317-e1f6383d3ad3"
    ```
3. 观察与载入
    ```
    root@yxj-computer:~# free
               total        used        free      shared  buff/cache   available
    内存：   16060544     2557936     9765080      689636     3737528    12494440
    交换：   17437688           0    17437688
    #有16060544k的实体内存，使用2557936k，剩余9765080k，其中689636k为cache使用
    swap有17437688k

    root@yxj-computer:~# swapon /dev/nvme0n1p13
    root@yxj-computer:~# free
               total        used        free      shared  buff/cache   available
    内存：   16060544     2567812     9768396      673644     3724336    12500456
    交换：   17961972  
    #增加了512M

    root@yxj-computer:~# swapon -s
    Filename				Type		Size		Used		Priority
    /swapfile                               file		9437180		0		-2
    /dev/nvme0n1p8                          partition	8000508		0		-3
    /dev/nvme0n1p13                         partition	524284		0		-4

    [[email protected] ~]# nano /etc/fstab
    UUID="f74306c7-e111-4eb4-bc89-25befa26e51b"  swap  swap  defaults  0  0
    #写入配置文件，只不过不是文件系统，所以没有挂载点，第二个字段写入 swap 即可
    ```
---
## 使用文件创建swap
1. 使用 dd 指令来新增一个 128MB 的文件在 /tmp 下
    ```
    root@yxj-computer:~# dd if=/dev/zero of=/tmp/swap bs=1M count=128
    记录了128+0 的读入
    记录了128+0 的写出
    134217728字节（134 MB，128 MiB）已复制，0.0971222 s，1.4 GB/s
    root@yxj-computer:~# ll -h /tmp/swap
    -rw-r--r-- 1 root root 128M  3月 25 15:15 /tmp/swap
    ```
2. 使用 mkswap 将 /tmp/swap 文件格式化为 swap 文件格式
    ```
    root@yxj-computer:~# mkswap /tmp/swap
    mkswap: /tmp/swap: insecure permissions 0644, fix with: chmod 0600 /tmp/swap
    正在设置交换空间版本 1，大小 = 128 MiB (134213632  个字节)
    无标签， UUID=75dfa98c-764f-4d02-a472-8b27dea622b0
    ```
3. 使用 swapon 来将 /tmp/swap 启动
    ```
    root@yxj-computer:~# swapon /tmp/swap

    swapon: /tmp/swap：不安全的权限 0644，建议使用 0600。
    root@yxj-computer:~# chmod 0600 /tmp/swap
    root@yxj-computer:~# ll /tmp/swap
    -rw------- 1 root root 134217728  3月 25 15:17 /tmp/swap

    root@yxj-computer:~# swapon /tmp/swap
    swapon: /tmp/swap：swapon 失败: 设备或资源忙
    root@yxj-computer:~# swapoff /tmp/swap
    root@yxj-computer:~# swapon /tmp/swap

    root@yxj-computer:~# free
    root@yxj-computer:~# swapon -s
    Filename				Type		Size		Used		Priority
    /swapfile                               file		9437180		0		-2
    /dev/nvme0n1p8                          partition	8000508		0		-3
    /dev/nvme0n1p13                         partition	524284		0		-4
    /tmp/swap                               file		131068		0		-5
    ```
4. 使用 swapoff 关掉 swap file，并设置自动启用
    ```
    [[email protected] ~]# nano /etc/fstab
    /tmp/swap  swap  swap  defaults  0  0
    # 为何这里不要使用 UUID 呢？这是因为系统仅会查询区块设备 （block device） 不会查询文件！
    # 所以，这里千万不要使用 UUID，不然系统会查不到

    [[email protected] ~]# swapoff /tmp/swap /dev/nvme0n1p13
    [[email protected] ~]# swapon -s
    Filename                                Type            Size    Used    Priority
    /dev/nvme0n1p8                          partition	8000508		0		-3

    [[email protected] ~]# swapon -a    #自动启动所有SWAP装置
    [[email protected] ~]# swapon -s
    ```