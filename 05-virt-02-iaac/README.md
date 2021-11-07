
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
  - ускорения создания инфраструктуры за счет автоматизации и исключения необходимости ручной настройки и обновлений
  - уменьшения риска возникновения человеческих ошибок
  - воспроизводимость/повторяемость и масштабируемость инфраструктуры
  - отсутствие дрейфа/рассинхронизации конфигураций на различных окружениях
- Какой из принципов IaaC является основополагающим?
    Идемпоте́нтность (лат. idem — тот же самый + potens — способный) —
    это свойство объекта или операции, при повторном выполнении
    которой мы получаем результат идентичный предыдущему и всем
    последующим выполнениям.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
  - низкий порог вхождения, простота
  - отсутствие необходимости в агенте(клиентской части) на целевом(удаленном) сервере
  - поддержка большого количества модулей

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

  Имхо, не совсем корректно сравнивать эти два режима с точки зрения надежности т.к. они выполняют немного различные задачи

  Push - позволяет первоначально/единоразово сконфигурировать сервер/приложение без дальнейшей поддержки актуализации таких настроек сервера/приложения(за исключением ручного или по крону запуска с использованием push)

  Pull же позволяет кроме такой первоначальной настройки сервера/приложения периодически с желаемым интервалом поддерживать в актуальном состоянии согласно настройкам конфигурации ранее настроенный сервер/приложение

  Для Push-модели упралвяющий сервер должен иметь доступ на все целевые хосты

  При Pull-моделе на управляющем сервере необходимо разрешить доступ с целевых хостов

  Понятно, что при большом количестве целевых хостов, получение настроек такими хостами с управляющего(главного) сервера можно разнести в разные временные промежутки тем самым разгрузить управляющий сервер, к которому они подключаются

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*


- VirtualBox

   ```bash
   $ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
   $ sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
   $ sudo apt-get update
   $ sudo apt-get install virtualbox-6.1
   $ dpkg -l | grep virtualbox
   ii  virtualbox-6.1 6.1.28-147628~Ubuntu~bionic amd64 Oracle VM VirtualBox
   ```

- Vagrant
   ```bash
   $ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   $ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com (lsb_release -cs) main"
   $ sudo apt-get update
   $ sudo apt-get install vagrant
   $ vagrant --version
   Vagrant 2.2.19
   ```

