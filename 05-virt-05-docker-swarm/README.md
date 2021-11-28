# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
  - replication - запуск сервиса в количестве согласно определенному/желаемую значению, определенному в конфигурации
  - global - запуск сервиса на каждой ноде кластера
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?

    Лидер нода выбирается из управляющих нод путем `Raft` согласованного алгоритма.

    Распределенные решения должны быть одобрены большинством управляющих узлов, называемых кворумом.

    Это означает, что рекомендуется нечетное количество управляющих узлов
- Что такое Overlay Network?

    Это виртуальная/логическая сеть, которая построена поверх другой уже существующей сети

    Overlay Network использует инканпсуляцию и деинкапсуляцию пакетов, когда один пакет вкладывается/помещается внутрь другого пакета на исходном сервере
    и затем в обратном порядке распаковывается уже на целевом/принимающем сервере

    Это позволяет:
    - создавать новые свойства сети, которые невозможны в стандартной инфраструктуре
    - создания и использование сервисов, которые невозможны в стандартной инфраструктуре

    Основным преимуществом оверлейных сетей является то, что они позволяют разрабатывать и эксплуатировать новые крупномасштабные распределённые сервисы без внесения каких-либо изменений в основные протоколы сети

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```

```bash
$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
5o6npdp8jzjv9c4p7tpvof0yf *   node01.netology.yc   Ready     Active         Leader           20.10.11
mgdswijjydak4jy1ai1hpeuov     node02.netology.yc   Ready     Active         Reachable        20.10.11
khd3dj5jvsg6749n3movc5bge     node03.netology.yc   Ready     Active         Reachable        20.10.11
thoz6vcuwfeakzyok39a2ziv8     node04.netology.yc   Ready     Active                          20.10.11
otjw8z7noigy3v56kjovifgta     node05.netology.yc   Ready     Active                          20.10.11
18teipd5eqxvj96kujpp5so6s     node06.netology.yc   Ready     Active                          20.10.11
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

```bash
$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
i7oks97tczrr   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
5ylb7id7sv20   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
u35lgv3kcpk1   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
56nkjnroel54   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
7ahr4hwibb8s   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
nkhhfllsu5cq   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
85998hg09elw   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
rtmw5wc5kdk1   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```


```bash
$ sudo docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-aIpA9dlfyEats8jy6zrETUoE7n6FzNt2VH5BI/F6mw4

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```

Команда `docker swarm update --autolock=true`
включает автоблокировку уже существующего/задеплоенного Docker Swarm-кластера

Это приводит к тому, что при рестарте Docker для разблокировки мастеров/manager Swarm необходимо ввести
ключ шифрования, который был создан/сгенерирован Docker-ом во время блокировки Swarm

При перезапуске Docker ключ TLS, используемый для шифрования связи между узлами Swarm, и ключ, используемый для шифрования и дешифрования журналов Raft на диске,
загружаются в память каждой manger-ноды.

Docker имеет возможность защищать общий ключ шифрования TLS и ключ, используемый для шифрования и дешифрования журналов Raft за счет требования ручной разблокировки менеджеров в виде ввода ключа шифрования.

Такая возможность и называется автоблокировкой



## Пошаговый план выполнения практической части этой домашней работы


### Создание образа системы с помощью Packer

Создание сети
```bash
# yc vpc network create \
> --name net \
> --labels my-label=netology \
> --description "my first network via yc"

id: enpp0t4no5apinqdvq4n
folder_id: b1gvtndpj707oc5sjqj9
created_at: "2021-11-28T16:21:43Z"
name: net
description: my first network via yc
labels:
  my-label: netology
```

Просмотр существующих сетей
```bash
# yc vpc network list
+----------------------+---------+
|          ID          |  NAME   |
+----------------------+---------+
| enp7vadvqjcv0i4jf774 | default |
| enpni2qmk8djksk84a67 | net     |
+----------------------+---------+
```

Создание подсети в выше созданной сети
```bash
# yc vpc subnet create \
--name my-subnet-a \
--zone ru-central1-a \
--range 10.1.2.0/24 \
--network-name net \
--description "my first subnet via yc"

id: e9bqo3njs4kaln2v7loj
folder_id: b1gvtndpj707oc5sjqj9
created_at: "2021-11-28T16:22:30Z"
name: my-subnet-a
description: my first subnet via yc
network_id: enpni2qmk8djksk84a67
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24
```

