#!/bin/bash

pids=()
backups=()
current_date=$(date "+%Y%m%d")
current_time=$(date +%s)
base_path=/home/maksonsab/Документы/InfoBase
backup_path=/home/maksonsab/bak
backup_complete=0
echo Path to base: $base_path
echo Path to backup: $backup_path

#Cheking database directory for working processes 
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
    echo Total backups $bak_counter
    if [ $bak_counter -gt 4 ] # 4 is number of backups in bakup directory
    then
        to_del=${bak_folders[0]}
        echo Deleting oldest backup $to_del
        rm -rf $backup_path/$to_del
    else 
        echo Adding another backup
    fi

}

#Terminating processes by pid
KillProcess (){
    kill -TERM $1
}

main () {
    while [ $backup_complete = 0 ]; 
        do
            isDirReady=$(is1cWorking) #pid if some process working in database directory, else 'ready'
            echo $isDirReady
            for pid in $isDirReady; do
                if [ $pid = ready ]
                then
                    printf 'Директория свободна, создается резервная копия...\n' 
                    cp -r $base_path $backup_path/$current_time
                    CleanBackup
                    backup_complete=1      
                else
                    printf 'Директория используется!\n'
                    echo Завершаем процесс $pid
                    KillProcess $pid
                fi

            done
    done
}

main
