# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume,
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```bash
# cat docker-compose.yml

version: "3.7"
networks:
  postgres:
    driver: bridge
services:
  db:
    image: postgres:12
    volumes:
      - data:/var/lib/postgresql/data
      - backup:/var/backup
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: mypassword
    expose:
      - "5432"
    networks:
     - postgres
  adminer:
    image: adminer
    restart: unless-stopped
    ports:
      - 8080:8080
    expose:
      - "8080"
    networks:
     - postgres
volumes:
  data:
    driver: local
  backup:
    driver: local
```
```bash
# docker-compose up -d
```
```bash
# docker-compose ps
     Name                    Command               State           Ports
---------------------------------------------------------------------------------
62sql_adminer_1   entrypoint.sh docker-php-e ...   Up      0.0.0.0:8080->8080/tcp
62sql_db_1        docker-entrypoint.sh postgres    Up      5432/tcp
```
```bash
# docker inspect 62sql_db_1 | grep -A 20 -i mounts
        "Mounts": [
            {
                "Type": "volume",
                "Name": "62sql_backup",
                "Source": "/var/lib/docker/volumes/62sql_backup/_data",
                "Destination": "/var/backup",
                "Driver": "local",
                "Mode": "rw",
                "RW": true,
                "Propagation": ""
            },
            {
                "Type": "volume",
                "Name": "62sql_data",
                "Source": "/var/lib/docker/volumes/62sql_data/_data",
                "Destination": "/var/lib/postgresql/data",
                "Driver": "local",
                "Mode": "rw",
                "RW": true,
                "Propagation": ""
            }
```


## Задача 2

В БД из задачи 1:
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db


```bash
# docker-compose exec db bash
```
```bash
root@37da03a2d1bd:/# su -l postgres -c 'psql -U postgres'
psql (12.9 (Debian 12.9-1.pgdg110+1))
Type "help" for help.

postgres=#
```
```bash
postgres=# CREATE USER test_admin_user;
CREATE ROLE
```
```bash
postgres=# CREATE DATABASE test_db
postgres-#
```
```bash
postgres=# \c test_db;
You are now connected to database "test_db" as user "postgres".
```
```bash
test_db=# CREATE TABLE orders (
    id SERIAL,
    наименование VARCHAR(100),
    цена INTEGER,
    PRIMARY KEY (id)
);
```
```bash
test_db=# CREATE TABLE clients (
    id SERIAL,
    фамилия VARCHAR(50),
    "страна проживания" VARCHAR(50),
    заказ INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY(заказ) REFERENCES orders (id)
);
```
```bash
test_db=# CREATE INDEX countryindex ON clients ("страна проживания");
```
```bash
test_db=# GRANT USAGE ON SCHEMA public TO test_admin_user;
GRANT
```
```bash
test_db=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO test_admin_user;
GRANT
```
```bash
test_db=# GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO test_admin_user;
GRANT
```
```bash
test_db=# GRANT ALL PRIVILEGES ON DATABASE test_db TO test_admin_user;
GRANT
```
```bash
test_db=# create user test_simple_user;
CREATE ROLE
```
```bash
test_db=# GRANT SELECT,INSERT,UPDATE,DELETE ON clients TO test_simple_user;
GRANT
```
```bash
test_db=# GRANT SELECT,INSERT,UPDATE,DELETE ON orders TO test_simple_user;
GRANT
```
```bash
test_db=# \l+
                                                                      List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |      Access privileges       |  Size   | Tablespace |                Description

-----------+----------+----------+------------+------------+------------------------------+---------+------------+------------------------------
--------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                              | 8073 kB | pg_default | default administrative connec
tion database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +| 7825 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres        |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +| 7825 kB | pg_default | default template for new data
bases
           |          |          |            |            | postgres=CTc/postgres        |         |            |
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                +| 8097 kB | pg_default |
           |          |          |            |            | postgres=CTc/postgres       +|         |            |
           |          |          |            |            | test_admin_user=CTc/postgres |         |            |
(4 rows)
```
```bash
test_db=# \d clients
                                                 Table "public.clients"
              Column               |         Type          | Collation | Nullable |               Default
-----------------------------------+-----------------------+-----------+----------+-------------------------------------
 id                                | integer               |           | not null | nextval('clients_id_seq'::regclass)
 фамилия                    | character varying(50) |           |          |
 страна проживания | character varying(50) |           |          |
 заказ                        | integer               |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "countryindex" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```
