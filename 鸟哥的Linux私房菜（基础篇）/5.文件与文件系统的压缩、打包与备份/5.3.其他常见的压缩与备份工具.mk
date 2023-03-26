## dd
```
[root@www ~]# dd if="input_file" of="output_file" bs="block_size" \
> count="number"

选项与参数：
if   ：就是 input file 也可以是设备
of   ：就是 output file 也可以是设备
bs   ：规划的一个 block 的大小，若未指定则预设是 512 bytes(一个 sector 的大小)
count：多少个 bs 的意思。
```
```
# 范例：将 /etc/passwd 备份到 /tmp/passwd.back 当中
root@yxj-computer:~# dd if=/etc/passwd of=/tmp/passwd.back
记录了5+1 的读入
记录了5+1 的写出
2881字节（2.9 kB，2.8 KiB）已复制，0.000242658 s，11.9 MB/s
root@yxj-computer:~# ll /etc/passwd /tmp/passwd.back
-rw-r--r-- 1 root root 2881  3月 26 16:33 /etc/passwd
-rw-r--r-- 1 root root 2881  3月 26 19:22 /tmp/passwd.back
```
- 默认 dd 是一个一个扇区去读/写的，即使没有用到的扇区也会倍写入备份文件中
- 因此这个文件会变得跟原本的磁盘一模一样大
---
## cpio
```
[root@www ~]# cpio -ovcB  > [file|device] <==备份
[root@www ~]# cpio -ivcdu < [file|device] <==还原
[root@www ~]# cpio -ivct  < [file|device] <==察看
备份会使用到的选项与参数：
  -o ：将数据 copy 输出到文件或设备上
  -B ：让默认的 Blocks 可以增加至 5120 Bytes ，默认是 512 Bytes ！
　  　 这样的好处是可以让大文件的储存速度加快
还原会使用到的选项与参数：
  -i ：将数据自文件或设备 copy 出来系统当中
  -d ：自动创建目录！使用 cpio 所备份的数据内容不见得会在同一层目录中，因此我们
       必须要让 cpio 在还原时可以创建新目录，此时就得要 -d 选项的帮助！
  -u ：自动的将较新的文件覆盖较旧的文件！
  -t ：需配合 -i 选项，可用在"察看"以 cpio 创建的文件或设备的内容
一些可共享的选项与参数：
  -v ：让储存的过程中文件名称可以在屏幕上显示
  -c ：一种较新的 portable format 方式储存
```
```
# 找出 /boot 下面的所有文件，然后备份到 /tmp/boot.cpio
root@yxj-computer:~# cd /
root@yxj-computer:/# find boot -print

....（省略显示）....
root@yxj-computer:~# find boot | cpio -ocvB > /tmp/boot.cpio
....（省略显示）....
```
- cd到 \ 再找 boot 的原因，为 -P （绝对路径），解压后会覆盖文件

```
# 在 /root/ 目录下解开
root@yxj-computer:/# cd ~
root@yxj-computer:~# cpio -idvc < /tmp/boot.cpio
```