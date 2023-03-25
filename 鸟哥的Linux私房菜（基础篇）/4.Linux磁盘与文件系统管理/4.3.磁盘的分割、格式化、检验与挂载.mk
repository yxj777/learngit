## 观察磁盘分区状态
- ### lsblk：列出系统上的所有磁盘列表
    ```
    [[email protected] ~]# lsblk [-dfimpt] [device]
    选项与参数：
    -d  ：仅列出磁盘本身，并不会列出该磁盘的分区数据
    -f  ：同时列出该磁盘内的文件系统名称
    -i  ：使用 ASCII 的线段输出，不要使用复杂的编码 （再某些环境下很有用）
    -m  ：同时输出该设备在 /dev 下面的权限数据 （rwx 的数据）
    -p  ：列出该设备的完整文件名！而不是仅列出最后的名字而已。
    -t  ：列出该磁盘设备的详细数据，包括磁盘伫列机制、预读写的数据量大小等
    ```
    ```
    范例一：列出自己电脑的磁盘分区
    root@yxj-computer:~# lsblk
    NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
    nvme0n1      259:0    0 476.9G  0 disk 
    ├─nvme0n1p1  259:1    0   300M  0 part /boot/efi
    ├─nvme0n1p2  259:2    0   128M  0 part 
    ├─nvme0n1p3  259:3    0   140G  0 part /media/yxj/OS
    ├─nvme0n1p4  259:4    0 230.4G  0 part /media/yxj/新加卷
    ├─nvme0n1p5  259:5    0   191M  0 part 
    ├─nvme0n1p6  259:6    0  28.6G  0 part /var/snap/firefox/common/host-hunspell

    ```
  - NAME：设备的文件名
  - MAJ：MIN：主要：次要设备代码，核心认识的设备都是通过这两个代码来熟悉的
  - RM：是否为可卸载设备 （removable device），如光盘、USB 磁盘等等
  - SIZE：容量
  - RO：是否为只读设备
  - TYPE：是磁盘 （disk）、分区 （partition） 还是只读存储器 （rom） 等输出
  - MOUTPOINT：挂载点
- ### blkid：列出设备的 UUID 等参数
    ```
    [[email protected] ~]# blkid
    /dev/vda2: UUID="94ac5f77-cb8a-495e-a65b-2ef7442b837c" TYPE="xfs" 
    /dev/vda3: UUID="WStYq1-P93d-oShM-JNe3-KeDl-bBf6-RSmfae" TYPE="LVM2_member"
    /dev/sda1: UUID="35BC-6D6B" TYPE="vfat"
    /dev/mapper/centos-root: UUID="299bdc5b-de6d-486a-a0d2-375402aaab27" TYPE="xfs"
    /dev/mapper/centos-swap: UUID="905dc471-6c10-4108-b376-a802edbd862d" TYPE="swap"
    /dev/mapper/centos-home: UUID="29979bf1-4a28-48e0-be4a-66329bf727d9" TYPE="xfs"

    ```
- ### parted：列出磁盘的分区表类型与分区信息
    ```
    root@yxj-computer:~# parted /dev/nvme0n1 print
    型号：BC711 NVMe SK hynix 512GB (nvme)
    磁盘 /dev/nvme0n1: 512GB
    扇区大小 (逻辑/物理)：512B/512B
    分区表：gpt
    磁盘标志：

    编号  起始点  结束点  大小    文件系统        名称                          标志
    1    1049kB  316MB   315MB   fat32           EFI system partition          启动, esp
    2    316MB   450MB   134MB                   Microsoft reserved partition  msftres
    3    450MB   151GB   150GB   ntfs            Basic data partition          msftdata
    4    151GB   398GB   247GB   ntfs            Basic data partition          msftdata
    5    404GB   404GB   200MB   fat32                                         启动, esp
    6    404GB   434GB   30.7GB  ext4
    ```
---
## 磁盘分区
- gdisk（GPT）
    ```
    [[email protected] ~]# gdisk 设备名称
    ```
    - 不用记，系统参考非常细致
    - q 退出，所有动作不会执行，随便造
    - w 保存退出
    - 用gdisk添加分区
      - 同上，添加完分区后要用 **partprobe 更新Linux核心的分区表信息**
        ```
        [[email protected] ~]# partprobe [-s]
        选项与参数：
        -s : 屏幕出现信息
        ```
