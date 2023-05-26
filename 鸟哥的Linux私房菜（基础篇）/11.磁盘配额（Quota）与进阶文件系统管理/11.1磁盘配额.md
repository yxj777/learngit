## Quota(ext4下)
1. ### 格式化文件系统
    - mkfs 格式化文件系统时打开 "project,quota" 特性(新文件)
        ```
        mkfs.ext4 -O project,quota <device>
        ```
    - 也可以对旧文件进行update而不影响到现有文件系统中的文件
        ```
        tune2fs -O project,quota /dev/sdb3 
        ```
2. ### 挂载文件系统
    ```
    #使用prjquota选项挂载，则自动开启limit功能
    mount -o prjquota /dev/nvme0n1p13 /home/testQuota
    ```
3. ### 开启/关闭 prjquota 限制
   - #### 查看quota状态
        ```
        quotaon -Ppv <mntpoint>
        ``` 
        ```
        #输出：
        project quota on /home/testQuota (/dev/nvme0n1p13) is on (accounting)
        ```
      - 表示 accounting on, limit off
    - #### quotaon：开启 
      - 手动开启 limit 功能
        ```
        quotaon -P <mntpoint>
        ```
        ```
        #输出
        project quota on /home/testQuota (/dev/nvme0n1p13) is on (enforced)
        ```
      - 表示accounting on, limit on
    - #### quotaoff：关闭
        ```
        quotaoff -P <mntpoint>
        ```
4. ### project id
   - #### 设置project id
     - 使用 chattr -p 设置文件或目录的 project id
          ```
          chattr -p <projectid> <file|directory>
          ```
    - #### 查看 project id
      - 使用 lsattr -p 获取文件的 projec id
        ```
        lsattr -p 
        ```
        ```
        #输出：
        root@yxj-computer:/home/testQuota# lsattr -p 
            0 --------------e------- ./lost+found
            1 --------------e------- ./testDir
            2 --------------e------- ./testFile

        ```
5. ### prjquota 配额
   - #### edquota 设置配额
        ```
        edquota -P -f <mntpoint> <projectid>
        ```
        - 执行 edquota 命令会进入一个 vim 界面，此时用户可以设置 inode/block 的 soft/hard limit
        ```
        root@yxj-computer:/home/testQuota# edquota -P -f /home/testQuota 1
        ```
        - ![](../images/2023-05-20-11-05-44.png)
    - #### setquota 设置配额
      - 也可以使用 setquota 设置特定 project id 的配额
        ```
        setquota -P <projectid> <block-softlimit> <block-hardlimit> <inode-softlimit> <inode-hardlimit> <mntpoint>
        ```
    - #### repquota 查看配额
        ```
        repquota -P <mntpoint>
        ```
        ```
        #范例
        root@yxj-computer:/home/testQuota# edquota -P -f /home/testQuota 1
        root@yxj-computer:/home/testQuota# repquota -P /home/testQuota
        *** project 配额的报告清单 基于设备 /dev/nvme0n1p13

        块超额时限：7天；节点超额时限：7天
                                Block limits                File limits
        Project   已用 软限额 硬限额 超额时限 已用 软限额 硬限额 超额时限

        ----------------------------------------------------------------------
        #0        --      20       0       0     2     0     0       
        #1        --       4  204800  409600     1    10    20       
        #2        --       0       0       0     1     0     0     
        ```