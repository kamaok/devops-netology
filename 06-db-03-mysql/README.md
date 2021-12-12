# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

```bash
# cat docker-compose.yml
version: "3.7"
networks:
  mysql:
    driver: bridge
services:
  db:
    image: mysql:8
    volumes:
      - data:/var/lib/mysqlql/data
    command: --default-authentication-plugin=mysql_native_password
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: mypassword
    expose:
      - "3306"
    networks:
     - mysql
  adminer:
    image: adminer
    restart: unless-stopped
    ports:
      - 8080:8080
    expose:
      - "8080"
    networks:
     - mysql
volumes:
  data:
    driver: local
```
```bash
# docker-compose up -d
```
```bash
# docker-compose ps
      Name                     Command               State           Ports
-----------------------------------------------------------------------------------
63mysql_adminer_1   entrypoint.sh docker-php-e ...   Up      0.0.0.0:8080->8080/tcp
63mysql_db_1        docker-entrypoint.sh --def ...   Up      3306/tcp, 33060/tcp
```
```bash
# docker-compose exec db bash -c 'mysql -u root -pmypassword -e "create database test_db'
```
```bash
# docker-compose exec -T db bash -c 'mysql -u root -pmypassword test_db' < test_dump.sql
```
```bash
# docker-compose exec db bash
```
```bash
root@48fa1254bdbc:/# mysql -u root -pmypassword -e "use test_db; show tables" 2>/dev/null
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
```

```bash
mysql> \s
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		20
Current database:
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.27 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			11 min 9 sec

Threads: 2  Questions: 65  Slow queries: 0  Opens: 191  Flush tables: 3  Open tables: 109  Queries per second avg: 0.097
--------------
```

```bash
mysql> select count(*) from test_db.orders where price>300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
```bash
mysql> select * from test_db.orders where price>300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```


## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

```bash
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass'
WITH MAX_QUERIES_PER_HOUR 100
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3  ATTRIBUTE '{"fname": "Pretty", "sname": "James"}';
```
```bash
mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
```
```bash
mysql> FLUSH PRIVILEGES;
```

Проверяем `select` доступ к таблице `orders` в базе данных `test_db` для пользователя `test@localhost` с паролем `test-pass`
```bash
root@ba40362199b7:/# mysql -u test -ptest-pass -e "select * from test_db.orders;" 2>/dev/null
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
```

Просмотр аттрибутов пользователя `test@localhost`
```bash
root@ba40362199b7:/# mysql -u root -pmypassword -e "SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test' AND HOST = 'localhost'\G" 2>/dev/null
*************************** 1. row ***************************
     USER: test
     HOST: localhost
ATTRIBUTE: {"fname": "Pretty", "sname": "James"}
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
```
```bash
mysql> select * from test_db.orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.01 sec)
```
```bash
mysql> show warnings;
+---------+------+--------------------------------------------------------------------------------------------------------------+
| Level   | Code | Message                                                                                                      |
+---------+------+--------------------------------------------------------------------------------------------------------------+
| Warning | 1287 | 'SHOW PROFILES' is deprecated and will be removed in a future release. Please use Performance Schema instead |
+---------+------+--------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```
```bash
mysql> show profiles;
+----------+------------+------------------------------+
| Query_ID | Duration   | Query                        |
+----------+------------+------------------------------+
|        1 | 0.00127150 | select * from test_db.orders |
|        2 | 0.00024950 | show warnings                |
+----------+------------+------------------------------+
2 rows in set, 1 warning (0.00 sec)
```

```bash
mysql> show create table test_db.orders;
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table  | Create Table                                                                                                                                                                                                                              |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| orders | CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

Создаем дамп таблицы движок для которой нужно изменить
```bash
root@48fa1254bdbc:/# mysqldump -u root -pmypassword test_db orders > orders.sql
```

Проверяем текущий движок, изменяем его на требуемый, проверяем новый движок в файле дампа таблицы
```bash
root@48fa1254bdbc:/# grep ENGINE= orders.sql
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
```bash
root@48fa1254bdbc:/# sed -i 's/ENGINE=InnoDB/ENGINE=MyISAM/g' orders.sql
```
```bash
root@48fa1254bdbc:/# grep ENGINE= orders.sql
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
Восстанавливаем таблицу из бекапа, который уже содержит требуемый движок таблицы
```bash
root@48fa1254bdbc:/# mysql -u root -pmypassword test_db < orders.sql
```
Проверка движка таблицы
```bash
root@48fa1254bdbc:/# mysql -u root -pmypassword -e "show create table test_db.orders\G" 2>/dev/null
```
```bash
*************************** 1. row ***************************
       Table: orders
Create Table: CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```



