## if .... then
- ### 单层、简单条件判断式
    ```
    if [ 条件判断式 ]; then
        指令工作内容
    fi  结束if
    ```
  - 可以有多个中括号来隔开
  -  而括号与括号之间，则以 && 或 || 来隔开
        ```
        if [ "${yn}" == "Y" ] || [ "${yn}" == "y" ]; then
            echo "OK, continue"
            exit 0
        ```
- ### 多重、复杂条件判断式
    ```
    if [ 条件判断式一 ]; then
        指令工作内容；
    elif [ 条件判断式二 ]; then
        指令工作内容
    else
        指令工作内容
    fi
    ```
```
#范例：if...then练习

#!/bin/bash
# Program:
#       if...then练习：计算退伍时间：
#               先让用户输入他们的退伍日期;
#               再由现在日期比对退伍日期;
#               由两个日期的比较来显示'还需要几天'才能够退伍的字样
# History:
# 2023/4/15     yxj
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "请输入退伍时间：" endDate
dateChick=$(echo ${endDate} | grep '[0-9]\{8\}')
if [ "${dateChick}" == "" ]; then
        echo "请输入正确日期"
        exit 1
fi

declare -i endDate_s=$(date --date="${endDate}" +%s)
declare -i nowDate_s=$(date +%s)
declare -i dateTotal_s=$((${endDate_s}-${nowDate_s}))
declare -i stod=$((${dateTotal_s}/60/60/24))
if [ "${stod}" -lt "0" ]; then
        echo "在$((-1*${stod}))天前就退役"
else
        echo "还有${stod}天退役"
fi

yxj@yxj-computer:~/bin$ sh cal_retired.sh 
请输入退伍时间：20230417
还有1天退役
```

## case ..... esac
```
case  $变量名称 in   <==关键字为 case ，还有变量前有钱字号
  "第一个变量内容"）   <==每个变量内容建议用双引号括起来，关键字则为小括号 ）
    程序段
    ;;            <==每个类别结尾使用两个连续的分号来处理！
  "第二个变量内容"）
    程序段
    ;;
  *）                  <==最后一个变量内容都会用 * 来代表所有其他值
    不包含第一个变量内容与第二个变量内容的其他程序执行段
    exit 1
    ;;
esac  
```
## function（函数）功能
```
function fname() {
	程式段
}
```
- shell script当中的 function 的设定一定要在程序的最前面
  - 因为 shell script 的执行方式是由上而下，由左而右
- function 也是拥有内建变量
  - 也是函数名为$0, 后续变量为$1，$2...
    ```
    #!/bin/bash
    # Program:
    #       function函数的使用，与function内建变量
    # History:
    # 2023/04/15    yxj
    PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
    export PATH

    function printit(){
            echo "选择 ${1}"
    }

    case ${1} in
    "one")
            printit 1
            ;;
    "two")
            printit 2
            ;;
    "three")
            printit 3
            ;;
    *)
            echo "Usage ${0} {one|two|three}"
            ;;
    esac

    yxj@yxj-computer:~/bin$ sh show123-3.sh one
    选择 1

    ```