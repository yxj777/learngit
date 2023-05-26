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
## for... do... done （固定循环）
```
for var in con1 con2 con3 ...
do
	程式段
done
```
- 第一次循环时， $var 的内容为 con1 ;
- 第二次循环时， $var 的内容为 con2 ;
- 第三次循环时， $var 的内容为 con3 ;
```
#!/bin/bash
# Program:
#       for固定循环练习
# History:
# 2023/04/16    yxj
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

for animal in "小狗" "小猫" "小王八"
do
        echo "这个动物是 ${animal} "
done

yxj@yxj-computer:~$ sh show_animal.sh 
这个动物是 小狗 
这个动物是 小猫 
这个动物是 小王八
```
## for... do... done 的数值处理
```
for （（ 初始值; 条件判断; 执行 ））
do
    程序段
done
```
- 与C语言的for循环类型
```
#!/bin/bash
# Program:
#       for的数值处理练习
# History:
# 2023/04/16    yxj
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "请输入从1+到的数" num
s=0
for (( i=1 ; i<=${num} ; i++ ))
do
        s=$((${s}+${i}))
done
echo "相加为${s}"

yxj@yxj-computer:~$ sh for_num.sh 
请输入从1+到的数10
相加为55
```
## 搭配乱数与数组的实验
```
#!/bin/bash
# Program:
#       乱数与数组实验：
#               每次显示3个要吃的东西，且3个中不能有重复的
# History       yxj
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

eat[1]="小狗"
eat[2]="小猫"
eat[3]="小猪"
eat[4]="小羊"
eat[5]="小牛"
eat[6]="小驴"
eat[7]="小鱼"
eat[8]="小王八"
eat[9]="小丹顶鹤"

eatnum=9
eated=0
while [ "${eated}" -lt 3 ]
do
        check=$((${RANDOM}*${eatnum} / 32767+1))
        flag=0
        if [ "${eated}" -ge 1 ]; then
                for i in $(seq 1 ${eated})
                do
                        if [ ${eatedcon[$i]} == ${check} ]; then
                                flag=1
                        fi
                done
        fi
        if [ ${flag} == 0 ]; then
                echo "今天吃${eat[${check}]}"
                eated=$(( ${eated} + 1 ))
                eatedcon[${eated}]=${check}
        fi
done

```