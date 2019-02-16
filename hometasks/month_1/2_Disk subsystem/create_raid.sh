#!/bin/bash

# Очистить суперблоки (метаданные файловой системы)
mdadm --zero-superblock --force /dev/sd{b..g}

# Создать RAID /dev/md0 с комбинированным уровнем 10 (1+0) из 6 дисков, с /dev/sdb по /dev/sdg
mdadm -C /dev/md0 -l 10 -n 6 /dev/sd{b..g}

# Создать конфигурационный файл, содержаший информацию о использующихся RAID и их компонентах.
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf

# Создать таблицы разделов GPT на RAID /dev/md0
parted -s /dev/md0 mklabel gpt

# Создать директории для разделов
mkdir -p /mnt/raid10/p{1..5}

# Для каждого из 5 разделов
for i in $(seq 1 5); do
	# Создать раздел
	parted /dev/md0 mkpart primary ext4 `echo $((20*($i-1)))% $((20*$i))%`
	
	# Ожидание синхронизации данных в RAID
	sleep 1
	
	# Создать файловую ext4 систему на разделе
	mkfs.ext4 /dev/md0p$i
	
	# Добавить информацию о монтировании RAID - /dev/md0$i
	# точка монтирования                      - /mnt/raid10/p$i
	# файловая система                        - ext4 
	# опции монтирования                      - defaults
	# опция создания дампа файловой системы   - 1
	# опция порядка проверки файловой системы - 2
	echo -e "UUID=`blkid | grep /dev/md0p$i | cut -f 2 -d '"'`\t/mnt/raid10/p$i\text4\tdefaults\t1\t2" >> /etc/fstab		
done


# Примонтировать все устройства, описанные в /etc/fstab
mount -a