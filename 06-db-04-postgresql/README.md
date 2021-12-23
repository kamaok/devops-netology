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


`Реализация секционирования с использованием наследования, в котором дочерние таблицы(`orders_1`,`orders_2`) будут унаследованы от главной(`orders`) c указанием неперекрывающихся ограничений, определяющие допустимые значения ключей для каждой секции

```sql
test_database=# CREATE TABLE orders_1 (
    CHECK (price > '499')
) INHERITS (orders);
```
```sql
test_database=# CREATE TABLE orders_2 (
    CHECK (price <= '499')
) INHERITS (orders);
```
Заполнениие таблиц соответствующими значениями из родительской таблицы согласно условию:
```sql
test_database=# INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499;
```
```sql
test_database=# INSERT INTO orders_2 SELECT * FROM orders WHERE price <= 499;
```
Проверка значений в дочерних таблицах:
```sql
test_database=# select * from orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)
```
```sql
test_database=# select * from orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
```
Создание правил(`price_more_than_499` и `price_equal_or_less_than_499`), при которых команды по вставке данных в таблицу `orders`(`ON INSERT TO orders`)
будут заменяться(`INSTEAD`) на команды по вставке этих данных в соответствующие дочерние таблицы(`INSERT INTO orders_{1.2} VALUES (NEW.*)`)
в зависимости от значение ключа `price`

```sql
test_database=# CREATE RULE price_more_than_499 AS ON INSERT TO orders WHERE (price > 499) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
```
```sql
test_database=# CREATE RULE price_equal_or_less_than_499 AS ON INSERT TO orders WHERE (price <= 499) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
```

Добавляем новые данные и проверяем их наличие в соответствующей дочерней таблице
```sql
test_database=# INSERT INTO orders (id, title, price) VALUES ('11', 'Test title', '850');
```
```sql
test_database=# select * from orders_2 where price=850;;
 id | title | price
----+-------+-------
(0 rows)
```
```sql
test_database=# select * from orders_1 where price=850;;
 id |   title    | price
----+------------+-------
 11 | Test title |   850
(1 row)
```
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