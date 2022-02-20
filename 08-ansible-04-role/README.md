Скачиваем необходимые роли
```bash
# ansible-galaxy role  install -r requirements.yml -p roles
```

Запускаем плейбук и устанавливаем ElasticSearch+Kibana+Filebeat на соответствующие хосты
```bash
# ansible-playbook -i inventory/hosts.yml playbook.yml
```

Установка только Elasticsearch
```bash
# ansible-playbook -i inventory/hosts.yml playbook.yml --tags "elastic"
```

Установка только Kibana
```bash
# ansible-playbook -i inventory/hosts.yml playbook.yml --tags "kibana"
```

Установка только Filebeat
```bash
# ansible-playbook -i inventory/hosts.yml playbook.yml --tags "filebeat"
```