## while do done， until do done （不定循环）
### while do done（条件成立执行）
```
while [ condition ]     #条件成立执行
do            #循环的开始
    程序段落
done          #循环的结束
```
```
#!/bin/bash
# Program:
#       while do done练习：从1+到100
# History:
# 2023/04/16    yxj     First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

s=0
i=0
while [ "${i}" != "100" ]
do
        i=$(($i+1))   # ++i
        s=$(($s+$i))  # s+=i
done
echo "1+2+3+...+100 ==  $s"

yxj@yxj-computer:~/bin$ sh cal_1_100.sh 
1+2+3+...+100 ==  5050
```
### until do done（条件不成立执行）
```
until [ condition ]     #条件不成立执行
do
    程序段落
done
```