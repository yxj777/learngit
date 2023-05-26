```
#!/bin/bash
# Program:
#       shell script练习题：计算还有多久过生日
# History:
# 2023/04/16    yxj
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/yxj/bin
export PATH

echo "请输入你的生日"
read bri
bri=$(($bri % 10000))
now=$(date  +%m%d)
year=$(date +%Y)
if [ "$now" == "$bri" ]; then
        echo "祝你今天生日快乐！"
elif [ "$now" -lt "$bri" ]; then
        time=$(($((`date --date="$year$bri" +%s`-`date +%s`))/60/60/24))
        echo "你的生日还有${time}天"
fi

```