```bash
test_db=# \d orders
                                             Table "public.orders"
          Column          |          Type          | Collation | Nullable |              Default
--------------------------+------------------------+-----------+----------+------------------------------------
 id                       | integer                |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(100) |           |          |
 цена                 | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

```bash
test_db=# SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name='orders';
     grantee      | privilege_type
------------------+----------------
 postgres         | INSERT
 postgres         | SELECT
 postgres         | UPDATE
 postgres         | DELETE
 postgres         | TRUNCATE
 postgres         | REFERENCES
 postgres         | TRIGGER
 test_admin_user  | INSERT
 test_admin_user  | SELECT
 test_admin_user  | UPDATE
 test_admin_user  | DELETE
 test_admin_user  | TRUNCATE
 test_admin_user  | REFERENCES
 test_admin_user  | TRIGGER
 test_simple_user | INSERT
 test_simple_user | SELECT
 test_simple_user | UPDATE
 test_simple_user | DELETE
(18 rows)
```

```bash
test_db=# SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name='clients';
     grantee      | privilege_type
------------------+----------------
 postgres         | INSERT
 postgres         | SELECT
 postgres         | UPDATE
 postgres         | DELETE
 postgres         | TRUNCATE
 postgres         | REFERENCES
 postgres         | TRIGGER
 test_admin_user  | INSERT
 test_admin_user  | SELECT
 test_admin_user  | UPDATE
 test_admin_user  | DELETE
 test_admin_user  | TRUNCATE
 test_admin_user  | REFERENCES
 test_admin_user  | TRIGGER
 test_simple_user | INSERT
 test_simple_user | SELECT
 test_simple_user | UPDATE
 test_simple_user | DELETE
(18 rows)
```
```bash
test_db=# \dp
                                          Access privileges
 Schema |      Name      |   Type   |        Access privileges         | Column privileges | Policies
--------+----------------+----------+----------------------------------+-------------------+----------
 public | clients        | table    | postgres=arwdDxt/postgres       +|                   |
        |                |          | test_admin_user=arwdDxt/postgres+|                   |
        |                |          | test_simple_user=arwd/postgres   |                   |
 public | clients_id_seq | sequence | postgres=rwU/postgres           +|                   |
        |                |          | test_admin_user=rwU/postgres     |                   |
 public | orders         | table    | postgres=arwdDxt/postgres       +|                   |
        |                |          | test_admin_user=arwdDxt/postgres+|                   |
        |                |          | test_simple_user=arwd/postgres   |                   |
 public | orders_id_seq  | sequence | postgres=rwU/postgres           +|                   |
        |                |          | test_admin_user=rwU/postgres     |                   |
(4 rows)
```


## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы
- приведите в ответе:
    - запросы
    - результаты их выполнения.

```bash
test_db=# INSERT INTO orders (наименование, цена) VALUES
('Шоколад', 10),
('Принтер', '3000'),
('Книга', '500'),
('Монитор', '7000'),
('Гитара', '4000');
INSERT 0 5
```
```bash
test_db=# INSERT INTO clients (фамилия, "страна проживания") VALUES
('Иванов Иван Иванович', 'USA'),
('Петров Петр Петрович', 'Canada'),
('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'),
('Ritchie Blackmore', 'Russia');
INSERT 0 5
```
```bash
test_db=# select count(*) from clients;
 count
-------
     5
(1 row)
```
```bash
test_db=# select count(*) from orders;
 count
-------
     5
