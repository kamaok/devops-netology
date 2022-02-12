## Установка Elastic,Kibana и Filebeat

### Запуск playbook-а

- для установки Elastic+Kibana+Filebeat
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml
   ```



- для установки только Elastic
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml --tags elastic
   ```

- для установки только Kibana
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml --tags kibana
   ```

- для установки только Filebeat
   ```bash
   # ansible-playbook -i inventory/prod.yml site.yml --tags filebeat
   ```

### Доступные параметры(переменные):

```bash
Elastic/Kibana/Filebeat
```

`elk_stack_version`  - версия Elastic/Kibana/Filebeat


```bash
Kibana
```

`kibana_server_port` - порт, на котором будет запущена Kibana

`kibana_server_host` - интерфейс, на котором будет запущена Kibana

`kibana_server_name` - отображаемое имя Kibana сервера
