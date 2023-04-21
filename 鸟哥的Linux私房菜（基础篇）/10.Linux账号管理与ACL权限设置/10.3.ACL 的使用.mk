## setfacl：设置acl权限
```
[root@study ~]# setfacl [-bkRd] [{-m&#124;-x} acl参数] 目标文件名
选项与参数：
-m ：设置后续的 acl 参数给文件使用，不可与 -x 合用；
-x ：删除后续的 acl 参数，不可与 -m 合用；
-b ：移除“所有的” ACL 设置参数；
-k ：移除“默认的” ACL 参数，关于所谓的“默认”参数于后续范例中介绍；
-R ：递回设置 acl ，亦即包括次目录都会被设置起来；
-d ：设置“默认 acl 参数”的意思！只对目录有效，在该目录新建的数据会引用此默认值
```
- ### 1.针对特定使用者的方式：
```
设置规范：“ u:[使用者帐号列表]:[rwx] ”

#范例：
root@yxj-computer:/tmp# touch test
root@yxj-computer:/tmp# ll test
-rw-r--r-- 1 root root 0  4月 21 19:24 test

# u 后无使用者，代表文件拥有者
root@yxj-computer:/tmp# setfacl -m u:yxj:rx test    
root@yxj-computer:/tmp# ll test

-rw-r-xr--+ 1 root root 0  4月 21 19:24 test*
root@yxj-computer:/tmp# setfacl -m u::rwx test
root@yxj-computer:/tmp# ll test
-rwxr-xr--+ 1 root root 0  4月 21 19:24 test*
```
---
## getfacl：列出acl权限
```
[root@study ~]# getfacl filename
选项与参数：
跟setfacl相同
```
```
#范例：getfacl的使用
root@yxj-computer:/tmp# getfacl test
# file: test        <== 文件名
# owner: root       <== 文件拥有者
# group: root       <== 文件所属群组
user::rwx           <== 文件使用者权限，空着代表拥有者的权限，为rwx
user:yxj:r-x        <== yxj的权限，为rx
group::r--          <== 文件群组的权限，为r
mask::r-x           <== 文件默认拥有权限，为rx
other::r--          <== 其它者拥有权限，为r
```

- ### 2.针对特定群组的方式：
    ```
    设置规范：“ g:[群组列表]:[rwx] ”

    #范例
    root@yxj-computer:/tmp# setfacl -m g:yxj:rx test
    root@yxj-computer:/tmp# getfacl test
    #file: test
    # owner: root
    # group: root
    user::rwx
    user:yxj:r-x
    group::r--
    group:yxj:r-x       <== 群组权限设置,为rx
    mask::r-x
    other::r--
    ```
- ### 3.针对有效权限 mask 的设置方式：
    ```
    设置规范：“ m:[rwx] ”

    #范例
    root@yxj-computer:/tmp# getfacl test
    # file: test
    # owner: root
    # group: root
    user::rwx
    user:yxj:r-x			#effective:r-- <== yxj和mask均存在，仅有r生效
    group::r--
    group:yxj:r-x			#effective:r--
    mask::r--
    other::r--
    ```
  - **mask是规范最大允许权限**
- ### 4.使用默认权限设置目录未来文件的 ACL 权限继承
    ```
    设置规范：“ d:[ug]:使用者列表:[rwx] ”

    #范例
    # 让 myuser1 在 /srv/projecta 下面一直具有 rx 的默认权限！
    [root@study ~]# setfacl -m d:u:myuser1:rx /srv/projecta
    [root@study ~]# getfacl /srv/projecta
    # file: srv/projecta
    # owner: root
    # group: projecta
    # flags: -s-
    user::rwx
    user:myuser1:r-x
    group::rwx
    mask::rwx
    other::---
    default:user::rwx
    default:user:myuser1:r-x
    default:group::rwx
    default:mask::rwx
    default:other::---

    [root@study ~]# cd /srv/projecta
    [root@study projecta]# touch zzz1
    [root@study projecta]# mkdir zzz2
    [root@study projecta]# ll -d zzz*
    -rw-rw----+ 1 root projecta 0 Jul 21 17:50 zzz1
    drwxrws---+ 2 root projecta 6 Jul 21 17:51 zzz2
    ```