(1 row)
```


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказк - используйте директиву `UPDATE`.

```bash
test_db=# update clients set заказ='3' where фамилия='Иванов Иван Иванович';
UPDATE 1
```
```bash
test_db=# update clients set заказ='4' where фамилия='Петров Петр Петрович';
UPDATE 1
```
```bash
test_db=# update clients set заказ='5' where фамилия='Иоганн Себастьян Бах';
UPDATE 1
```

```bash
test_db=# select фамилия from clients where заказ IS NOT NULL;
             фамилия
----------------------------------------
 Иванов Иван Иванович
 Петров Петр Петрович
 Иоганн Себастьян Бах
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```bash
test_db=# EXPLAIN select фамилия from clients where заказ IS NOT NULL;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..13.00 rows=298 width=118)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```

Числа, перечисленные в скобках (слева направо), имеют следующий смысл:

Приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки.

Приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки. На практике родительский узел может досрочно прекратить чтение строк дочернего (см. приведённый ниже пример с LIMIT).

Ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.
Оно выражает не число строк, обработанных или просканированных узлом плана, а число строк, выданных этим узлом

Ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).

в выводе EXPLAIN показано, что условие WHERE применено как «фильтр» к узлу плана Seq Scan (Последовательное сканирование).

Это означает, что узел плана проверяет это условие для каждого просканированного им узла и выводит только те строки, которые удовлетворяют ему.

Точность оценок планировщика можно проверить, используя команду EXPLAIN с параметром ANALYZE.
С этим параметром EXPLAIN на самом деле выполняет запрос, а затем выводит фактическое число строк и время выполнения, накопленное в каждом узле плана, вместе с теми же оценками, что выдаёт обычная команда EXPLAIN.

```bash
test_db=# EXPLAIN ANALYZE select фамилия from clients where заказ IS NOT NULL;
                                              QUERY PLAN
------------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..13.00 rows=298 width=118) (actual time=0.034..0.039 rows=3 loops=1)
   Filter: ("заказ" IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.111 ms
 Execution Time: 0.076 ms
(5 rows)
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

```bash
root@37da03a2d1bd:/#chown -R postgres:postgres /var/backup
```
```bash
root@37da03a2d1bd:/# su -l postgres
```
```bash
postgres@37da03a2d1bd:~$ pg_dump test_db > /var/backup/test_db.sql
```
```bash
postgres@37da03a2d1bd:~$ exit
```
```bash
root@37da03a2d1bd:/# exit
```
```bash
# docker-compose stop
```
```bash
# docker run --name second_db -d -e POSTGRES_PASSWORD=mypassword postgres:12
```
```bash
# sudo docker cp /var/lib/docker/volumes/62sql_backup/_data/test_db.sql second_db:/tmp/
```
```bash
# docker exec -it second_db bash
```
```bash
root@872ff0b5c05f:/# su -l postgres
```
```bash
postgres@872ff0b5c05f:~$ psql test_db < /tmp/test_db.sql
```
```bash
postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
```
```bash
test_db=# \dt+
                       List of relations
 Schema |  Name   | Type  |  Owner   |    Size    | Description
--------+---------+-------+----------+------------+-------------
 public | clients | table | postgres | 8192 bytes |
 public | orders  | table | postgres | 8192 bytes |
(2 rows)
```
```bash
test_db=# select * from clients;
 id |             фамилия             | страна проживания | заказ
----+----------------------------------------+-----------------------------------+------------
  4 | Ронни Джеймс Дио         | Russia                            |
  5 | Ritchie Blackmore                      | Russia                            |
  1 | Иванов Иван Иванович | USA                               |          3
  2 | Петров Петр Петрович | Canada                            |          4
  3 | Иоганн Себастьян Бах | Japan                             |          5
(5 rows)
```
```bash
test_db=# select * from orders;
 id | наименование | цена
----+--------------------------+----------
  1 | Шоколад           |       10
  2 | Принтер           |     3000
  3 | Книга               |      500
  4 | Монитор           |     7000
  5 | Гитара             |     4000
(5 rows)
```
