## shell script 的追踪与 debug
```
[dmtsai@study ~]$ sh [-nvx] scripts.sh
选项与参数：
-n  ：不要执行 script，仅查询语法的问题；
-v  ：再执行 sccript 前，先将 scripts 的内容输出到屏幕上；
-x  ：将使用到的 script 步骤显示到屏幕上
```
```
yxj@yxj-computer:~$ sh -x for_num.sh 
+ PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/yxj/bin
+ export PATH
+ read -p 请输入从1+到的数 num
请输入从1+到的数3
+ s=0
+ (( i=1  ))
+ (( i<=3  ))
+ s=1
+ (( i++  ))
+ (( i<=3  ))
+ s=3
+ (( i++  ))
+ (( i<=3  ))
+ s=6
+ (( i++  ))
+ (( i<=3  ))
+ echo 相加为6
相加为6
```