- Ansible

    Проверка текущей версии модуля `pip`
    ```bash
    $ pip --version
    pip 21.3.1 from /home/eugene/.local/lib/python3.6/site-packages/pip (python 3.6)
    ```

    Обновление модуля pip
    ```bash
    $ python3 -m pip install --upgrade pip
    Defaulting to user installation because normal site-packages is not writeable
    Requirement already satisfied: pip in ./.local/lib/python3.6/site-packages (21.3.1)
    ```

    Установка модуля `virtualenv` для создания виртуального окружения
    ```bash
    $ pip3 install virtualenv
    ```

    Создание виртуального окружения для установки в нем `ansible` и всех необходимых дополниетльных модулей/инструментов

    ```bash
    $ cd Work/Projects/Netology/
    $ python -m virtualenv ansible
    ```

    Активация виртуального окружения
    ```bash
    $ source ansible/bin/activate
    (ansible) eugene@eugene-notebook ~/Work/Projects/Netology $
    ```

    Установка `ansible` нужной версии внутри виртуального окружения
    ```bash
    $ pip install ansible==2.9.25
    ```
    ```bash
    $ ansible --version
    ansible 2.9.25
      config file = None
      configured module search path = ['/home/eugene/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
      ansible python module location = /home/eugene/Work/Projects/Netology/ansible/lib/python3.6/site-packages/ansible
      executable location = /home/eugene/Work/Projects/Netology/ansible/bin/ansible
      python version = 3.6.9 (default, Jan 26 2021, 15:33:00) [GCC 8.4.0]
    ```
    Установка `ansible-lint` внутри виртуального окружения
    ```bash
    $ pip install ansible-lint
    ```
    Установка `yamllint` внутри виртуального окружения
    ```bash
    $ pip install yamllint
    ```
    ## Задача 4 (*)

    Воспроизвести практическую часть лекции самостоятельно.

    - Создать виртуальную машину.
    - Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
    ```
    docker ps
    ```

    ```bash
    cd git/devops-netology/05-virt-02-iaac/src/vagrant/
    ```

    ```bash
    $ vagrant up
    Bringing machine 'server1.netology' up with 'virtualbox' provider...
    ==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
    ==> server1.netology: Matching MAC address for NAT networking...
    ==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
    ==> server1.netology: Setting the name of the VM: server1.netology
    ==> server1.netology: Clearing any previously set network interfaces...
    The IP address configured for the host-only network is not within the
    allowed ranges. Please update the address used to be within the allowed
    ranges and run the command again.

      Address: 192.168.192.11
      Ranges: 192.168.56.0/21

    Valid ranges can be modified in the /etc/vbox/networks.conf file. For
    more information including valid format see:
    ```

    Ошибка вызвана тем,что пытаемся использовать ip-адрес для сервера из неразрешенного пула IP-адресов для host-only адаптера в virtualbox

    https://www.virtualbox.org/manual/ch06.html#network_hostonly
    Из официальной документации Virtualbox
    ```bash
    On Linux, Mac OS X and Solaris Oracle VM VirtualBox will only allow IP addresses in 192.68.56.0/21 range to be assigned to host-only adapters.
    For IPv6 only link-local addresses are allowed.
    If other ranges are desired, they can be enabled by creating /etc/vbox/networks.conf and specifying allowed ranges there.
    For example, to allow 10.0.0.0/8 and 192.168.0.0/16 IPv4 ranges as well as 2001::/64 range put the following lines into /etc/vbox/networks.conf:

          * 10.0.0.0/8 192.168.0.0/16
          * 2001::/64
    ```

    т.е. по дефолту для IPv4-протокола разрешено использовать адреса только из подсети `192.68.56.0/21`

    Альтернативным вариантом яляется добавлеие желаемых подсетей в файл `/etc/vbox/networks.conf` для того,чтобы разрешить Virtualbox использовать их

    ```bash
    $ cat /etc/vbox/networks.conf
    cat: /etc/vbox/networks.conf: No such file or directory
    ```

    В данном случае не будем добавлять желаемую подсеть, а просто изменим подсеть в Vagrantfile с
    `192.168.192` на `192.168.60`


    ```bash
    $ vagrant up
    Bringing machine 'server1.netology' up with 'virtualbox' provider...
    ==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
    ==> server1.netology: Clearing any previously set network interfaces...
    ==> server1.netology: Preparing network interfaces based on configuration...
        server1.netology: Adapter 1: nat
        server1.netology: Adapter 2: hostonly
    ==> server1.netology: Forwarding ports...
        server1.netology: 22 (guest) => 20011 (host) (adapter 1)
        server1.netology: 22 (guest) => 2222 (host) (adapter 1)
    ==> server1.netology: Running 'pre-boot' VM customizations...
    ==> server1.netology: Booting VM...
    ==> server1.netology: Waiting for machine to boot. This may take a few minutes...
        server1.netology: SSH address: 127.0.0.1:2222
        server1.netology: SSH username: vagrant
        server1.netology: SSH auth method: private key
        server1.netology:
        server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
        server1.netology: this with a newly generated keypair for better security.
        server1.netology:
        server1.netology: Inserting generated public key within guest...
        server1.netology: Removing insecure key from the guest if it's present...
        server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
    ==> server1.netology: Machine booted and ready!
    ==> server1.netology: Checking for guest additions in VM...
    ==> server1.netology: Setting hostname...
    ==> server1.netology: Configuring and enabling network interfaces...
    ==> server1.netology: Mounting shared folders...
        server1.netology: /vagrant => /home/eugene/Work/Projects/Netology/git/devops-netology/05-virt-02-iaac/src/vagrant
    ==> server1.netology: Running provisioner: ansible...
        server1.netology: Running ansible-playbook...

    PLAY [nodes] *******************************************************************

    TASK [Gathering Facts] *********************************************************
    ok: [server1.netology]

    TASK [Create directory for ssh-keys] *******************************************
    changed: [server1.netology]

    TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
    changed: [server1.netology]

    TASK [Checking DNS] ************************************************************
    changed: [server1.netology]

    TASK [Installing tools] ********************************************************
    ok: [server1.netology] => (item=['git', 'curl'])

    TASK [Installing docker] *******************************************************
    changed: [server1.netology]

    TASK [Add the current user to docker group] ************************************
    changed: [server1.netology]

    PLAY RECAP *********************************************************************
    server1.netology           : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

    ```bash
    $ vagrant status
    Current machine states:

    server1.netology          running (virtualbox)
    ```

    ```bash
    $ vagrant ssh server1.netology
    Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage

      System information as of Sun 07 Nov 2021 10:55:09 PM UTC

      System load:  0.04              Users logged in:          0
      Usage of /:   3.2% of 61.31GB   IPv4 address for docker0: 172.17.0.1
      Memory usage: 20%               IPv4 address for eth0:    10.0.2.15
      Swap usage:   0%                IPv4 address for eth1:    192.168.60.11
      Processes:    105


    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento
    Last login: Sun Nov  7 22:51:15 2021 from 10.0.2.2
    ```
    ```bash
    vagrant@server1:~$ docker ps
    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
    ```
    ```bash
    vagrant@server1:~$ docker --version
    Docker version 20.10.10, build b485636
    ```