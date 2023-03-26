## BIOS搭配MBR/GPT的开机流程
BIOS是写到主板上的一个固件，计算机系统主动执行的第一个程序，流程如下
- BISO：开机主动执行的固件，会认识第一个可开机的设备
- MBR:第一个可开机设备的第一个扇区的主要开机记录区块，内含开机管理程序
- 开机管理程序（Boot loader）：一个可读取核心文件来执行的软件
  - 提供菜单：选择不同的开机项目（多重系统）
  - 载入核心文件：指向开机的程序区段，开始操作系统
  - 转交其他的loader：将开机管理功能转交给其他的loader
- 核心文件：开始操作的系统的功能
Boot loader还可以安装在每个分区的开机扇区（boot sector），形成“多重开机”
---
## UEFI BIOS搭配GPT开机的流程
![](../images/2023-03-14-19-13-20.png)