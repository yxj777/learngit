## 查询使用者：w, who, last, lastlog
- ### w：显示已登录用户以及他们正在干什么
    ```
    yxj@yxj-computer:~$ w
    19:50:28 up  3:42,  1 user,  load average: 0.78, 0.70, 0.55
    USER     TTY      来自           LOGIN@   IDLE   JCPU   PCPU WHAT
    yxj      tty2     tty2  
    ```
  - 第一行显示目前的时间、开机 （up） 多久，几个使用者在系统上平均负载等
- ### who：显示当前已登录的用户信息
    ```
    yxj@yxj-computer:~$ who
    yxj      tty2         2023-05-13 16:08 (tty2)
    ```
- ### last：显示最近登录的用户列表
    ```
    yxj@yxj-computer:~$ last
    yxj      tty2         tty2             Sat May 13 16:08   still logged in
    reboot   system boot  5.19.0-38-generi Sat May 13 16:07   still running
    yxj      tty2         tty2             Sat May 13 21:41 - crash  (-5:33)
    reboot   system boot  5.19.0-38-generi Sat May 13 21:41   still running
    yxj      tty2         tty2             Sat May 13 21:39 - down   (00:01)
    ......省略......
    ```
- ### lastlog：所有用户的最近登录情况
    ```
    用户名           端口     来自             最后登录时间
    root                                       **从未登录过**
    daemon                                     **从未登录过**
    ......省略......
    yxj              tty4                      一 3月 27 10:18:07 +0800 2023
    ```
    - lastlog 会去读取 /var/log/lastlog 文件
---
##  使用者对谈： write, mesg, wall
- ### write：将信息传给接受者
```
[root@study ~]# write 使用者帐号 [使用者所在终端接口]
```
```
#范例：
root@yxj-computer:~# write yxj tty3
hello yxj

#tty3收到的内容
Message from root on pst/0 at 01:57 ...
hello
EOF
```
  - write信息会打断接受者原本的工作
- ### mesg：是否接受其他终端的信息
    ```
    yxj@yxj-computer:~/桌面$ mesg n
    yxj@yxj-computer:~/桌面$ mesg
    是 n

    ```
    - mesg对root传来的信息无法抵抗
    - root的mesg是n，其他其它终端无法向root传信息
- ### wall ：向所有人发消息
    ```
    root@yxj-computer:~# wall "Hello,my name is root"
    ```