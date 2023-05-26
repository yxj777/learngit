## 账号检查工具
- ### pwck:检查主文件夹是否存在
```
yxj@yxj-computer:~$ sudo pwck
用户“lp”：目录 /var/spool/lpd 不存在
用户“news”：目录 /var/spool/news 不存在
用户“uucp”：目录 /var/spool/uucp 不存在
用户“www-data”：目录 /var/www 不存在
......省略......
```
- ### pwconv
  - 将 /etc/passwd 内的帐号与密码，移动到 /etc/shadow 当中
  - pwconv步骤
    - 比对 /etc/passwd 及 /etc/shadow ，若 /etc/passwd 内存在的帐号并没有对应的 /etc/shadow 密码时，则 pwconv 会去 /etc/login.defs 取用相关的密码数据，并创建该帐号的 /etc/shadow 数据
    - 若 /etc/passwd 内存在加密后的密码数据时，则 pwconv 会将该密码栏移动到 /etc/shadow 内，并将原本的 /etc/passwd 内相对应的密码栏变成 x 
- ### pwunconv
  - 将 /etc/shadow 内的密码栏数据写回 /etc/passwd 当中， 并且删除 /etc/shadow 文件
  - 最好别使用，会删除shadow文件
- ### chpasswd
  - 读入未加密前的密码，并且经过加密后， 将加密后的密码写入 /etc/shadow 当中，常用在大量建设账号
  - 可以Standard input 读入数据，每笔数据的格式是' username：password '
    ```
    echo "yxj:123456" | chpasswd 
    ```