Просмотр существующих подсетей
```bash
# yc vpc subnet list
+----------------------+-----------------------+----------------------+----------------+---------------+-----------------+
|          ID          |         NAME          |      NETWORK ID      | ROUTE TABLE ID |     ZONE      |      RANGE      |
+----------------------+-----------------------+----------------------+----------------+---------------+-----------------+
| b0cb8ta3mvr9cl160o9h | default-ru-central1-c | enp7vadvqjcv0i4jf774 |                | ru-central1-c | [10.130.0.0/24] |
| e2l5sv02mboeuavte0r4 | default-ru-central1-b | enp7vadvqjcv0i4jf774 |                | ru-central1-b | [10.129.0.0/24] |
| e9bqo3njs4kaln2v7loj | my-subnet-a           | enpni2qmk8djksk84a67 |                | ru-central1-a | [10.1.2.0/24]   |
| e9bsulbsn1ts3809stmr | default-ru-central1-a | enp7vadvqjcv0i4jf774 |                | ru-central1-a | [10.128.0.0/24] |
+----------------------+-----------------------+----------------------+----------------+---------------+-----------------+
```

В файле `centos-7-base.json` изменяем значение для следующих параметров:
```bash
# cd packer
```
```bash
# grep -E 'folder_id|subnet_id|token' centos-7-base.json
      "folder_id": "",
      "subnet_id": "",
      "token": "",
```

Идентификатор подcети `subnet_id` узнаем через команду
```bash
# yc vpc subnets list | grep -E 'ID|my-subnet-a'
|          ID          |         NAME          |      NETWORK ID      | ROUTE TABLE ID |     ZONE      |      RANGE      |
| e9bqo3njs4kaln2v7loj | my-subnet-a           | enpni2qmk8djksk84a67 |                | ru-central1-a | [10.1.2.0/24]   |
```

Значение параметров `folder_id`, `token` получаем из вывода команды  `yc config list`
```bash
# yc config list
token: AQAAAAAOep*********************
cloud-id: b1gffbafdo7prn8rdsdt
folder-id: b1gvtndpj707oc5sjqj9
compute-default-zone: ru-central1-a
```

В данном случае параметры имеют следующие значения:
```bash
# grep -E 'folder_id|subnet_id|token' centos-7-base.json
      "folder_id": "b1gvtndpj707oc5sjqj9",
      "subnet_id": "e9bqo3njs4kaln2v7loj",
      "token": "AQAAAAAOep*********************",
```

Проверка корректности конфигурации packer
```bash
# packer validate centos-7-base.json
The configuration is valid.
```

Сборка образа
```bash
# packer build centos-7-base.json
yandex: output will be in this color.

==> yandex: Creating temporary ssh key for instance...
==> yandex: Using as source image: fd8qtvk4h4eqqn6i658b (name: "centos-7-v20211103", family: "centos-7")
==> yandex: Use provided subnet id e9bqo3njs4kaln2v7loj
==> yandex: Creating disk...
==> yandex: Creating instance...
==> yandex: Waiting for instance with id fhmrf5qpku7csnqhbnf0 to become active...
    yandex: Detected instance IP: 51.250.9.77
==> yandex: Using SSH communicator to connect: 51.250.9.77
==> yandex: Waiting for SSH to become available...
==> yandex: Connected to SSH!
==> yandex: Provisioning with shell script: /tmp/packer-shell4020754347
....
==> yandex: Stopping instance...
==> yandex: Deleting instance...
    yandex: Instance has been deleted!
==> yandex: Creating image: centos-7-base
==> yandex: Waiting for image to complete...
==> yandex: Success image create...
==> yandex: Destroying boot disk...
    yandex: Disk has been deleted!
Build 'yandex' finished after 2 minutes 12 seconds.

==> Wait completed after 2 minutes 12 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: centos-7-base (id: fd8dug98skfn0dd0hfls) with family name centos
```


Просмотр списка созданных образов:
```bash
# yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd8dug98skfn0dd0hfls | centos-7-base | centos | f2ebfhrshe5m6i4saf1j | READY  |
+----------------------+---------------+--------+----------------------+--------+
```

Удалим подсеть и сеть ранее созданную, которые использовалась для сборки образа, чтобы не выйти за лимиты количества сетей/подсетей,
которые Yandex cloud предоставляет по дефолту
```bash
# yc vpc subnets delete --name my-subnet-a && yc vpc network delete --name net
```

## Создание инфраструктуры с помощью Terraform

