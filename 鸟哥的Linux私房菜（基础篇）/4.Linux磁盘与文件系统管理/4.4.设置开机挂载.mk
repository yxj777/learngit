## 开机挂载 /etc/fstab 及 /etc/mtab
/etc/fstab 是开机时的配置文件，在 /etc/fstab 中设置开机挂载的文件系统<br>
filesystem 的挂载是记录到 /etc/mtab 与 /proc/mounts
- ### 系统挂载限制
  - 根目录 / 是必须挂载的，而且一定要先于其它 mount point 被挂载进来
  - 其它 mount point 必须为已创建的目录，可任意指定，但一定要遵守必须的系统目录架构原则 （FHS）
  - 所有 mount point 在同一时间之内，只能挂载一次。
  - 所有 partition 在同一时间之内，只能挂载一次。
  - 如若进行卸载，必须先将工作目录移到 mount point（及其子目录） 之外
- ### /etc/fstab 文件
    ```
    [root@study ~]# cat /etc/fstab
    # [设备/UUID等]                        [挂载点]      [文件系统]  [文件系统参数]  [dump] [fsck]
    # Device                              Mount point  filesystem parameters    dump   fsck
    /dev/mapper/centos-root                   /       xfs     defaults            0     0
    UUID=94ac5f77-cb8a-495e-a65b-2ef7442b837c /boot   xfs     defaults            0     0
    /dev/mapper/centos-home                   /home   xfs     defaults            0     0
    /dev/mapper/centos-swap                   swap    swap    defaults            0     0

    ```
    - 第一栏：磁盘设备文件名/UUID/LABEL name
    - 第二栏：挂载点 （mount point）
      - 手动挂载时可以让系统自动测试挂载，但在这个文件当中必须要手动写入文件系统才行
    - 第三栏：磁盘分区的文件系统
    - 第四栏：文件系统参数
      - ![](../images/2023-03-25-11-17-24.png)
    - 第五栏：能否被 dump 备份指令作用
      - dump 是一个用来做为备份的指令，不过现在有太多的备份方案了,直接输入 0 就好
    - 第六栏：是否以 fsck 检验扇区
      - 早期开机的流程中，会有一段时间去检验本机的文件系统，看看文件系统是否完整 （clean）
      - xfs 会自己进行检验，直接填 0 就好
---
## 特殊设备 loop 挂载 