## Задача 4

Изучите файл `my.cnf` в директории `/etc/mysql`.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.


Проверка текущих/дефолтных значений
```bash
# mysql -u root -pmypassword -e "show variables" 2>/dev/null | grep -E 'innodb_flush_log_at_trx_commit|innodb_file_per_table|innodb_log_buffer_size|innodb_buffer_pool_size|innodb_log_file_size|innodb_flush_method'
innodb_buffer_pool_size	134217728
innodb_file_per_table	ON
innodb_flush_log_at_trx_commit	1
innodb_log_buffer_size	16777216
innodb_log_file_size	50331648
```

Проверка размера ОЗУ установленного на сервере:
```bash
# grep MemTotal /proc/meminfo
MemTotal:       16275300 kB
```

Скорость IO важнее сохранности данных

`innodb_flush_log_at_trx_commit = 2`

`innodb_flush_method=O_DSYNC`

Нужна компрессия таблиц для экономии места на диске

`innodb_file_per_table = 1`

Размер буффера с незакомиченными транзакциями 1 Мб

`innodb_log_buffer_size = 1Mb`

Буффер кеширования 30% от ОЗУ

`innodb_buffer_pool_size = 5Gb`

Размер файла логов операций 100 Мб

`innodb_log_file_size = 100Mb`


Копирование конфигурационного файла MySQL с контейнера на хост
```bash
# docker cp $(docker ps --format "{{.Names}}" | grep db):/etc/mysql/conf.d/mysql.cnf .
```
Добавление параметров в конфигурационный файл `mysql.cnf` на хосте

Добавляем секцию `[mysqld]` тем самым информируя mysql, о том, что все нижеуказанные этой секции настройки применяются к серверу(`mysqld`), а не к клиенту(`mysql`)

```bash
docker-compose exec db bash -c 'grep -Ev "^#|^$" /etc/mysql/conf.d/mysql.cnf'
[mysql]
[mysqld]
innodb_flush_log_at_trx_commit = 2
innodb_flush_method=O_DSYNC
innodb_file_per_table = 1
innodb_log_buffer_size = 1Mb
innodb_buffer_pool_size = 5,4Gb
innodb_log_file_size = 100Mb
```

Добавление конфигуарционного файла `mysql.cnf` как docker volume-а в `docker-compose.yml` файл для проброса внутрь контейнера файла с хоста
```bash
# nano docker-compose.yml
...
services:
  db:
    image: mysql:8
    volumes:
      - data:/var/lib/mysqlql/data
      - ./mysql.cnf:/etc/mysql/conf.d/mysql.cnf
...
```

Пересоздание контейнера с mysql, чтобы применились настройки по добавленному docker volume
```bash
# docker-compose up -d db
```

Проверка наличия наших изменений в конфигуарционном файле `mysql.cnf` внутри контейнера
```bash
# docker-compose exec db bash -c 'grep -vE "^$|^#" /etc/mysql/conf.d/mysql.cnf'
[mysql]
[mysqld]
innodb_flush_log_at_trx_commit = 2
innodb_flush_method=O_DSYNC
innodb_file_per_table = 1
innodb_log_buffer_size = 1Mb
innodb_buffer_pool_size = 5Gb
innodb_log_file_size = 100Mb
```

Проверка текущих значений измененных нами параметров
```bash
# docker-compose exec db bash -c 'mysql -u root -pmypassword -e "show variables" 2>/dev/null | grep -E "innodb_flush_log_at_trx_commit|innodb_file_per_table|innodb_log_buffer_size|innodb_buffer_pool_size|innodb_log_file_size|innodb_flush_method"'
innodb_buffer_pool_size	5368709120
innodb_file_per_table	ON
innodb_flush_log_at_trx_commit	2
innodb_flush_method	O_DSYNC
innodb_log_buffer_size	1048576
innodb_log_file_size	104857600
```