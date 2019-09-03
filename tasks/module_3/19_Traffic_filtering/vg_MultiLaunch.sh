#!/bin/sh
. sync/testTask.sh

# В скольких потоках поднимать машины
#RUN_IN_PARALLEL=4
RUN_IN_PARALLEL=$(grep name nodes.yml | cut -d " " -f 3 | wc -l) # по количеству машин (все сразу)


parallel_run(){
    grep name nodes.yml | cut -d " " -f 3 | xargs -P$RUN_IN_PARALLEL -I {} vagrant $1 {}
}

echo "Будет осуществлён параллельный запуск $RUN_IN_PARALLEL потоков"
echo "Выберите действие:"
echo "0 - Развернуть все машины" 
echo "1 - Уничтожить все машины"

echo "Введите номер:"; read ACTION

if [[ $ACTION == '1' ]]; then
    echo "Выбран вариант 1 - Уничтожить все машины"
    parallel_run 'destroy -f'
    rm -rf ./.vagrant
elif  [[ $ACTION == '0' ]]; then
    echo "Выбран вариант 0 - Развернуть все машины"
    parallel_run up
    testTask
else
    echo "Не известный вариант"
    echo "Завершение работы скрипта"
fi