- fdisk（MBR）
---
## 磁盘格式化（创建系统文件）
- ### mkfs.xfs：XFS 文件系统 
    ```
    [[email protected] ~]# mkfs.xfs [-b bsize] [-d parms] [-i parms] [-l parms] [-L label] 
                                    [-f] [-r parms] 设备名称
    选项与参数：
    关于单位：没有加单位则为 Bytes 值，可以用 k,m,g,t,p （小写）等来解释
            比较特殊的是 s 这个单位，它指的是 sector 的“个数”
    -b  ：block 容量，可由 512 到 64k，最大容量限制为 Linux 的 4k 
    -d  ：data section 的相关参数值，主要的值有：
        agcount=数值  ：设置需要几个储存群组的意思（AG），通常与 CPU 有关
        agsize=数值   ：每个 AG 设置为多少容量的意思，通常 agcount/agsize 只选一个设置即可
        file          ：格式化的设备是个文件而不是个设备（例如虚拟磁盘）
        size=数值     ：data section 的容量，亦即你可以不将全部的设备容量用完的意思
        su=数值       ：当有 RAID 时，那个 stripe 数值的意思，与下面的 sw 搭配使用
        sw=数值       ：当有 RAID 时，用于储存数据的磁盘数量（须扣除备份碟与备用碟）
        sunit=数值    ：与 su 相当，不过单位使用的是“几个 sector（512Bytes大小）”的意思
        swidth=数值   ：就是 su*sw 的数值，但是以“几个 sector（512Bytes大小）”来设置
    -f  ：如果设备内已经有文件系统，则需要使用这个 -f 来强制格式化才行！
    -i  ：与 inode 有较相关的设置，主要的设置值有：
        size=数值     ：最小是 256Bytes 最大是 2k，一般保留 256 就足够使用
        internal=[0&#124;1]：log 设备是否为内置？默认为 1 内置，如果要用外部设备，使用下面设置
        logdev=device ：log 设备为后面接的那个设备上头的意思，需设置 internal=0 才可！
        size=数值     ：指定这块登录区的容量，通常最小得要有 512 个 block，大约 2M 以上才行！
    -L  ：后面接这个文件系统的标头名称 Label name 的意思
    -r  ：指定 realtime section 的相关设置值，常见的有：
        extsize=数值  ：就是那个重要的 extent 数值，一般不须设置，但有 RAID 时，
                        最好设置与 swidth 的数值相同较佳！最小为 4K 最大为 1G 。
    ```
- ### mkfs.ext4：EXT4 文件系统
```
[[email protected] ~]# mkfs.ext4 [-b size] [-L label] 设备名称
选项与参数：
-b  ：设置 block 的大小，有 1K, 2K, 4K 的容量，
-L  ：后面接这个设备的标头名称
```
- ### 其他文件系统mkfs
```
[[email protected] ~]# mkfs[tab][tab]
mkfs         mkfs.cramfs  mkfs.ext3    mkfs.fat     mkfs.msdos   mkfs.vfat
mkfs.bfs     mkfs.ext2    mkfs.ext4    mkfs.minix   mkfs.ntfs    mkfs.xfs

```
---
## 文件系统检验
- ### xfs_repair：处理 XFS 文件系统
    ```
    [[email protected] ~]# xfs_repair [-fnd] 设备名称
    选项与参数：
    -f  ：后面的设备其实是个文件而不是实体设备
    -n  ：单纯检查并不修改文件系统的任何数据 （检查而已）
    -d  ：通常用在单人维护模式下面，针对根目录 （/） 进行检查与修复的动作！很危险！不要随便使用
    ```
    - 修复该文件系统时，不能被挂载
    - 根目录可以通过-d选项来处理
- ### fsck.ext4：处理 EXT4 文件系统
    ```
    [[email protected] ~]# fsck.ext4 [-pf] [-b superblock] 设备名称
    选项与参数：
    -p  ：当文件系统在修复时，若有需要回复 y 的动作时，自动回复 y 来继续进行修复动作。
    -f  ：强制检查！一般来说，如果 fsck 没有发现任何 unclean 的旗标，不会主动进入
        细部检查的，如果您想要强制 fsck 进入细部检查，就得加上 -f 旗标！
    -D  ：针对文件系统下的目录进行最优化配置。
    -b  ：后面接 superblock 的位置！一般来说这个选项用不到。但是如果你的 superblock 因故损毁时，
        通过这个参数即可利用文件系统内备份的 superblock 来尝试救援。一般来说，superblock 备份在：
        1K block 放在 8193, 2K block 放在 16384, 4K block 放在 32768
    ```
