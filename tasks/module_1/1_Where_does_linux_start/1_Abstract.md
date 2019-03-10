# Инструкция по установке ядра

1. Скачать ядро с `kernel.org` в `/usr/src`:

1. Установить `Development Tools`:
    - `yum group install "Development Tools"`

1. Установить `ncurses-devel` для TUI:
    - `yum install ncurses-devel`

1. Установить `qt3-devel` для GUI:
    - `yum install gt3-devel`

1. Установить необходимые для сборки ядра пакеты:
    - `yum install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel openssl-devel bc`

1. Очистить старые данные сборок ядра:
    - `make mrproper` 

1. Запустить TUI для выбора параметров ядра:
    - `make menuconfig`  

    ## Последующие команды запускать с указанием N (количества потоков/логических ядер) с помощью опции -j N

1. Запустить сборку ядра:
    - `make bzImage -j N`

1. Запустить сборку модулей:
    - `make modules -j N`

1. Запустить перемещение модулей:
    - `make modules_install -j N`

1. Запустить установку ядра в текущую систему:
    - `make install -j N`

1. Запустить формирование загрузчика:
    - `grub2-mkconfig -o /boot/grub2/grub2.cfg`

1. При необходимости установить нужный вариант загрузки:
    - в `/etc/default/grub` строка `GRUB_DEFAULT=`.  

    > Очередность можно посмотреть с помощью  
	`grep menuentry /boot/grub2/grub2.cfg`.  
	Начинается с 0. 