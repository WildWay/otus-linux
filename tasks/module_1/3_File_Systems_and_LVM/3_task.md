# Файловые системым и LVM

### __Задачи:__
__На имеющемся образе `/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /`:__
1. уменьшить том под / до 8G
1. выделить том под /home
1. выделить том под /var
1. /var - сделать в mirror
1. /home - сделать том для снэпшотов
1. прописать монтирование в fstab
    - с разными опциями и разными файловыми системами ( на выбор)
1. Создать и восстановиться со снэпшота:
    - сгенерить файлы в /home/
    - снять снэпшот
    - удалить часть файлов
    - восстановится со снэпшота

### __Задачи повышенной сложности:__
1. Поставить на дисках btrfs/zfs - с кешем, снэпшотами
1. Разметить на них каталог /opt


### __Критерии оценки:__
1. `Выполнено` - запись script или asciinema с выполнением основных задач
1. `+1 балл` - запись script или asciinema с выполнением задач повышенной сложности