- 通常只有身为 root 且文件系统有问题的时候才使用这些指令，否则在正常状况下使用此一指令， 可能会造成对系统的危害！
- 也可以处理格式化后的磁盘问题
- **被检查的 partition 务必不可挂载到系统上**
---
## 文件系统挂载与卸载
- ### 注意事项
  - 单一文件系统不应该被重复挂载在不同的挂载点（目录）中;
  - 单一目录不应该重复挂载多个文件系统;
  - 要作为挂载点的目录，理论上应该都是空目录才是
- ### mount：挂载文件
```
[[email protected] ~]# mount -a
[[email protected] ~]# mount [-l]
[[email protected] ~]# mount [-t 文件系统] LABEL=''  挂载点
[[email protected] ~]# mount [-t 文件系统] UUID=''   挂载点  # 期建议用这种方式
[[email protected] ~]# mount [-t 文件系统] 设备文件名  挂载点
选项与参数：
-a  ：依照配置文件 [/etc/fstab](../Text/index.html#fstab) 的数据将所有未挂载的磁盘都挂载上来
-l  ：单纯的输入 mount 会显示目前挂载的信息。加上 -l 可增列 Label 名称！
-t  ：可以加上文件系统种类来指定欲挂载的类型。常见的 Linux 支持类型有：xfs, ext3, ext4,
      reiserfs, vfat, iso9660（光盘格式）, nfs, cifs, smbfs （后三种为网络文件系统类型）
-n  ：在默认的情况下，系统会将实际挂载的情况实时写入 /etc/mtab 中，以利其他程序的运行。
      但在某些情况下（例如单人维护模式）为了避免问题会刻意不写入。此时就得要使用 -n 选项。
-o  ：后面可以接一些挂载时额外加上的参数！比方说帐号、密码、读写权限等：
      async, sync:   此文件系统是否使用同步写入 （sync） 或非同步 （async）,默认为 async。
      atime,noatime: 是否修订文件的读取时间（atime）。为了性能，某些时刻可使用 noatime
      ro, rw:        挂载文件系统成为只读（ro） 或可读写（rw）
      auto, noauto:  允许此 filesystem 被以 mount -a 自动挂载（auto）
      dev, nodev:    是否允许此 filesystem 上，可创建设备文件？ dev 为可允许
      suid, nosuid:  是否允许此 filesystem 含有 suid/sgid 的文件格式？
      exec, noexec:  是否允许此 filesystem 上拥有可执行 binary 文件？
      user, nouser:  是否允许此 filesystem 让任何使用者执行 mount ？一般来说，
                     mount 仅有 root 可以进行，但下达 user 参数，则可让
                     一般 user 也能够对此 partition 进行 mount 。
      defaults:      默认值为：rw, suid, dev, exec, auto, nouser, and async
      remount:       重新挂载，这在系统出错，或重新更新参数时，很有用！
```
  - 系统一般会自动分析最恰当的文件系统来挂载设备
    - linux分析superblock搭配linux的驱动其测试挂载，成功了就自动使用该类型文件系统挂载
      - /etc/filesystems：系统指定的测试挂载文件系统类型的优先顺序;
      - /proc/filesystems：Linux系统已经载入的文件系统类型。
      - /lib/modules/$（uname -r）/kernel/fs/： Linux 相关文件系统类型的驱动程序
- ### 挂载 xfs/ext4/vfat 等文件系统
    ```
    root@yxj-computer:~# mount UUID="b9ce1958-d12d-4dc6-aa46-394f4889ae0c" /tmp/xfs
    root@yxj-computer:~# df /tmp/xfs
    文件系统         1K的块  已用   可用 已用% 挂载点
    /dev/nvme0n1p13 1038336 40292 998044    4% /tmp/xfs

    ```
- ### 挂载CD或DVD光盘
    ```
    [[email protected] ~]# mount /dev/sr0 /data/cdrom
    mount: /dev/sr0 is write-protected, mounting read-only

    [[email protected] ~]# df /data/cdrom
    Filesystem     1K-blocks    Used Available Use% Mounted on
    /dev/sr0         7413478 7413478         0 100% /data/cdrom
    因为是 DVD，所以无法再写入了，故使用100%
    ```
    - 光驱一挂载之后就无法退出光盘片了，除非你将他卸载才能够退出
    - 如果使用的是图形界面，系统会自动挂载这个光盘到 /media/ 
