# cloud-port-opening
<h1>Cloud Port Opening on SSH Reverse Tunnel</h1>

<h2>На сервере правим файл конфигурации: /etc/ssh/sshd_config</h2>
<pre>
GatewayPorts yes
ClientAliveInterval 35
ClientAliveCountMax 3
</pre>

<h2>На клиенте устанавливаем:</h2>
<h3>nmap</h3>
<pre>sudo apt-get install nmap</pre>

<h3>autossh</h3>
<pre>sudo apt-get install autossh</pre>

Выставляем права на файлы:<br/>

<pre>
sudo chmod 777 host rports.list log.txt
sudo chmod u+x start.sh stop.sh update.sh
<pre>

В файле host прописываем адрес вашего сервера.

<pre>
8.8.8.8
</pre>

В фале rports.list прописываем адреса и перебрасываемые порты.

<pre>
8080:192.168.1.150:80
33398:192.168.1.150:3389
9000:192.168.1.150:81
...
</pre>

<h2>Создание пары ключей RSA</h2>
Для создания приватного и публичного ключа для авторизации на сервере, на клиенте запускаем следующую команду и постоянно жмем Enter:<br/>

<pre>
sudo ssh-keygen
</pre>

Ключи должен сгенерироваться по пути <code>~/.ssh</code>

<pre>
-rw------- 1 root root 1675 Mar 20  2020 id_rsa
-rw-r--r-- 1 root root  391 Mar 20  2020 id_rsa.pub
</pre>

Выводим и копируем содержимое публичного ключа id_rsa.pub следующей командой:<br/>

<pre>
cat id_rsa.pub
</pre>

На сервере идем по пути <code>~/.ssh</code>и добавляем наш скопированный ключ в файл <code>authorized_keys</code> следующими командами:

<pre>
cat >> authorized_keys << EOF
  ... Здесь вставляем наш ключ ...
EOF
</pre>

Теперь перед запуском приложения, для его дальнейшей постоянной авторизации без вмешательства человека, нам нужно единажды от клиента подключиться к серверу используя приватный ключ:<br/>

<pre>
sudo ssh -i ~/.ssh/id_rsa root@SERVER
</pre>

Вводим пароль и соглашаемся ответом yes.<br>


<h2>Запуск приложения</h2>

<code>./start.sh</code>

<h2>Добавление приложения в автозагрузку (в cron задание)</h2>

<code>sudo crontab -e</code>

И добавляем в конец следую строку:<br/>

<pre>
@reboot sudo /путь к приложению/start.sh &
</pre>


