#!/bin/bash
#
# Месяц 1. Тема 3. Файловые системы и LVM.
#
# Задачи:
#
# 0. Залогировать всю работу с помощью script
# 1. Уменьшить имеющийся том LogVol00 до 8G
# 2. Сделать зеркальный том для /var
# 3. Сделать том для /home
# 4. Прописать монтирование для /var и /home в fstab
# 5. Сгенерировать файлы в /home/, снять снэпшот, удалить часть файлов, восстановиться со снэпшота
# 6. * Создать том btrfs/zfs с кэшем и снэпшотами, разместить на нём каталог /opt


# Выполнение:

#
# 0. Залогировать всю работу с помощью script


# 1. Уменьшить имеющийся том LogVol00 до 8G
df -hT | grep /$                                                        # Вывод данных о разделе

#
# === Подготовка
#
# xfs нельзя уменьшить на использующемся томе.
# Для снятия копии тома необходима установка xfsdump :
yum install -y xfsdump


# Создать временный том для раздела / :
pvcreate /dev/sdb                                                       # Physical Volume (PV) - раздел или том, базовая составляющая Volume Group
vgcreate vg_root /dev/sdb                                               # Volume Group (VG)    - пространство, в котором объединены ресурсы PV
lvcreate -n lv_root -l 100%FREE /dev/vg_root                            # Logical Volume (LV)  - логический раздел, использующий ресурсы VG


mkfs.xfs /dev/vg_root/lv_root                                           # Создать файловую систему на LV
mount /dev/vg_root/lv_root /mnt                                         # Примонтировать LV в /mnt
xfsdump - -J /dev/VolGroup00/LogVol00 | xfsrestore - -J /mnt            # Передать дамп на восстановление(-), подавив создание inventory(-J) (используется с целью возобновить дамп, в случае прерывания)
ls /mnt                                                                 # Проверить наличие файлов в целевом томе


for i in /proc/ /sys/ /dev/ /run/ /boot/; do                            # Смонтировать /proc/ /sys/ /dev/ /run/ /boot/
	mount --bind $i /mnt/$i;                                        # В директорию /mnt/, с таким же именем директории
done

chroot /mnt/                                                            # Сменить текущую корневую (/) директорию на /mnt/
grub2-mkconfig -o /boot/grub2/grub.cfg                                  # Сгенерировать grub2 конфиг и сохранить в файл (-o)

cd /boot; for i in `ls initramfs-*img`; do                             
    dracut -v $i `echo $i | sed "s/initramfs-//g; s/.img//g"` --force;  # Пересоздать образы сжатой файловой системы (initramfs) 
done

sed -i 's/VolGroup00\/LogVol00/vg_root\/lv_root/g' /boot/grub2/grub.cfg # Изменить загрузочный том с VolGroup00/LogVol00 на vg_root/lv_root


exit && sudo reboot                                                     # Выйти в оригинальную корневую директорию и перезагрузиться, для загрузки с другого загрузочного тома
lsblk | grep /$                                                         # Убедиться, что система загружена с временного тома vg_root/lv_root


# === Уменьшение оригинального тома до 8G

lvreduce /dev/VolGroup00/LogVol00 -L 8G                                 # Уменьшить том до 8G 
mkfs.xfs /dev/VolGroup00/LogVol00 -f                                    # Перезаписать файловую систему 
mount /dev/VolGroup00/LogVol00 /mnt                                     # Смонтировать том в /mnt/, с таким же именем директории



xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt                # Сдампить данные с временного тома и восстановить на оригинальный

for i in /proc/ /sys/ /dev/ /run/ /boot/; do                            # Смонтировать /proc/ /sys/ /dev/ /run/ /boot/
    mount --bind $i /mnt/$i;                                            # В директорию /mnt/, с таким же именем директории
done


chroot /mnt/                                                            # Сменить текущую корневую (/) директорию на /mnt/
grub2-mkconfig -o /boot/grub2/grub.cfg                                  # Сгенерировать grub2 конфиг и сохранить в файл (-o)


cd /boot; for i in `ls initramfs-*img`; do                             
    dracut -v $i `echo $i | sed "s/initramfs-//g; s/.img//g"` --force;  # Пересоздать образы сжатой файловой системы (initramfs) 
done


exit && sudo reboot                                                     # Выйти в оригинальную корневую директорию и перезагрузиться, для загрузки с первоначального загрузочного тома
lsblk | grep /$                                                         # Убедиться, что система загружена с первоначального тома VolGroup00/LogVol00/

lvremove /dev/vg_root/lv_root -y                                        # Удалить, использованные для переноса LV
vgremove /dev/vg_root -y                                                #                                      VG
pvremove /dev/sdb -y                                                    #                                      PV

# === Задача 1 завершена


# 2. Сделать зеркальный том для /var

pvcreate /dev/sdc /dev/sdd                                              # Создать PV для тома RAID 1
vgcreate vg_var /dev/sdc /dev/sdd                                       # Создать VG из этих PV
lvcreate -L 950M -m1 -n lv_var vg_var                                   # Создать LV объемом 950M, уровнем RAID 1, с именем lv_var, в vg_var

mkfs.ext4 /dev/vg_var/lv_var                                            # Создать файловую систему ext4 на lv_var
mount /dev/vg_var/lv_var /mnt                                           # Примонтировать lv_var в /mnt/
cp -aR /var/* /mnt/                                                     # Скопировать всё содержимое /var/ в /mnt/ с сохранением структуры и атрибутов исходных файлов

umount /mnt && mount /dev/vg_var/lv_var /var                            # Отмонтировать lv_var из /mnt и примонтировать в /var


# === Задача 2 завершена


# 3. Сделать том для /home

lvcreate -n LogVol_Home -L 2G /dev/VolGroup00                           # Создать LV LogVol_Home объемом 2G в VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol_Home                                    # Создать файловую систему xfs на LogVol_Home
mount /dev/VolGroup00/LogVol_Home /mnt/                                 # Примонтировать LogVol_Home в /mnt/

cp -aR /home/* /mnt/                                                    # Скопировать всё содержимое /home/ в /mnt/ с сохранением структуры и атрибутов исходных файлов
rm -rf /home/*                                                          # Удалить все файлв в /home/, игнорируя предупреждения
umount /mnt && mount /dev/VolGroup00/LogVol_Home /home/                 # Отмонтировать LogVol_Home из /mnt и примонтировать в /home/

# === Задача 3 завершена



# 4. Прописать монтирование для /var и /home в fstab

echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab
echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab

exit                                                                    # Завершить запись script.
reboot                                                             

# === Задача 4 завершена


# 5. Сгенерировать файлы в /home/, снять снэпшот, удалить часть файлов, восстановиться со снэпшота

touch /home/file{1..20}                                                 # Сгенерировать 20 файлов в home
ls /home/file*								# Вывести все файлы в /home/ начинающиеся на file

lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home           # Создать том-снэпшот для /home

rm -f /home/file{11..20}                                                # Удалить файлы с file11 по file20
ls /home/file*								# Вывести все файлы в /home/ начинающиеся на file

umount /home                                                            # Отмонтировать /home
lvconvert --merge /dev/VolGroup00/home_snap                             # Восстановиться со снимка home_snap (снимок будет удалён)
mount /home                                                             # Примонтировать /home
ls /home/file*								# Вывести все файлы в /home/ начинающиеся на file


# 6. * Создать том btrfs/zfs с кэшем и снэпшотами, разместить на нём каталог /opt


