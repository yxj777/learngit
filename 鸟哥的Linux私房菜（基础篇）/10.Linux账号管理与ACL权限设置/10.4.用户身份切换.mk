## su：切换用户
```
[root@study ~]# su [-lm] [-c 指令] [username]
选项与参数：
-   ：单纯使用 - 如“ su - ”代表使用 login-shell 的变量文件读取方式来登陆系统；
      若使用者名称没有加上去，则代表切换为 root 的身份。
-l  ：与 - 类似，但后面需要加欲切换的使用者帐号！也是 login-shell 的方式。
-m  ：-m 与 -p 是一样的，表示“使用目前的环境设置，而不读取新使用者的配置文件”
-c  ：仅进行一次指令，所以 -c 后面可以加上指令喔！
```
- 单纯使用'su'切换身份，读取的变量设定方式为 non-login shell 的方式,这种方式很多原本的变量不会被改变

      ```
      yxj@yxj-computer:~$ su
      密码： 
      root@yxj-computer:/home/yxj# id
      uid=0(root) gid=0(root) 组=0(root)
      root@yxj-computer:/home/yxj# env | grep 'yxj'
      PWD=/home/yxj
      LOGNAME=yxj
      USERNAME=yxj
      USER=yxj
      ```
- 若要完整的切换到新用户的环境，必须要使用' su - username '或' su -l username '
---
## sudo
```
[root@study ~]# sudo [-b] [-u 新使用者帐号]
选项与参数：
-b  ：将后续的指令放到背景中让系统自行执行，而不与目前的 shell 产生影响
-u  ：后面可以接欲切换的使用者，若无此项则代表切换身份为 root
```
- ### 流程
  - 1.当用户执行sudo时，系统于/etc/sudoers 档案中搜寻该用户是否有执行sudo的权限;
  - 2.若用户具有可执行 sudo 的权限后，便让用户'输入用户自己的密码'来确认;
  - 3.若密码输入成功，便开始进行sudo后续接的指令（但 root 执行 sudo 时，不需要输入密码）;
  - 4.若欲切换的身份与执行者身份相同，那也不需要输入密码
- ### visudo 与 /etc/sudoers
  - #### 单一用户可进行 root 所有命令，与 sudoers 文件语法
      ```
      [root@study ~]# visudo
      ....(前面省略)....
      root    ALL=(ALL)       ALL  
      yxj     ALL=(ALL)       ALL  <== 新建
      ```
      ```
      使用者帐号       可下达指令的主机名称=（可切换的身份）  可下达的指令
      root                         ALL=（ALL）           ALL   <== 这是默认值
      ```
    - 使用者账号：哪个账号可以使用sudo
    - 可下达指令的主机名称： 透过 sudo 对某些主机下达指令的意思，针对本机的话，这个项目可以都填写为 ALL 即可
    - 可切换的身份：可以切换成什么身份
    - 可下达的指令：可用该身份下达什么指令，必须使用绝对路径
  - #### 利用群组以及免密码的功能处理 visudo
      - % 为群组的意思
      ```
      root@yxj-computer:~# visudo 
      %sudo     ALL=(ALL)    ALL
      root@yxj-computer:~# usermod -a -G wheel yxj    <== 将yxj加入sudo的支持
      ```
    - NOPASSWD为免除密码的关键字
      ```
      root@yxj-computer:~# visudo 
      %sudo     ALL=(ALL)   NOPASSWD: ALL
      ```   
  - #### 有限制的指令操作
      ```
      [root@study ~]# visudo 
      myuser1	ALL=(root)  !/usr/bin/passwd, /usr/bin/passwd [A-Za-z]*, !/usr/bin/passwd root
      #可以执行『 passwd 任意字符』，但是『 passwd 』与『 passwd root 』这两个指令例外
      ```
    - “ ！ ” 代表'不可执行'
  - #### 通过别名建置 visudo
      ```
      [root@study ~]# visudo
      User_Alias ADMPW = pro1, pro2, pro3, myuser1, myuser2
      Cmnd_Alias ADMPWCOM = !/usr/bin/passwd, /usr/bin/passwd [A-Za-z]*, !/usr/bin/passwd root
      ADMPW   ALL=(root)  ADMPWCOM
      ```
    - User_Alias建立新账号，Cmnd_(命令别名)，Host_Alias(来源主机别称别名)
    - 后面接的必须都是大写字符
  - #### sudo 的时间间隔
    - 两次执行sudo的间隔在五分钟内，那么再次执行sudo时就不需要再次输入密码
  - #### sudo 搭配 su 的使用方式
      ```
      [root@study ~]# visudo
      User_Alias  ADMINS = pro1, pro2, pro3, myuser1
      ADMINS ALL=(root)  /bin/su -
      ```
    - 只要输入' sudo su - '并且输入'自己的密码'后， 立刻变成 root 的身份