```bash
# cd ../terraform
```
Указываем значение токена в файле `provider.tf`
```bash
# grep token provider.tf
  token = "AQAAAAAOep*********************"
```
Значение токена получаем из вывода команды:
```bash
# yc config list | grep token
token: AQAAAAAOep*********************
```
Настройка следующих идентификаторов в файле `variables.tf`:
- облака (доступен по команде `yc config list`)
- каталога (доступен по команде `yc config list`)
- образа (доступен по команде `yc compute image list`)


Инициализация конфигурации
```bash
# terraform init
Terraform has been successfully initialized!
```

Проверка синтаксиса конфигурации
```bash
# terraform validate
Success! The configuration is valid.
```
Просмотр планируемых изменений
```bash
# terraform plan
....
Plan: 13 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_node01 = (known after apply)
  + external_ip_address_node02 = (known after apply)
  + external_ip_address_node03 = (known after apply)
  + external_ip_address_node04 = (known after apply)
  + external_ip_address_node05 = (known after apply)
  + external_ip_address_node06 = (known after apply)
  + internal_ip_address_node01 = "192.168.101.11"
  + internal_ip_address_node02 = "192.168.101.12"
  + internal_ip_address_node03 = "192.168.101.13"
  + internal_ip_address_node04 = "192.168.101.14"
  + internal_ip_address_node05 = "192.168.101.15"
  + internal_ip_address_node06 = "192.168.101.16"
```

Фактическое примение указаннх выше изменений - создание инфраструктуры
```bash
# terraform apply -auto-approve

Apply complete! Resources: 10 added, 0 changed, 8 destroyed.

Outputs:

external_ip_address_node01 = "51.250.12.175"
external_ip_address_node02 = "51.250.11.0"
external_ip_address_node03 = "51.250.0.21"
external_ip_address_node04 = "51.250.15.61"
external_ip_address_node05 = "51.250.15.157"
external_ip_address_node06 = "51.250.4.72"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
```

## Деплой Docker Swarm-кластера и  мониторинг стека в него с помощью Ansible

После создания инфраструктуры(сети, подсети и 6 виртуальных машин) Terraform запускает ansible-playbook-и, которые выполняют следующее:
- устанавливают все необходимые пакеты для инициализации кластера, включая Docker
- выполняют инициализаци Docker Swarm-кластера на первой ноде node01
- подключают все остальные ноды(node0{2..3} как manager stand by ноды, а node0{4..6} как worker-ноды)
- копируют исходный код мониторинг стека на все ноды кластера
- запускают мониторинг стек в Docker Swarm-кластере

Проверка текущих нод в кластере:
```bash
$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
5o6npdp8jzjv9c4p7tpvof0yf *   node01.netology.yc   Ready     Active         Leader           20.10.11
mgdswijjydak4jy1ai1hpeuov     node02.netology.yc   Ready     Active         Reachable        20.10.11
khd3dj5jvsg6749n3movc5bge     node03.netology.yc   Ready     Active         Reachable        20.10.11
thoz6vcuwfeakzyok39a2ziv8     node04.netology.yc   Ready     Active                          20.10.11
otjw8z7noigy3v56kjovifgta     node05.netology.yc   Ready     Active                          20.10.11
18teipd5eqxvj96kujpp5so6s     node06.netology.yc   Ready     Active                          20.10.11
```

Проверка существующих/задеплоенных стеков:
```bash
$ sudo docker stack ls
NAME               SERVICES   ORCHESTRATOR
swarm_monitoring   8          Swarm
```

