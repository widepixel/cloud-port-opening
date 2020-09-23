#!/bin/bash

timestamp=$( date '+%Y/%m/%d %H:%M:%S' )
HOST=$(cat /scripts/port_reverse/host)
RPORTS=($(cat /scripts/port_reverse/rports.list))
USER='root'
#KEY='/root/.ssh/id_rsa'
KEY='/root/.ssh/id_rsa'
CINT=1
SAI="ServerAliveInterval 15"
SACM="ServerAliveCountMax 10"
#SAI="ServerAliveInterval 900"
# command

while [ true ]
do
        if [[ $(sudo ping -q -w1 -c 1 8.8.8.8 &>/dev/null && echo online || echo offline) = "online" ]]
        then
                for rport in ${RPORTS[@]}
                do
                        if [[ ! $rport == *"#"* ]]
                        then
                                while [ true ]
                                do

                                        IFS=':' read -ra rparr <<< "$rport"

                                        if [[ $(nmap -p ${rparr[0]} $HOST) == *${rparr[0]}"/tcp closed"* ]]
                                        then

                                                sudo autossh -i $KEY -o "$SAI" -o "$SACM" -N -R $rport $USER@$HOST &
                                               # sudo autossh -i $KEY -f -o "$SAI" -TN $rport $USER@$HOST &

                                                IFS=':' read -ra rparr <<< "$rport"
                                                echo -e "\e[1;35m"${rparr[1]}":"${rparr[2]}"\e[0m\t \e[1;33m=>\e[0m \t\e[1;32m"$HOST":"${rparr[0]}"\e[0m"

                                                #sleep $CINT
                                                break
                                        else
                                                echo ">"$(nmap -p ${rparr[0]} $HOST)"<"
                                                echo -e "\e[1;31mПорт "${rparr[0]}" занят!\e[0m"
                                                echo "["$( date '+%Y/%m/%d %H:%M:%S' )"] Порт "${rparr[0]}" занят!" >> /scripts/port_reverse/log.txt

                                        fi
                                        sleep 10
                                done
                        fi
                done
                break
        else
                echo -e "\e[1;31mОтсутствует интернет соединение!\e[0m"
                echo "["$( date '+%Y/%m/%d %H:%M:%S' )"] Отсутствует интернет соединение!" >> /scripts/port_reverse/log.txt
        fi
        sleep 1
done


