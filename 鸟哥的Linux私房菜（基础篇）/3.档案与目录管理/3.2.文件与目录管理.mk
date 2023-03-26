## 档案与目录管理
- ### ls（文件与目录的查看）
  ```
  ls [-aAdfFhilnrRSt]  文件名或目录名称
  ls [--color={never,auto,always}]  文件名或目录名称
  ls [--full-time]  文件名或目录名称
  选项与参数：
  -a  ：全部的文件，连同隐藏文件一起列出来（常用）
  -A  ：全部的文件，连同隐藏文件，但不包括 . 与 .. 这两个目录
  -d  ：仅列出目录本身，而不是列出目录内的文件数据（常用）
  -f  ：直接列出结果，而不进行排序 
  -F  ：根据文件、目录等信息，给予附加数据结构，例如：
        *:代表可可执行文件； /:代表目录； =:代表 socket 文件； &#124;:代表 FIFO 文件；
  -h  ：将文件大小以人类较易读的方式（例如 GB, KB 等等）列出来；
  -i  ：列出 inode 号码
  -l  ：长数据串行出，包含文件的属性与权限等等数据；（常用）
  -n  ：列出 UID 与 GID 而非使用者与群组的名称 
  -r  ：将排序结果反向输出，例如：原本文件名由小到大，反向则为由大到小；
  -R  ：连同子目录内容一起列出来，等于该目录下的所有文件都会显示出来；
  -S  ：以文件大小大小排序，而不是用文件名排序；
  -t  ：依时间排序，而不是用文件名。
  --color=never  ：不要依据文件特性给予颜色显示；
  --color=always ：显示颜色
  --color=auto   ：让系统自行依据设置来判断是否给予颜色
  --full-time    ：以完整时间模式 （包含年、月、日、时、分） 输出
  --time={atime,ctime} ：输出 access 时间或改变权限属性时间 （ctime）而非内容变更时间 （modification time）
  ```
  ```
  [[email protected] ~]# ls -al
  total 48
  dr-xr-x---.   5     root     root    4096   May 29 16:08   .
  dr-xr-xr-x.  17     root     root    4096   May  4 17:56   ..
  -rw-------.   1     root     root    1816   May  4 17:57   anaconda-ks.cfg
  -rw-------.   1     root     root     927   Jun  2 11:27   .bash_history
  -rw-r--r--.   1     root     root      18   Dec 29  2013   .bash_logout
  -rw-r--r--.   1     root     root     176   Dec 29  2013   .bash_profile
  -rw-r--r--.   1     root     root     176   Dec 29  2013   .bashrc
  drwxr-xr-x.   3     root     root      17   May  6 00:14   .config               &lt;=范例说明处
  drwx------.   3     root     root      24   May  4 17:59   .dbus
  -rw-r--r--.   1     root     root    1864   May  4 18:01   initial-setup-ks.cfg  &lt;=范例说明处
  [    1    ] [ 2 ]  [  3 ]   [  4 ]  [  5 ]  [     6     ]  [       7          ]
  [  权限   ] [链接] [拥有者]  [群组] [文件大小][ 修改日期  ]  [      文件名        ]
  ```
- ### cp（复制文件或目录）
  ```
  cp [-adfilprsu]  来源文件（source）  目标文件（destination）
  cp [options]  source1  source2  source3   directory
  选项与参数：
  -a  ：相当于 -dr --preserve=all 的意思（常用）
  -d  ：若来源文件为链接文件的属性（link file），则复制链接文件属性而非文件本身；
  -f  ：为强制（force）的意思，若目标文件已经存在且无法打开，则移除后再尝试一次；
  -i  ：若目标文件（destination）已经存在时，在覆盖时会先询问动作的进行（常用）
  -l  ：进行硬式链接（hard link）的链接文件创建，而非复制文件本身；
  -p  ：连同文件的属性（权限、用户、时间）一起复制过去，而非使用默认属性（备份常用）；
  -r  ：递回持续复制，用于目录的复制行为；（常用）
  -s  ：复制成为符号链接文件 （symbolic link）
  -u  ：destination 比 source 旧才更新 destination，或 destination 不存在的情况下才复制。
  --preserve=all ：除了 -p 的权限相关参数外，还加入 SELinux 的属性, links, xattr 等也复制了。
  如果来源文件有两个以上，则最后一个目的文件一定要是“目录”才行！
  ```
- ### rm（移动文件与目录，或更名）
  ```
  mv  [-fiu]  source  destination
  mv [options]  source1  source2  source3  directory
  选项与参数：
  -f  ：force 强制的意思，如果目标文件已经存在，不会询问而直接覆盖；
  -i  ：若目标文件 （destination） 已经存在时，就会询问是否覆盖！
  -u  ：若目标文件已经存在，且 source 比较新，才会更新 （update）
  ```
- ### basename（取得路径的文件名称）
  ```
  basename  /etc/sysconfig/network
  network         取得最后的文件名
  ```
- ### dirname （取得目录名称）
  ```
  dirname  /etc/sysconfig/network
  /etc/sysconfig   取得目录名
  ```