Проверка состояние сервисов в задеплоенном стеке `swarm_monitoring`:
```bash
$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
i7oks97tczrr   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
5ylb7id7sv20   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
u35lgv3kcpk1   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
56nkjnroel54   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
7ahr4hwibb8s   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
nkhhfllsu5cq   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
85998hg09elw   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
rtmw5wc5kdk1   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

Просмотр спсика задач в задепленном стеке swarm_monitoring
```bash
$ sudo docker stack ps swarm_monitoring
ID             NAME                                                          IMAGE                                          NODE                 DESIRED STATE   CURRENT STATE             ERROR     PORTS
vxkn3sgpxpdk   swarm_monitoring_alertmanager.1                               stefanprodan/swarmprom-alertmanager:v0.14.0    node03.netology.yc   Running         Running 10 minutes ago
yuebp9i91zj3   swarm_monitoring_caddy.1                                      stefanprodan/caddy:latest                      node02.netology.yc   Running         Running 9 minutes ago
6ybuuggczwwj    \_ swarm_monitoring_caddy.1                                  stefanprodan/caddy:latest                      node03.netology.yc   Shutdown        Complete 10 minutes ago
j0uti2k5kqat   swarm_monitoring_cadvisor.5o6npdp8jzjv9c4p7tpvof0yf           google/cadvisor:latest                         node01.netology.yc   Running         Running 10 minutes ago
dhjbdpajkpfq   swarm_monitoring_cadvisor.18teipd5eqxvj96kujpp5so6s           google/cadvisor:latest                         node06.netology.yc   Running         Running 10 minutes ago
c0nbm4kgdbbz   swarm_monitoring_cadvisor.khd3dj5jvsg6749n3movc5bge           google/cadvisor:latest                         node03.netology.yc   Running         Running 10 minutes ago
wh9zjeipsfp8   swarm_monitoring_cadvisor.mgdswijjydak4jy1ai1hpeuov           google/cadvisor:latest                         node02.netology.yc   Running         Running 10 minutes ago
ywcnw3ilfvqu   swarm_monitoring_cadvisor.otjw8z7noigy3v56kjovifgta           google/cadvisor:latest                         node05.netology.yc   Running         Running 10 minutes ago
93xubi34npo8   swarm_monitoring_cadvisor.thoz6vcuwfeakzyok39a2ziv8           google/cadvisor:latest                         node04.netology.yc   Running         Running 10 minutes ago
5f5nu6loir07   swarm_monitoring_dockerd-exporter.5o6npdp8jzjv9c4p7tpvof0yf   stefanprodan/caddy:latest                      node01.netology.yc   Running         Running 10 minutes ago
wsy8mio9q0in   swarm_monitoring_dockerd-exporter.18teipd5eqxvj96kujpp5so6s   stefanprodan/caddy:latest                      node06.netology.yc   Running         Running 10 minutes ago
owiekni788nr   swarm_monitoring_dockerd-exporter.khd3dj5jvsg6749n3movc5bge   stefanprodan/caddy:latest                      node03.netology.yc   Running         Running 10 minutes ago
1p03fm4z08g4   swarm_monitoring_dockerd-exporter.mgdswijjydak4jy1ai1hpeuov   stefanprodan/caddy:latest                      node02.netology.yc   Running         Running 10 minutes ago
b0y3vl91eun6   swarm_monitoring_dockerd-exporter.otjw8z7noigy3v56kjovifgta   stefanprodan/caddy:latest                      node05.netology.yc   Running         Running 10 minutes ago
m85yup2zk7qx   swarm_monitoring_dockerd-exporter.thoz6vcuwfeakzyok39a2ziv8   stefanprodan/caddy:latest                      node04.netology.yc   Running         Running 10 minutes ago
88uqqo8f7js6   swarm_monitoring_grafana.1                                    stefanprodan/swarmprom-grafana:5.3.4           node01.netology.yc   Running         Running 10 minutes ago
mw5zdo1krnt4   swarm_monitoring_node-exporter.5o6npdp8jzjv9c4p7tpvof0yf      stefanprodan/swarmprom-node-exporter:v0.16.0   node01.netology.yc   Running         Running 10 minutes ago
wh70sr1mxn0v   swarm_monitoring_node-exporter.18teipd5eqxvj96kujpp5so6s      stefanprodan/swarmprom-node-exporter:v0.16.0   node06.netology.yc   Running         Running 10 minutes ago
ss6mzr9nvzav   swarm_monitoring_node-exporter.khd3dj5jvsg6749n3movc5bge      stefanprodan/swarmprom-node-exporter:v0.16.0   node03.netology.yc   Running         Running 10 minutes ago
9nptdhyd3ies   swarm_monitoring_node-exporter.mgdswijjydak4jy1ai1hpeuov      stefanprodan/swarmprom-node-exporter:v0.16.0   node02.netology.yc   Running         Running 10 minutes ago
asj3mxtd352z   swarm_monitoring_node-exporter.otjw8z7noigy3v56kjovifgta      stefanprodan/swarmprom-node-exporter:v0.16.0   node05.netology.yc   Running         Running 10 minutes ago
lnp5bhnycofo   swarm_monitoring_node-exporter.thoz6vcuwfeakzyok39a2ziv8      stefanprodan/swarmprom-node-exporter:v0.16.0   node04.netology.yc   Running         Running 10 minutes ago
x8o05oceubj6   swarm_monitoring_prometheus.1                                 stefanprodan/swarmprom-prometheus:v2.5.0       node02.netology.yc   Running         Running 10 minutes ago
3m7qa6u3q769   swarm_monitoring_unsee.1                                      cloudflare/unsee:v0.8.0                        node01.netology.yc   Running         Running 10 minutes ago
```
