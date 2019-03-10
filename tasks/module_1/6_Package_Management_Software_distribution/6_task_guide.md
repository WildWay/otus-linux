# Сборка RPM-пакета на примере nginx с поддержкой openssl.

1. Установка необходимого ПО:
    - `yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc`

1. Загрузка SRPM пакета nginx:
    - `wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm`

1. Создание дерева каталогов для сборки, путём "установки" пакетов с исходными файлами:
    - `rpm -i nginx*.rpm`

1. Установка зависимостей на основании файла spec:
    - `yum-builddep ./rpmbuild/SPECS/nginx.spec`

1. Заменить nginx.spec на зменённый файл, для сборки nginx с необходимыми опциями:
    - `otus-linux/hometasks/month_1/6_Package Management. Software distribution/nginx.spec`
    - путь до `openssl` указан как `--with-openssl=/root/openssl-1.1.1a`
    - Дополнительно можно посмотреть [все доступные опции для сборки nginx из исходных файлов](https://nginx.org/ru/docs/configure.html)

1. Загрузить openssl последней версии
    - `wget https://www.openssl.org/source/latest.tar.gz`

1. Создать директорию и распаковать openssl:
    - `tar -xvf ./latest.tar.gz`

1. Убедиться что архив распакован в `/root/` и директория называется `openssl-1.1.1a/`:
    - `ll /root/`

1. Собрать rpm-пакет:
    - `rpmbuild -bb rpmbuild/SPECS/nginx.spec`

1. Убедиться что пакеты собраны:
    - `ll rpmbuild/RPMS/x86_64/`

1. Установить собраный пакет:
    - `yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm`

1. Запустить и проверить состояние сервиса:
    - `systemctl enable --now nginx && systemctl status nginx`

1. Создать директорию для репозитория:
    - `mkdir /usr/share/nginx/html/repo`

1. Скопировать туда собранный rpm:
    - `cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/`

1. И, для примера, ещё один rpm, которого нет в стандартных репозиториях:
    - `wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm`

1. Инициализировать репозиторий:
    - `createrepo /usr/share/nginx/html/repo/`

1. В location / в файле /etc/nginx/conf.d/default.conf добавить директиву autoindex on. В результате location будет выглядеть так:
    >   location / {  
            root /usr/share/nginx/html;  
            index index.html index.htm;  
            autoindex on; # <== Добавили эту директиву  
        }  

1. Проверить корректность внесённых изменений:
    - `nginx -t`

1. Если всё корректно - перезапустить nginx:
    - `nginx -s reload`

1. Проверить наличие пакетов с помощью curl:
    - `curl -a http://localhost/repo/`

1. Добавить репозиторий:
    - `vim /etc/yum.repos.d/otus.repo`
    - Содержимое должно быть:
        >  [otus]  
            name=otus-linux  
            baseurl=http://localhost/repo  
            gpgcheck=0  
            enabled=1  

1. Убедиться что репозиторий подключен и в нём есть пакеты:
    - `yum repolist enabled | grep otus`
    - `yum list | grep otus`

1. Установить percona-release:
    - `yum install percona-release -y`

1. В случае добавления новых файлов в репозиторий обновить его командой:
    - `createrepo /usr/share/nginx/html/repo`