## 变量的取用与设置：echo
```
[[email protected] ~]$ echo $variable
[[email protected] ~]$ echo $PATH
/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/dmtsai/.local/bin:/home/dmtsai/bin
[[email protected] ~]$ echo ${PATH}     #比较推荐这个用法
```
## 变量的设定规则
- 变量与变量内容以一个等号'='来链接
    ```
    myname=VBird
    ```
- 等号两边不能直接接空白字符
- 变量名称只能是英文字母与数字，但是开头字符不能是数字
- 变量内容若有空白字符可使用双引号'“'或单引号'''将变量内容结合起来
  - 双引号内的特殊字符如 $ 等，可以保有原本的特性
    ```
    var=“lang is $LANG”
    则echo $var  可得  lang is zh_TW. UTF-8
    ```
  - 单引号内的特殊字符则仅为一般字符 （纯文字）
    ```
    var='lang is $LANG'
    则 echo $var  可得  lang is $LANG』
    ```
- 若该变量为扩增变量内容时，则可用 “$变量名称” 或 ${变数} 累加内容
    ```
    PATH=“$PATH”：/home/bin  或  PATH=${PATH}：/home/bin
    ```
- 若该变量需要在其他子程序执行，则需要以 export 来使变量变成环境变量
    ```
    export PATH
    ```
- 通常大写字符为系统预设变量，自行设定变量可以使用小写字符，方便判断（纯粹依照用户兴趣与嗜好）
- 取消变量的方法为使用 unset ：'unset 变量名例如取消 myname 的设置