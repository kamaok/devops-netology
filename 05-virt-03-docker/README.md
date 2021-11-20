
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.


```bash
# mkdir nginx; cd nginx
```
```bash
# cat <<EOF>index.html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
EOF
```
```bash
# cat <<EOF>Dockerfile
FROM nginx:1.20
COPY index.html /usr/share/nginx/html/
EOF
```
```bash
# docker build -t kamaok/nginx-netology:1.20 .
Sending build context to Docker daemon  3.072kB
Step 1/2 : FROM nginx:1.20
1.20: Pulling from library/nginx
eff15d958d66: Pull complete
1f3e1e3ef6aa: Pull complete
231009cab23f: Pull complete
b2ef879f0046: Pull complete
5495a7eec709: Pull complete
ddde57a4eac9: Pull complete
Digest: sha256:4238492fe91b7a8d381efec63824697bbad9f9dd36b7301912ead6d2e62406e1
Status: Downloaded newer image for nginx:1.20
 ---> aedf7f31bdab
Step 2/2 : COPY index.html /usr/share/nginx/html/
 ---> 9a41c65eaf7f
Successfully built 9a41c65eaf7f
Successfully tagged kamaok/nginx-netology:1.20
```
```bash
# docker run --rm -d -p 8080:80 kamaok/nginx-netology:1.20
7492b400a5c03d64294b446fb6e15598dd58f2a934e9c56ccb8965fb6ed5c1e7
```
```bash
# docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS         PORTS                  NAMES
7492b400a5c0   kamaok/nginx-netology:1.20   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds   0.0.0.0:8080->80/tcp   optimistic_torvalds
```
```bash
# curl localhost:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
```bash
# docker login -u kamaok
Password:
WARNING! Your password will be stored unencrypted in /home/eugene/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
```bash
# docker push kamaok/nginx-netology:1.20
```

https://hub.docker.com/repository/docker/kamaok/nginx-netology

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;

  Физическая машина - максимальная производительность в виду отсутствия накладных расходов на виртуализацию(в частности CPU и подсистема ввода/вывода)
- Nodejs веб-приложение;

  В Docker-контейнере - удобно держать в изолированном от хостовой системы зоопарк версий nodejs и их модулей
- Мобильное приложение c версиями для Android и iOS;

  Полагаю, что мобильное приложеие потребует для себя много зависимостей и разностороннего программного обеспечения
  Заупск в Docker-контейнере, который позволяет устанавливать разнообразное ПО и его разные версии выглядит удобным
- Шина данных на базе Apache Kafka;

  В конетейнерах через Docker-compose, т.к. Kafka требует для своей работы Zookeeper в качестве Service Discovery. В последнее время Kafka уже научилась работать самостоятельно и без Zookeper

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

  Виртуальные машины - т.к. elasticsearch очень требователен к памяти, скорости работы дисковой подсистемы, CPU-утилизации и используется кластерное решение, которое требует,как минимум 3 виртуальных машины + строгое разделение ресурсов

- Мониторинг-стек на базе Prometheus и Grafana;

  В конетейнерах через Docker-compose с пробросом каталогов для хранения данных(как минимум для TSDB для Prometheus) с хоста. т.е. использование bind-mount, а не дефолтных типов томов, которые хранятся на overlay-файловой системе,что дает потерю в производительности дисковой подсистемы ввода/вывода

- MongoDB, как основное хранилище данных для java-приложения;

  Базу данных не в кластере можно запускать,как на виртуальной, так и на физической машине

  Также ее можно запускать и в контейнере без какой-либо потери производительности, но с монтированием с хоста каталога с данными внутрь контейнера по указанной в предыдущем пункте причине

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

  В виртуальной машине т.к. нужно будет запускать gitlab-runner-ы, которые запускаются в docker-е, т.е если запускать gitlab в docker-е,то мы получаем gitlab-runner запущенный как docker-in-docker, к которому есть вопросы с точки зрения безопасности

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```bash
# mkdir /tmp/data
```
```bash
# docker run --rm --name centos8 -d -it -v /tmp/data:/data centos:8
# docker run --rm --name debian10 -d -it -v /tmp/data:/data debian:10
```
```bash
# docker ps
CONTAINER ID   IMAGE       COMMAND       CREATED         STATUS         PORTS     NAMES
7730faedfc6f   debian:10   "bash"        3 seconds ago   Up 2 seconds             debian10
f7d9398e51c9   centos:8    "/bin/bash"   1 minutes ago   Up 1 minutes             centos8
```
```bash
# docker exec centos8 sh -c "echo 'data from centos' > /data/centos.txt"
```
```bash
# echo "data from host" > /tmp/data/host.txt
```
```bash
# docker exec debian10  ls -l /data/
total 8
-rw-r--r-- 1 root root 17 Nov 20 18:33 centos.txt
-rw-rw-r-- 1 1000 1000 15 Nov 20 18:32 host.txt
```
```bash
# docker exec debian10 sh -c "cat /data/*"
data from centos
data from host
```
```bash
# ls -l /tmp/data/
total 8
-rw-r--r-- 1 root   root   17 ноя 20 20:33 centos.txt
-rw-rw-r-- 1 eugene eugene 15 ноя 20 20:32 host.txt
```
```bash
# docker exec centos8 ls -l /data/
total 8
-rw-r--r-- 1 root root 17 Nov 20 18:33 centos.txt
-rw-rw-r-- 1 1000 1000 15 Nov 20 18:32 host.txt
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
```bash
# cd ~/Netology/git/devops-netology/05-virt-03-docker/src/build/ansible
```
```bash
# docker build -t kamaok/ansible:2.9.24 .
Sending build context to Docker daemon   2.56kB
Step 1/5 : FROM alpine:3.14
3.14: Pulling from library/alpine
......
Step 5/5 : CMD [ "ansible-playbook", "--version" ]
 ---> Running in 4ff98469a6e3
Removing intermediate container 4ff98469a6e3
 ---> f1d670e9506d
Successfully built f1d670e9506d
Successfully tagged kamaok/ansible:2.9.24
```
```bash
# docker login -u kamaok
Password:
WARNING! Your password will be stored unencrypted in /home/eugene/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
```bash
# docker push kamaok/ansible:2.9.24
```

https://hub.docker.com/repository/docker/kamaok/ansible
