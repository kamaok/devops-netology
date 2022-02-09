## Установка Java, Elastic и Kibana

### Запуск playbook-а

- для установки Java+Elastic+Kibana
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml
   ```

- для установки только Java
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml --tags java
   ```

- для установки только Elastic
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml --tags elastic
   ```

- для установки только Kibana
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml --tags kibana
   ```

### Доступные параметры(переменные):
```bash
Java
```

`java_jdk_version` - версия устанавлвиаемой java

```bash
Elastic
```

`elastic_version`  - версия Elastic

`elastic_home` - каталог установки Elastic

```bash
Kibana
```

`kibana_version` - версия Kibana

`kibana_home`  - каталог установки Kibana

`kibana_server_port` - порт, на котором будет запущена Kibana

`kibana_server_host` - интерфейс, на котором будет запущена Kibana

`kibana_server_name` - отображаемое имя Kibana сервера

`kibana_elasticsearch_hosts` - URL, на котором доступен Elasticsearch