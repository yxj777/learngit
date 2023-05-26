## 新增与删除用户：useradd，相关配置文件，passwd，usermod，userdel
- ### useradd：新建用户
```
[root@study ~]# useradd [-u UID] [-g 初始群组] [-G 次要群组] [-mM]\
>  [-c 说明栏] [-d 主文件夹绝对路径] [-s shell] 使用者帐号名
选项与参数：
-u  ：后面接的是 UID ，是一组数字。直接指定一个特定的 UID 给这个帐号；
-g  ：初始群组 initial group 
      该群组的 GID 会被放置到 /etc/passwd 的第四个字段内。
-G  ：后面接的群组名称则是这个帐号还可以加入的群组。
      这个选项与参数会修改 /etc/group 内的相关数据喔！
-M  ：强制！不要创建使用者主文件夹！（系统帐号默认值）
-m  ：强制！要创建使用者主文件夹！（一般帐号默认值）
-c  ：/etc/passwd 的第五栏的说明内容
-d  ：指定某个目录成为主文件夹，而不要使用默认值。务必使用绝对路径！
-r  ：创建一个系统的帐号，这个帐号的 UID 会有限制 
-s  ：后面接一个 shell ，若没有指定则默认是 /bin/bash 
-e  ：后面接一个日期，格式为“YYYY-MM-DD”此项目可写入 shadow 第八字段，
      亦即帐号失效日的设置项目
-f  ：后面接 shadow 的第七字段项目，指定密码是否会失效。0为立刻失效，
      -1 为永远不失效（密码只会过期而强制于登陆时重新设置）
```
```
#范例：新建用户useradd的使用
root@yxj-computer:~# useradd testuser
root@yxj-computer:~# ll -d /home/usertest
drwxr-x--- 2 usertest usertest 4096  4月 21 14:55 /home/usertest/

root@yxj-computer:~# grep testuser /etc/passwd /etc/shadow /etc/group
/etc/passwd:usertest:x:1001:1001::/home/usertest:/bin/sh
/etc/shadow:usertest:!:19468:0:99999:7:::
/etc/group:usertest:x:1001:
```
- ### useradd 参考文件
  - useradd -D 可以调出默认值，数据其实是由 /etc/default/useradd
    ```
    root@yxj-computer:~# useradd -D
    GROUP=100               <==默认的群组
    HOME=/home              <==默认的主文件夹所在目录
    INACTIVE=-1             <==密码失效日，在 shadow 内的第 7 栏
    EXPIRE=                 <==帐号失效日，在 shadow 内的第 8 栏
    SHELL=/bin/sh           <==默认的 shell
    SKEL=/etc/skel          <==使用者主文件夹的内容数据参考目录
    CREATE_MAIL_SPOOL=no    <==是否主动帮使用者创建邮件信箱
    ```
  - #### /etc/login.defs 设置
    ```
    MAIL_DIR        /var/mail/  <==使用者默认邮件信箱放置目录

    PASS_MAX_DAYS   99999    <==/etc/shadow 内的第 5 栏，多久需变更密码日数
    PASS_MIN_DAYS   0        <==/etc/shadow 内的第 4 栏，多久不可重新设置密码日数
    PASS_MIN_LEN    5        <==密码最短的字符长度，已被 pam 模块取代，失去效用！
    PASS_WARN_AGE   7        <==/etc/shadow 内的第 6 栏，过期前会警告的日数

    UID_MIN          1000    <==使用者最小的 UID，意即小于 1000 的 UID 为系统保留
    UID_MAX         60000    <==使用者能够用的最大 UID
    SYS_UID_MIN       201    <==保留给使用者自行设置的系统帐号最小值 UID
    SYS_UID_MAX       999    <==保留给使用者自行设置的系统帐号最大值 UID
    GID_MIN          1000    <==使用者自订群组的最小 GID，小于 1000 为系统保留
    GID_MAX         60000    <==使用者自订群组的最大 GID
    SYS_GID_MIN       201    <==保留给使用者自行设置的系统帐号最小值 GID
    SYS_GID_MAX       999    <==保留给使用者自行设置的系统帐号最大值 GID

    UMASK           022      <==使用者主文件夹创建的 umask ，因此权限会是 755
    USERGROUPS_ENAB yes      <==使用 userdel 删除时，是否会删除初始群组
    ENCRYPT_METHOD SHA512    <==密码加密的机制使用的是 sha512 这一个机制！
    ```
      - UID/GID 指定数值：当系统给予一个UID时
        - 1.先参考 UID_MIN 设置取得最小数值
        - 2.由 /etc/passwd 搜寻最大的 UID 数值，
        - 3.将 （1） 与 （2） 相比，找出最大的那个再加一就是新账号的 UID 了
  - 使用useradd建立账号时，会参考
    - /etc/default/useradd
    - /etc/login.defs
    - /etc/skel/*
- ### passwd：设置密码
    ```
    [root@study ~]# passwd [--stdin] [帐号名称]  <==所有人均可使用来改自己的密码
    [root@study ~]# passwd [-l] [-u] [--stdin] [-S] \
    >  [-n 日数] [-x 日数] [-w 日数] [-i 日期] 帐号 <==root 功能
    选项与参数：
    --stdin ：可以通过来自前一个管线的数据，作为密码输入，对 shell script 有帮助！
    -l  ：是 Lock 的意思，会将 /etc/shadow 第二栏最前面加上 ! 使密码失效；
    -u  ：与 -l 相对，是 Unlock 的意思！
    -S  ：列出密码相关参数，亦即 shadow 文件内的大部分信息。
    -n  ：后面接天数，shadow 的第 4 字段，多久不可修改密码天数
    -x  ：后面接天数，shadow 的第 5 字段，多久内必须要更动密码
    -w  ：后面接天数，shadow 的第 6 字段，密码过期前的警告天数
    -i  ：后面接“日期”，shadow 的第 7 字段，密码失效日期
    ```
    ```
    #范例：passwd的使用
    root@yxj-computer:~# passwd usertest
    新的 密码： 
    无效的密码： 密码少于 8 个字符
    重新输入新的 密码： 
    抱歉，密码不匹配。
    新的 密码： 
    重新输入新的 密码： 
    passwd：已成功更新密码
    ```
    -  要帮一般帐号建立密码需要使用『 passwd 帐号 』的格式，使用『 passwd '表示修改自己的密码！ 
- ### chage：设置用户密码参数
    ```
    [root@study ~]# chage [-ldEImMW] 帐号名
    选项与参数：
    -l ：列出该帐号的详细密码参数；
    -d ：后面接日期，修改 shadow 第三字段（最近一次更改密码的日期），格式 YYYY-MM-DD
    -E ：后面接日期，修改 shadow 第八字段（帐号失效日），格式 YYYY-MM-DD
    -I ：后面接天数，修改 shadow 第七字段（密码失效日期）
    -m ：后面接天数，修改 shadow 第四字段（密码最短保留天数）
    -M ：后面接天数，修改 shadow 第五字段（密码多久需要进行变更）
    -W ：后面接天数，修改 shadow 第六字段（密码过期前警告日期）
    ```
    ```
    #范例：chage的使用
    root@yxj-computer:~# chage -l usertest
    最近一次密码修改时间					： 4月 21, 2023
    密码过期时间					： 从不
    密码失效时间					： 从不
    帐户过期时间						： 从不
    两次改变密码之间相距的最小天数		：0
    两次改变密码之间相距的最大天数		：99999
    在密码过期之前警告的天数	：7
    ```
    ```
    #范例：第一次登录使用用户名为预设密码，但更改为新密码后才能进入bash环境
    root@yxj-computer:~# useradd usertest
    root@yxj-computer:~# echo "usertest" | passwd --stdin agetest
    root@yxj-computer:~# chage -d 0 usertest
    root@yxj-computer:~# chage -l usertest 
    最近一次密码修改时间					： 密码必须更改
    密码过期时间					： 密码必须更改
    密码失效时间					： 密码必须更改
    帐户过期时间						： 从不
    两次改变密码之间相距的最小天数		：0
    两次改变密码之间相距的最大天数		：99999
    在密码过期之前警告的天数	：7
    root@yxj-computer:~# exit

    yxj@yxj-computer:/tmp$ su usertest
    密码： 
    您必须立即更改密码（管理员强制）。
    新的 密码： 
    重新输入新的 密码：
    ```
- ### usermod：设置用户参数
    ```
    [root@study ~]# usermod [-cdegGlsuLU] username
    选项与参数：
    -c  ：后面接帐号的说明，即 /etc/passwd 第五栏的说明栏，可以加入一些帐号的说明。
    -d  ：后面接帐号的主文件夹，即修改 /etc/passwd 的第六栏；
    -e  ：后面接日期，格式是 YYYY-MM-DD 也就是在 /etc/shadow 内的第八个字段数据啦！
    -f  ：后面接天数，为 shadow 的第七字段。
    -g  ：后面接初始群组，修改 /etc/passwd 的第四个字段，亦即是 GID 的字段！
    -G  ：后面接次要群组，修改这个使用者能够支持的群组，修改的是 /etc/group 啰～
    -a  ：与 -G 合用，可“增加次要群组的支持”而非“设置”喔！
    -l  ：后面接帐号名称。亦即是修改帐号名称， /etc/passwd 的第一栏！
    -s  ：后面接 Shell 的实际文件，例如 /bin/bash 或 /bin/csh 等等。
    -u  ：后面接 UID 数字啦！即 /etc/passwd 第三栏的数据；
    -L  ：暂时将使用者的密码冻结，让他无法登陆。其实仅改 /etc/shadow 的密码栏。
    -U  ：将 /etc/shadow 密码栏的 ! 拿掉，解冻啦！
    ```
- ### userdel：删除用户
    ```
    [root@study ~]# userdel [-r] username
    选项与参数：
    -r  ：连同使用者的主文件夹也一起删除
    ```
---
## 用户功能
- ### id：查询UID/GID等信息
```
#范例：id的使用
uid=1000(yxj) gid=1000(yxj) 组=1000(yxj),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),122(lpadmin),135(lxd),136(sambashare)
```
- ### finger：查询用户信息
    ```
    [root@study ~]# finger [-s] username
    选项与参数：
    -s  ：仅列出使用者的帐号、全名、终端机代号与登陆时间等等；
    -m  ：列出与后面接的帐号相同者，而不是利用部分比对 （包括全名部分）
    ```
    ```
    root@yxj-computer:~# finger yxj
    Login: yxj            			Name: yxj
    Directory: /home/yxj                	Shell: /bin/bash
    On since Fri Apr 21 16:18 (CST) on tty2 from tty2
    8 hours 14 minutes idle
    No mail.
    No Plan.
    ```
    - Login：为使用者帐号，亦即 /etc/passwd 内的第一字段;
    - Name：为全名，亦即 /etc/passwd 内的第五字段（或称为注解）;
    - Directory：就是主文件夹了;
    - Shell：就是使用的 Shell 文件所在;
    - Never logged in.：figner 调查使用者登陆主机的情况
    - No mail.：调查 /var/spool/mail 当中的信箱数据
    - No Plan.：调查 ~vbird1/.plan 文件，并将该文件取出来说明！
- ### chfn：设置用户信息
```
[root@study ~]# chfn [-foph] [帐号名]
选项与参数：
-f  ：后面接完整的大名；
-o  ：办公室的房间号码；
-p  ：办公室的电话号码；
-h  ：家里的电话号码！
```
- ### chsh：设置shell
```
[vbird1@study ~]$ chsh [-s]
选项与参数：
-s  ：设置修改自己的 Shell 
```
---
## 新增与删除组
- ### groupadd：新建群组
    ```
    [root@study ~]# groupadd [-g gid] [-r] 群组名称
    选项与参数：
    -g  ：后面接某个特定的 GID ，用来直接给予某个 GID 
    -r  ：创建系统群组，与 /etc/login.defs 内的 GID_MIN 有关。
    ```
    ```
    #范例：groupadd的使用
    root@yxj-computer:~# groupadd grouptest
    root@yxj-computer:~# grep grouptest /etc/group /etc/gshadow
    /etc/group:grouptest:x:1001:
    /etc/gshadow:grouptest:!::
    ```
- ### groupmod：修改群组参数
    ```
    [root@study ~]# groupmod [-g gid] [-n group_name] 群组名
    选项与参数：
    -g  ：修改既有的 GID 数字；
    -n  ：修改既有的群组名称
    ```

    ```
    #范例：groupmod的使用
    root@yxj-computer:~# groupmod -g 1002 -n testgroup grouptest
    root@yxj-computer:~# grep testgroup /etc/group /etc/gshadow
    /etc/group:testgroup:x:1002:
    /etc/gshadow:testgroup:!::
    ```
- ### groupdel：删除群组
```
[root@study ~]# groupdel vbird1
groupdel: cannot remove the primary group of user 'vbird1'
```
  - **当有某个用户的initial group使用该群组时**，无法删除
    - 修改GID或者删除删除使用它的用户
- ### gpasswd：群组管理员功能
```
# 关于系统管理员（root）做的动作：
[root@study ~]# gpasswd groupname
[root@study ~]# gpasswd [-A user1,...] [-M user3,...] groupname
[root@study ~]# gpasswd [-rR] groupname
选项与参数：
    ：若没有任何参数时，表示给予 groupname 一个密码（/etc/gshadow）
-A  ：将 groupname 的主控权交由后面的使用者管理（该群组的管理员）
-M  ：将某些帐号加入这个群组当中！
-r  ：将 groupname 的密码移除
-R  ：让 groupname 的密码栏失效

# 关于群组管理员（Group administrator）做的动作：
[someone@study ~]$ gpasswd [-ad] user groupname
选项与参数：
-a  ：将某位使用者加入到 groupname 这个群组当中！
-d  ：将某位使用者移除出 groupname 这个群组当中。
```
```
#范例：把usertest设为testgroup的管理员
root@yxj-computer:~# gpasswd -A usertest testgroup
root@yxj-computer:~# grep testgroup /etc/group /etc/gshadow
/etc/group:testgroup:x:1001:
/etc/gshadow:testgroup:$6$VtprrdW7n7sU/$RW29tF4cj1hfZI4Xr0n27oHNg1HVgtrlqIzfx8ve2xO8SGgSFKkamDV1SUIX.9HnsmwJ5UQqiMF.Rqs43jzCi.:usertest:
```
---
## 账号管理实例
- 我的用户 pro1， pro2， pro3 是同一个项目计划的开发人员，我想要让这三个用户在同一个目录底下工作， 但这三个用户还是拥有自己的家目录与基本的私有群组。 假设我要让这个项目计划在 /srv/projecta 目录下开发， 可以如何进行
```
[root@study ~]# groupadd projecta
[root@study ~]# useradd -G projecta -c "projecta user" pro1
[root@study ~]# useradd -G projecta -c "projecta user" pro2
[root@study ~]# useradd -G projecta -c "projecta user" pro3
[root@study ~]# echo "password" | passwd --stdin pro1
[root@study ~]# echo "password" | passwd --stdin pro2
[root@study ~]# echo "password" | passwd --stdin pro3

[root@study ~]# mkdir /srv/projecta
[root@study ~]# chgrp projecta /srv/projecta
[root@study ~]# chmod 2770 /srv/projecta
[root@study ~]# ll -d /srv/projecta
drwxrws---. 2 root projecta 6 Jul 20 23:32 /srv/projecta
#权限2770为SGID，
```