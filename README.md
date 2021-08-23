# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Нет не могут.

Файлы, которые явлются жесткими ссылками на один объект равноправны и неотличимы друг от друга по причине того, что все они
ссылаются на один и тот же индексный дескриптор(i-node) объекта
В этом индексном дескрипторе в том числе указаны права доступа, владелец/группа, время создания/модификации/доступа и другая информация
самого файла/объекта


1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

    ```bash
    # lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
      ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
      └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    sdc                    8:32   0  2.5G  0 disk
    ```


1. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
    ```bash
    # fdisk /dev/sdb

    Welcome to fdisk (util-linux 2.34).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Device does not contain a recognized partition table.
    Created a new DOS disklabel with disk identifier 0x7097cdc6.

    Command (m for help): p
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    Command (m for help): n
    Partition type
       p   primary (0 primary, 0 extended, 4 free)
       e   extended (container for logical partitions)
    Select (default p): p
    Partition number (1-4, default 1): 1
    First sector (2048-5242879, default 2048):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

    Created a new partition 1 of type 'Linux' and of size 2 GiB.

    Command (m for help): p
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    Device     Boot Start     End Sectors Size Id Type
    /dev/sdb1        2048 4196351 4194304   2G 83 Linux

    Command (m for help): n
    Partition type
       p   primary (1 primary, 0 extended, 3 free)
       e   extended (container for logical partitions)
    Select (default p): p
    Partition number (2-4, default 2):
    First sector (4196352-5242879, default 4196352):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

    Created a new partition 2 of type 'Linux' and of size 511 MiB.

    Command (m for help): p
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G 83 Linux
    /dev/sdb2       4196352 5242879 1046528  511M 83 Linux

    Command (m for help): w
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.
    ```
    ```bash
    # fdisk /dev/sdb
    Welcome to fdisk (util-linux 2.34).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Command (m for help): p
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G 83 Linux
    /dev/sdb2       4196352 5242879 1046528  511M 83 Linux

    Command (m for help): t
    Partition number (1,2, default 2): 1

    Hex code (type L to list all codes): fd

    Changed type of partition 'Linux' to 'Linux raid autodetect'.

    Command (m for help): t
    Partition number (1,2, default 2): 2
    Hex code (type L to list all codes): fd

    Changed type of partition 'Linux' to 'Linux raid autodetect'.

    Command (m for help): w
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.
    ```

1. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

    ```bash
    # sfdisk -d /dev/sdb | sfdisk --force /dev/sdc
    Checking that no-one is using this disk right now ... OK

    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Created a new DOS disklabel with disk identifier 0x7097cdc6.
    /dev/sdc1: Created a new partition 1 of type 'Linux raid autodetect' and of size 2 GiB.
    /dev/sdc2: Created a new partition 2 of type 'Linux raid autodetect' and of size 511 MiB.
    /dev/sdc3: Done.

    New situation:
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G fd Linux raid autodetect
    /dev/sdc2       4196352 5242879 1046528  511M fd Linux raid autodetect

    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.
    ```

    ```bash
    # lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
      ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
      └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    └─sdb2                 8:18   0  511M  0 part
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    └─sdc2                 8:34   0  511M  0 part
    ```
    ```bash
    # fdisk -l
    ....
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G fd Linux raid autodetect
    /dev/sdb2       4196352 5242879 1046528  511M fd Linux raid autodetect


    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7097cdc6

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G fd Linux raid autodetect
    /dev/sdc2       4196352 5242879 1046528  511M fd Linux raid autodetect
    ```

1. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
    ```bash
    # mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device.  If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    mdadm: size set to 2094080K
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    ```
    ```bash
    # cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid1 sdc1[1] sdb1[0]
          2094080 blocks super 1.2 [2/2] [UU]

    unused devices: <none>
    ```

1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
    ```bash
    # mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
    mdadm: chunk size defaults to 512K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.
    ```
    ```bash
    # cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md1 : active raid0 sdc2[1] sdb2[0]
          1042432 blocks super 1.2 512k chunks

    md0 : active raid1 sdc1[1] sdb1[0]
          2094080 blocks super 1.2 [2/2] [UU]

    unused devices: <none>
    ```

1. Создайте 2 независимых PV на получившихся md-устройствах.
    ```bash
    # pvcreate /dev/md0
      Physical volume "/dev/md0" successfully created.
    ```
    ```bash
    # pvcreate /dev/md1
      Physical volume "/dev/md1" successfully created.
    ```
    ```bash
    # pvs | grep md
      /dev/md0             lvm2 ---    <2.00g   <2.00g
      /dev/md1             lvm2 ---  1018.00m 1018.00m
    ```

