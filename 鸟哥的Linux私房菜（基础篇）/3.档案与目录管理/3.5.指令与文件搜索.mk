## 指令文件名的搜寻
- ### which（寻找“可执行文件）
  -   根据“PATH”这个环境变量所规范的路径，去搜寻“可执行文件”的文件名
  ```
  which  [-a]  command
  选项或参数：
  -a ：将所有由 PATH 目录中可以找到的指令均列出，而不止第一个被找到的指令名称
    ```
---
## 文件名的搜索
- ### whereis（由一些特定的目录中寻找文件名）
  - whereis 主要是针对 /bin /sbin 下面的可执行文件， 以及 /usr/share/man 下面的 man page 文件
    ```
    whereis [-bmsu] 文件或目录名
    选项与参数：
    -l    :可以列出 whereis 会去查询的几个主要目录而已
    -b    :只找 binary 格式的文件
    -m    :只找在说明文档 manual 路径下的文件
    -s    :只找 source 来源文件
    -u    :搜寻不在上述三个项目当中的其他特殊文件
    ```
- ### locate/updatedb
  - locate：依据 /var/lib/mlocate 内的数据库记载，找出使用者输入的关键字文件名（数据库可能一天一更新）    - 
  - updatedb：根据 /etc/updatedb.conf 的设置去搜寻系统硬盘内的文件名，并更新 /var/lib/mlocate 内的数据库文件；
    ```
    locate [-ir] keyword
    选项与参数：
    -i  ：忽略大小写的差异；
    -c  ：不输出文件名，仅计算找到的文件数量
    -l  ：仅输出几行的意思，例如输出五行则是 -l 5
    -S  ：输出 locate 所使用的数据库文件的相关信息，包括该数据库纪录的文件/目录数量等
    -r  ：后面可接正则表达式的显示方式
        
    ```
- ### find
  ```
  find  [PATH]  [option]  [action]
  选项与参数：
  1\. 与时间有关的选项：共有 -atime, -ctime 与 -mtime ，以 -mtime 说明
  -mtime  n ：n 为数字，意义为在 n 天之前的“一天之内”被更动过内容的文件；
  -mtime +n ：列出在 n 天之前（不含 n 天本身）被更动过内容的文件文件名；
  -mtime -n ：列出在 n 天之内（含 n 天本身）被更动过内容的文件文件名。
  -newer file ：file 为一个存在的文件，列出比 file 还要新的文件文件名

  范例一：将过去系统上面 24 小时内有更动过内容 （mtime） 的文件列出
  find / -mtime 0
  ```
  - ![](../images/2023-03-19-08-52-16.png)
  - +4代表大于等于5天前的文件名：ex> find /var -mtime +4
  - -4代表小于等于4天内的文件文件名：ex> find /var -mtime -4
  - 4则是代表4-5那一天的文件文件名：ex> find /var -mtime 4
  ```
  选项与参数：
  2\. 与使用者或群组名称有关的参数：
  -uid  n ：n 为数字，使用者的帐号 ID，亦即 UID记录在/etc/passwd，与帐号名称对应的数字；
  -gid  n ：n 为数字，群组名称的 ID，亦即 GID，记录在/etc/group;
  -user  name ：name 为使用者帐号名称;
  -group  name：name 为群组名称 ；
  -nouser    ：寻找文件的拥有者不存在 /etc/passwd 的人;
  -nogroup   ：寻找文件的拥有群组不存在于 /etc/group 的文件;

  范例二：搜寻 /home 下面属于 yxj 的文件
  find  /home  -user  yxj
  ```
  ```
  选项与参数：
  3\. 与文件权限及名称有关的参数：
  -name  filename：搜寻文件名称为 filename 的文件；
  -size  [+-]SIZE：搜寻比 SIZE 还要大（+）或小（-）的文件。这个 SIZE 的规格有：
                  c: 代表 Byte， k: 代表 1024Bytes。所以，要找比 50KB
                  还要大的文件，就是“ -size +50k ”;
  -type  TYPE    ：搜寻文件的类型为 TYPE 的，类型主要有：一般正规文件 （f）, 设备文件 （b, c）,
                  目录 （d）, 链接文件 （l）, socket （s）, 及 FIFO （p） 等属性;
  -perm  mode  ：搜寻文件权限“刚好等于” mode 的文件，这个 mode 为类似 chmod
                  的属性值;
  -perm  -mode ：搜寻文件权限“带有 mode 的权限”的文件
                  如搜索： -rwxr--r-- ，亦 -perm  -0744 
                  结果包含： -rwsr-xr-x ，亦 4755 ;
  -perm  /mode ：搜寻文件权限“包含任一 mode 的权限”的文件
                  如搜索：rwxr-xr-x ，亦 -perm  /755 
                  结果包含： -rw------- ，亦 600;

  范例三：找出来 /usr/bin, /usr/sbin 这两个目录下， 具有 SUID 或 SGID 就列出来该文件
  find  /usr/bin  /usr/sbin  -perm /6000
  ```
  ```
  选项与参数：
  4\. 额外可进行的动作：
  -exec  command ：command 为其他指令，-exec 后面可再接额外的指令来处理搜寻到的结果。
  -print        ：将结果打印到屏幕上，这个动作是默认动作！

  范例四：上个范例找到的文件使用 ls -l 列出来～
  find  /usr/bin  /usr/sbin  -perm  /7000  -exec  ls  -l  {}  \;
  ```
  - {} 代表的是“由 find 找到的内容“
  - exec 一直到 \; 是关键字，代表 find 额外动作的开始 （-exec） 到结束 （\;） ，在这中间的就是 find 指令内的额外动作
  - 因为“ ; ”在 bash 环境下是有特殊意义的，因此利用反斜线来跳脱