#!/bin/bash

# Очистить суперблоки (метаданные файловой системы)
mdadm --zero-superblock --force /dev/sd{b..g}

# Создать RAID /dev/md0 с комбинированным уровнем 10 (1+0) из 6 дисков, с /dev/sdb по /dev/sdg
mdadm -C /dev/md0 -l 10 -n 6 /dev/sd{b..g}

# Создать файловую систему ext4 на RAID /dev/md0
mkfs.ext4 /dev/md0

# Создать конфигурационный файл, содержаший информацию о использующихся RAID и их компонентах.
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf

# Создать директорию /mnt/raid10
mkdir /mnt/raid10

# Добавить информацию о монтировании RAID - /dev/md0
# точка монтирования                      - /mnt/raid10
# файловая система                        - ext4 
# опции монтирования                      - defaults
# опция создания дампа файловой системы   - 1
# опция порядка проверки файловой системы - 2
echo -e "UUID=`blkid | grep /dev/md0 | cut -f 2 -d '"'`\t/mnt/raid10\text4\tdefaults\t1\t2" >> /etc/fstab

# Примонтировать все устройства, описанные в /etc/fstab
mount -a
