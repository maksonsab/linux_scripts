#!/bin/bash

pids=()
backups=()
current_date=$(date "+%Y%m%d")
current_time=$(date +%s)
base_path=/home/maksonsab/Документы/InfoBase
backup_path=/home/maksonsab/bak
backup_complete=0
echo Путь до базы: $base_path
echo Путь до резервной копии: $backup_path

is1cWorking () {
    process_ids=$(lsof +D $base_path -t 2>> /dev/null)
    if [ -z "$process_ids"  ] 
    then
        echo 'ready'
    else
        for id in $process_ids;
            do
                pids+=($id)
        done
        echo "${pids[@]}"
    fi 
}

CleanBackup() {

    bak_folders=( $(ls $backup_path) )
    echo ${bak_folders[@]}
    bak_counter=${#bak_folders[@]}
    echo Всего резервных копий $bak_counter
    if [ $bak_counter -gt 4 ] 
    then
        to_del=${bak_folders[0]}
        echo Старая копия удаляется, копия $to_del
        rm -rf $backup_path/$to_del
    else 
        echo Набираем резервные копии!
    fi

}

KillProcess (){
    kill -TERM $1
}

main () {
    while [ $backup_complete = 0 ]; 
        do
            isDirReady=$(is1cWorking) #PID если что-то использует директорию, 'ready' если нет
            echo $isDirReady
            for id in $isDirReady; do
                if [ $id = ready ]
                then
                    printf 'Директория свободна, создается резервная копия...\n' 
                    cp -r $base_path $backup_path/$current_time
                    CleanBackup
                    backup_complete=1      
                else
                    printf 'Директория используется!\n'
                    echo Завершаем процесс $id
                    KillProcess $id
                fi

            done
    done
}

main
