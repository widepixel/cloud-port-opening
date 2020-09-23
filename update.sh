#!/bin/bash
echo "Закрываю autossh процессы реверсов всех доступных портов в списке ..."
pkill -f autossh
sleep 1
echo "Закрываю все ssh соединения ..."
killall ssh
sleep 2
echo "Запускаю autossh реверс всех доступных портов в списке ..."
/scripts/port_reverse/start.sh
echo "Обновление завершено!"