- ### 挂载 vfat 中文U盘
    ```
    [[email protected] ~]#   mount -o codepage=950,iocharset=utf8 UUID="35BC-6D6B" /data/usb
    [[email protected] ~]# df /data/usb
    Filesystem     1K-blocks  Used Available Use% Mounted on
    /dev/sda1        2092344     4   2092340   1% /data/usb
    ```
    - 如果带有中文文件名的数据，可以在挂载时指定一下挂载文件系统所使用的语系数据
    - 中文语系的代码为 950 
- ### 重新挂载根目录与挂载不特定目录
  - 根目录不能被卸载
  - 当根目录挂载参数要改变，或者出现“只读“状态
    - 可以通过重新开机（reboot），或者重新挂载
        ```
        范例：将 / 重新挂载，并加入参数为 rw 与 auto
        [[email protected] ~]# mount -o remount,rw,auto /
        ```
  - 将某个目录挂载到另外一个目录
    ```
    范例：将 /var 这个目录暂时挂载到 /data/var 下面：
    [[email protected] ~]# mkdir /data/var
    [[email protected] ~]# mount --bind /var /data/var
    [[email protected] ~]# ls -lid /var /data/var
    16777346 drwxr-xr-x. 22 root root 4096 Jun 15 23:43 /data/var
    16777346 drwxr-xr-x. 22 root root 4096 Jun 15 23:43 /var
    ```
- ### umount ：将设备文件卸载
    ```
    [[email protected] ~]# umount [-fn] 设备文件名或挂载点
    选项与参数：
    -f  ：强制卸载！可用在类似网络文件系统 （NFS） 无法读取到的情况下；
    -l  ：立刻卸载文件系统，比 -f 还强！
    -n  ：不更新 /etc/mtab 情况下卸载。
    ```
   - 当退出U盘等设备，发生“你正在使用该文件系统“，使用“cd /”回到根目录
    ```
    [[email protected] ~]# mount /dev/sr0 /data/cdrom
    [[email protected] ~]# cd /data/cdrom
    [[email protected] cdrom]# umount /data/cdrom
    umount: /data/cdrom: target is busy.
            （In some cases useful info about processes that use
            the device is found by lsof（8） or fuser（1））

    [[email protected] cdrom]# cd /
    [[email protected] /]# umount /data/cdrom

    ```
---
## 磁盘/文件系统参数修订
- ### mknod : 创建块设备文件和字符设备文件
    ```
    [[email protected] ~]# mknod 设备文件名 [bcp] [Major] [Minor]
    选项与参数：
    设备种类：
    b  ：设置设备名称成为一个块设备文件，例如磁盘等；
    c  ：设置设备名称成为一个字符设备文件，例如鼠标/键盘等；
    p  ：设置设备名称成为一个 FIFO 文件；
    Major ：主要设备代码；
    Minor ：次要设备代码；
    ```
    ```
    范例：查找/dev/nvme0n的设备码，并创建和查阅/dev/nvme0n1p14设备
    root@yxj-computer:~# ll /dev/nvme0n*
    brw-rw---- 1 root disk 259,  0  3月 25 10:12 /dev/nvme0n1
    brw-rw---- 1 root disk 259,  1  3月 25 10:12 /dev/nvme0n1p1
    brw-rw---- 1 root disk 259, 10  3月 25 10:12 /dev/nvme0n1p10
    brw-rw---- 1 root disk 259, 11  3月 25 10:12 /dev/nvme0n1p11
    brw-rw---- 1 root disk 259, 12  3月 25 10:12 /dev/nvme0n1p12

    root@yxj-computer:~# mknod /dev/nvme0n1p14 b 259 14
    root@yxj-computer:~# ll /dev/nvme0n1p14
    brw-r--r-- 1 root root 259, 14  3月 25 10:14 /dev/nvme0n1p14

    ```
  - ### xfs_admin 修改 XFS 文件系统的 UUID 与 Label name
    ```
    [[email protected] ~]# xfs_admin [-lu] [-L label] [-U uuid] 设备文件名
    选项与参数：
    -l  ：列出这个设备的 label name
    -u  ：列出这个设备的 UUID
    -L  ：设置这个设备的 Label name
    -U  ：设置这个设备的 UUID 
    ```
  - ### tune2fs 修改 ext4 的 label name 与 UUID
    ```
    [[email protected] ~]# tune2fs [-l] [-L Label] [-U uuid] 设备文件名
    选项与参数：
    -l  ：superblock 内的数据读出来
    -L  ：修改 LABEL name
    -U  ：修改 UUID
    ```