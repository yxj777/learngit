## 命令别名设定： alias， unalias
- 命名别名用alias
- 取消命名别名用unalias
## 历史命令：history
```
[dmtsai@study ~]$ history [n]
[dmtsai@study ~]$ history [-c]
[dmtsai@study ~]$ history [-raw] histfiles
选项与参数：
n   ：数字，意思是“要列出最近的 n 笔命令列表”的意思！
-c  ：将目前的 shell 中的所有 history 内容全部消除
-a  ：将目前新增的 history 指令新增入 histfiles 中，若没有加 histfiles ，
      则默认写入 ~/.bash_history
-r  ：将 histfiles 的内容读到目前这个 shell 的 history 记忆中；
-w  ：将目前的 history 记忆内容写入 histfiles 中！
```
```
[dmtsai@study ~]$ !number
[dmtsai@study ~]$ !command
[dmtsai@study ~]$ !!
选项与参数：
number  ：执行第几笔指令的意思；
command ：由最近的指令向前搜寻“指令串开头为 command”的那个指令，并执行；
!!      ：就是执行上一个指令（相当于按↑按键后，按 Enter）
```
- 历史命令的读取与记录
  - 以 bash 登陆 Linux 主机之后，系统会主动的由主文件夹的 ~/.bash_history 读取以前曾经下过的指令，记录的笔数与HISTFILESIZE 变量有关
  - 历史命令在我登出时，会将最近的 HISTFILESIZE 笔记录到我的纪录文件中
  - 以用 history -w 强制立刻写入，~/.bash_history 记录的笔数永远都是 HISTFILESIZE 那么多，旧的讯息会被主动的拿掉！ 仅保留最新的