#!/bin/sh

# В скольких потоках поднимать машины
RUN_IN_PARALLEL=4
# RUN_IN_PARALLEL=$(grep -E ":*> {$" Vagrantfile | wc -l) # по количеству машин (все сразу)

parallel_run(){
    grep -E ":*> {$" Vagrantfile | awk -F':' '{print $2}' | awk -F ' ' '{print $1}' | xargs -P$RUN_IN_PARALLEL -I {} vagrant $1 {}
}

echo "Будет осуществлён параллельный запуск $RUN_IN_PARALLEL потоков"
echo "Выберите действие:"
echo "0 - Развернуть все машины" 
echo "1 - Уничтожить все машины"

echo "Введите номер:"; read ACTION

if  [[ $ACTION == '0' ]]; then
    echo "Выбран вариант 0 - Развернуть все машины"
    parallel_run up
    echo "Скрипт проверки работоспособности расположен на каждой машине в /vagrant/shell/testTask.sh"
    echo "Скрипт проверяет следующие задачи:"
    echo "1. Соединить офисы в сеть согласно схеме и настроить роутинг"
    echo "   Все серверы должны видеть друг друга"
    echo "2. Все серверы и роутеры должны ходить в инет черз inetRouter"
    echo "   У всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи"
elif [[ $ACTION == '1' ]]; then
    echo "Выбран вариант 1 - Уничтожить все машины"
    parallel_run 'destroy -f'
    rm -rf ./.vagrant
else
    echo "Не известный вариант"
    echo "Завершение работы скрипта"
fi