1. Создайте общую volume-group на этих двух PV.

    ```bash
    # vgcreate myvggroup /dev/md0 /dev/md1
      Volume group "myvggroup" successfully created
    ```
    ```bash
    # vgs | grep myvggroup
      myvggroup   2   0   0 wz--n-  <2.99g <2.99g
    ```
    ```bash
    # vgdisplay myvggroup
      --- Volume group ---
      VG Name               myvggroup
      System ID
      Format                lvm2
      Metadata Areas        2
      Metadata Sequence No  1
      VG Access             read/write
      VG Status             resizable
      MAX LV                0
      Cur LV                0
      Open LV               0
      Max PV                0
      Cur PV                2
      Act PV                2
      VG Size               <2.99 GiB
      PE Size               4.00 MiB
      Total PE              765
      Alloc PE / Size       0 / 0
      Free  PE / Size       765 / <2.99 GiB
      VG UUID               kOgGiQ-GDkx-uV23-6tRg-yBDE-Lng0-2rTAns
    ```
1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

    ```bash
    # lvcreate -n mylv -L 100M myvggroup /dev/md1
      Logical volume "mylv" created.
    ```
    ```bash
    # lvs -a -o +devices | grep mylv
      mylv   myvggroup -wi-a----- 100.00m  /dev/md1(0)
    ```

1. Создайте `mkfs.ext4` ФС на получившемся LV.

    ```bash
    # mkfs.ext4 /dev/mapper/myvggroup-mylv
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```

1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

    ```bash
    # mkdir /tmp/new
    # mount /dev/mapper/myvggroup-mylv /tmp/new
    ```
    ```bash
    # ls -al /tmp/new
    total 24
    drwxr-xr-x  3 root root  4096 Aug 23 21:27 .
    drwxrwxrwt 11 root root  4096 Aug 23 21:28 ..
    drwx------  2 root root 16384 Aug 23 21:27 lost+found
    ```

1. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
    ```bash
    # wget -q --no-check-certificate  https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
    # ls -al /tmp/new/test.gz
    -rw-r--r-- 1 root root 20980365 Авг 19 07:09 /tmp/test.gz
    ```

1. Прикрепите вывод `lsblk`.
    ```bash
    # lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part  /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
      ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
      └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    │ └─md0                9:0    0    2G  0 raid1
    └─sdb2                 8:18   0  511M  0 part
      └─md1                9:1    0 1018M  0 raid0
        └─myvggroup-mylv 253:2    0  100M  0 lvm   /tmp/new
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    │ └─md0                9:0    0    2G  0 raid1
    └─sdc2                 8:34   0  511M  0 part
      └─md1                9:1    0 1018M  0 raid0
        └─myvggroup-mylv 253:2    0  100M  0 lvm   /tmp/new
    ```
1. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    ```bash
    # gzip -t /tmp/new/test.gz; echo $?
    0
    ```

1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

    ```bash
    # pvmove /dev/md1 /dev/md0
      /dev/md1: Moved: 16.00%
      /dev/md1: Moved: 100.00%
    ```
    ```bash
    # lvs -a -o +devices | grep mylv
      mylv   myvggroup -wi-ao---- 100.00m  /dev/md0(0)
    ```
1. Сделайте `--fail` на устройство в вашем RAID1 md.
    ```bash
    # mdadm --manage /dev/md0 --fail /dev/sdc1
    mdadm: set /dev/sdc1 faulty in /dev/md0
    ```

    ```bash
    # mdadm --detail /dev/md0
    /dev/md0:
               Version : 1.2
         Creation Time : Mon Aug 23 21:01:59 2021
            Raid Level : raid1
            Array Size : 2094080 (2045.00 MiB 2144.34 MB)
         Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
          Raid Devices : 2
         Total Devices : 2
           Persistence : Superblock is persistent

           Update Time : Mon Aug 23 21:43:59 2021
                 State : clean, degraded
        Active Devices : 1
       Working Devices : 1
        Failed Devices : 1
         Spare Devices : 0

    Consistency Policy : resync

                  Name : vagrant:0  (local to host vagrant)
                  UUID : 0b9a33e4:89014ba5:14675808:fae75e83
                Events : 19

        Number   Major   Minor   RaidDevice State
           0       8       17        0      active sync   /dev/sdb1
           -       0        0        1      removed

           1       8       33        -      faulty   /dev/sdc1
    ```

1. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

    ```bash
    # dmesg -T | grep md/raid1:md0
    ......
    [Mon Aug 23 21:43:56 2021] md/raid1:md0: Disk failure on sdc1, disabling device.
                               md/raid1:md0: Operation continuing on 1 devices.
    ```
1. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    ```bash
    # gzip -t /tmp/new/test.gz; echo $?
    0
    ```


 ---

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Название файла Google Docs должно содержать номер лекции и фамилию студента. Пример названия: "1.1. Введение в DevOps — Сусанна Алиева".

Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. Чтобы это проверить, откройте ссылку в браузере в режиме инкогнито.

[Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)

[Как запустить chrome в режиме инкогнито ](https://support.google.com/chrome/answer/95464?co=GENIE.Platform%3DDesktop&hl=ru)

[Как запустить  Safari в режиме инкогнито ](https://support.apple.com/ru-ru/guide/safari/ibrw1069/mac)

Любые вопросы по решению задач задавайте в чате Slack.

---
