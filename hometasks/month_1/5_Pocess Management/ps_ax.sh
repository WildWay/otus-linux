#!/usr/bin/env bash

# Разрешить обработку backslash для echo (для обработки переносов)
shopt -s xpg_echo


# Вывести верхнюю часть с пояснением вывода
echo "PID\tTTY\t\tSTAT\tTIME\tCOMMAND"


# Для каждой директории с цифровым наименованием 
for PID in $(find /proc/ -maxdepth 1 -name [0-9]* -type d); do
    
    # Определить параметры
    _PID=`awk {'print $1'} $PID/stat`
    _TTY=$(ls -l $PID/fd/ | grep -E tty\|pts -m 1 | cut -d '>' -f 2)
    _STAT=`awk {'print $3'} $PID/stat`
    _TIME_HRS=$((`awk {'print $14 + $15'} $PID/stat` / `getconf CLK_TCK` / 60 ))
    _TIME_MIN=$((`awk {'print $14 + $15'} $PID/stat` / `getconf CLK_TCK` % 60))
    _COMMAND=`cat $PID/cmdline`

    # Вывести предопределённые параметры
    echo "$_PID\t$_TTY\t$_STAT\t$_TIME_HRS:$_TIME_MIN\t$_COMMAND" 2> /dev/null

done
