# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql


```bash
# cat docker-compose.yml

version: "3.7"
networks:
  postgres:
    driver: bridge
services:
  db:
    image: postgres:13
    volumes:
      - data:/var/lib/postgresql/data
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
```
```bash
# docker-compose up -d
```
```bash
# docker-compose ps
         Name                       Command               State           Ports
----------------------------------------------------------------------------------------
64postgresql_adminer_1   entrypoint.sh docker-php-e ...   Up      0.0.0.0:8080->8080/tcp
64postgresql_db_1        docker-entrypoint.sh postgres    Up      5432/tcp
```
```bash
# docker inspect 64postgresql_db_1 | grep -A 10 -i mounts
        "Mounts": [
            {
                "Type": "volume",
                "Name": "64postgresql_data",
                "Source": "/var/lib/docker/volumes/64postgresql_data/_data",
                "Destination": "/var/lib/postgresql/data",
                "Driver": "local",
                "Mode": "rw",
                "RW": true,
                "Propagation": ""
            }
```
```bash
# docker-compose exec db bash
```
```bash
# root@85a89eaeb496:/# su -l postgres
postgres@85a89eaeb496:~$ psql
psql (13.5 (Debian 13.5-1.pgdg110+1))
Type "help" for help.
postgres=#
```

Найдите и приведите управляющие команды для:

вывода списка БД
```bash
\l[+]   [PATTERN]
```
подключения к БД
```bash
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
```
вывода списка таблиц
```bash
\dt[S+] [PATTERN]
```
вывода описания содержимого таблиц
```bash
\d[S+]  NAME
```
выхода из psql
```bash
\q
```


## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```bash
docker cp test_dump.sql 64postgresql_db_1:/tmp/
```

```bash
docker-compose exec db bash
root@85a89eaeb496:/#
```
```bash
root@85a89eaeb496:/# su -l postgres
postgres@85a89eaeb496:~$
```
```bash
postgres@85a89eaeb496:~$ psql
postgres=#
```
```bash
postgres=# CREATE DATABASE test_database;
postgres-#
```
```bash
postgres=# \q
```
```bash
postgres@85a89eaeb496:~$ psql test_database < /tmp/test_dump.sql
```
```bash
postgres@85a89eaeb496:~$ psql
postgres=#
```
```sql
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=#
```
```sql
test_database=# ANALYZE orders;
ANALYZE
```
```sql
test_database=# select attname,avg_width from pg_stats where tablename='orders';
 attname | avg_width
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
```
столбец `title` таблицы `orders` имеет наибольшее среднее значение размера элементов в байтах


## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Да, например с помощью декларативного секционирования:

```sql
CREATE TABLE orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) PARTITION BY RANGE (price);
```
```sql
CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM (MINVALUE) TO (500);
```
```sql
CREATE TABLE orders_1 PARTITION OF orders
    FOR VALUES FROM (500) TO (MAXVALUE);
```

Непонятно как сделать шардирование уже имеющейся таблицы, которая создавалась без `PARTITION`


Несколько раз перечитывал информацию по этим ссылкам, но понимания так и не пришло

https://postgrespro.ru/docs/postgresql/10/ddl-partitioning

https://postgrespro.ru/docs/postgresql/10/sql-createtable#SQL-CREATETABLE-PARTITION

https://postgrespro.ru/docs/enterprise/12/sql-altertable

https://www.postgresql.eu/events/pgconfeu2019/sessions/session/2685/slides/225/pgconf-eu-2019.pdf

Гугление:

Ответа нет

https://stackoverflow.com/questions/59530280/alter-table-to-add-partition-by-range-in-postgres

Тут сложно и непонятно:

https://dba.stackexchange.com/questions/106014/how-to-partition-existing-table-in-postgres

Запрос типа
`ALTER TABLE orders PARTITION BY RANGE (price);`
синтаксически неверен

Секционные таблицы можно создавать только,если родитель на который они ссылаются,(в данном случае таблица `orders`) имеет поддержку `PARTITION`

```sql
CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM (MINVALUE) TO (500);
```
```sql
CREATE TABLE orders_1 PARTITION OF orders
    FOR VALUES FROM (500) TO (MAXVALUE);
```

Какой вообще порядок действий/алгоритм должен использоваться: создание новой промежуточной таблицы `orders_temp` или изменение текущей
и т.д., чтобы можно было добавить поддержку `PARTITION` для таблицы `orders` ?

т.е. у меня отсутствует понимание,как это должно происходить

Возможно, какие-то запросы,указанные в этой транзакции, и необходимо действительно использовать для реализации шардирования:

```sql
BEGIN

CREATE TABLE order_1 AS
  SELECT *
  FROM orders
  WHERE price > 499;

CREATE TABLE order_2 AS
  SELECT *
  FROM orders
  WHERE price <= 499;

ALTER TABLE orders ATTACH PARTITION order_2 FOR VALUES ??????????????????
ALTER TABLE orders ATTACH PARTITION order_1 FOR VALUES ??????????????????
ALTER TABLE orders ADD PARTITION order_1 ??????????????????
ALTER TABLE orders ADD PARTITION order_2 ??????????????????

COMMIT
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Добавить  в конец файла с дампом перед блоком
```sql
--
-- PostgreSQL database dump complete
--
```

следующий блок

```sql
--
-- Name: orders titleconstraint; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT titleconstraint UNIQUE (title);
```


Если на живой базе данных, то выполнить запрос
```bash
test_database=# ALTER TABLE orders ADD CONSTRAINT titleconstraint UNIQUE (title);
```
Если при создании базы данных, то используем опцию `unique` для нужного поля одним из указанных ниже способов:
```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0,
    UNIQUE(title)
);
```