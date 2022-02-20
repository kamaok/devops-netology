Скачиваем необходимые роли
```bash
# ansible-galaxy role  install -r requirements.yml -p roles
Starting galaxy role install process
- extracting elastic to /home/eugene/Work/Projects/Netology/ansible-tasks-repo/roles/elastic
- elastic (2.1.4) was installed successfully
- extracting kibana-role to /home/eugene/Work/Projects/Netology/ansible-tasks-repo/roles/kibana-role
- kibana-role (0.0.1) was installed successfully
- extracting filebeat-role to /home/eugene/Work/Projects/Netology/ansible-tasks-repo/roles/filebeat-role
- filebeat-role (0.0.1) was installed successfully
```
```bash
# tree -L 2
.
├── inventory
│   └── hosts.yml
├── playbook.yml
├── README.md
├── README-step-by-step.md
├── requirements.yml
└── roles
    ├── elastic
    ├── filebeat-role
    └── kibana-role
```



Проверяем доступ к серверам с ansible-сервера
```bash
# ansible -u eugene -i inventory/hosts.yml -m ping all
The authenticity of host '51.250.13.180 (51.250.13.180)' can't be established.
ECDSA key fingerprint is SHA256:K4OxQHPXR1XgyiOp7wBaBU7vn3tNZpPjYfQ+sM1T3Nc.
Are you sure you want to continue connecting (yes/no)? The authenticity of host '51.250.5.174 (51.250.5.174)' can't be established.
ECDSA key fingerprint is SHA256:UcV7ZozXhUveXgAovJsU/3iNVFvV40fcMsDOOUduKJc.
Are you sure you want to continue connecting (yes/no)? The authenticity of host '51.250.11.88 (51.250.11.88)' can't be established.
ECDSA key fingerprint is SHA256:A7nLAlDUJ1UQ25qQ4UW8eNguC26fBG2bS2H1M0M7b/c.
Are you sure you want to continue connecting (yes/no)? yes
yes
yes

filebeat-instance | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
elastic-instance | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
kibana-instance | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```


Запускаем плейбук и устанавливаем ElasticSearch+Kibana+Filebeat на соответствующие хосты
```bash
# ansible-playbook -i inventory/hosts.yml playbook.yml

PLAY [elasticsearch] ***************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [elastic-instance]

TASK [elastic : Fail if unsupported system detected] *******************************************************************************************
skipping: [elastic-instance]

TASK [elastic : Check files directory exists] **************************************************************************************************
changed: [elastic-instance -> localhost]

TASK [elastic : include_tasks] *****************************************************************************************************************
included: /home/eugene/Work/Projects/Netology/ansible-tasks-repo/roles/elastic/tasks/download_yum.yml for elastic-instance

TASK [elastic : Download Elasticsearch's rpm] **************************************************************************************************
changed: [elastic-instance -> localhost]

TASK [elastic : Copy Elasticsearch to managed node] ********************************************************************************************
changed: [elastic-instance]

TASK [elastic : include_tasks] *****************************************************************************************************************
included: /home/eugene/Work/Projects/Netology/ansible-tasks-repo/roles/elastic/tasks/install_yum.yml for elastic-instance

TASK [elastic : Install Elasticsearch] *********************************************************************************************************
changed: [elastic-instance]

TASK [elastic : Configure Elasticsearch] *******************************************************************************************************
changed: [elastic-instance]

RUNNING HANDLER [elastic : restart Elasticsearch] **********************************************************************************************
changed: [elastic-instance]

PLAY [kibana] **********************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [kibana-instance]

TASK [kibana-role : Fail if unsupported system detected] ***************************************************************************************
skipping: [kibana-instance]

TASK [kibana-role : include_tasks] *************************************************************************************************************
included: /home/eugene/Work/Projects/Netology/ansible-tasks-repo/roles/kibana-role/tasks/download_and_install.yml for kibana-instance

TASK [kibana-role : Download Kibana's rpm] *****************************************************************************************************
changed: [kibana-instance]

TASK [kibana-role : Install Kibana] ************************************************************************************************************
changed: [kibana-instance]

TASK [kibana-role : Configure Kibana] **********************************************************************************************************
changed: [kibana-instance]

RUNNING HANDLER [kibana-role : restart Kibana] *************************************************************************************************
changed: [kibana-instance]

PLAY [filebeat] ********************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [filebeat-instance]

TASK [filebeat-role : Fail if unsupported system detected] *************************************************************************************
skipping: [filebeat-instance]

TASK [filebeat-role : include_tasks] ***********************************************************************************************************
included: /home/eugene/Work/Projects/Netology/ansible-tasks-repo/roles/filebeat-role/tasks/download_and_install.yml for filebeat-instance

TASK [filebeat-role : Download Filebeat's rpm] *************************************************************************************************
changed: [filebeat-instance]

TASK [filebeat-role : Install Filebeat] ********************************************************************************************************
changed: [filebeat-instance]

TASK [filebeat-role : Configure Filebeat] ******************************************************************************************************
changed: [filebeat-instance]

TASK [filebeat-role : Set filebeat to collect system logs] *************************************************************************************
changed: [filebeat-instance]

RUNNING HANDLER [filebeat-role : restart Filebeat] *********************************************************************************************
changed: [filebeat-instance]
```

Проверяем запущенный Elasticsearch

```bash
# ssh eugene@51.250.13.180
```
```bash
# cat /etc/elasticsearch/elasticsearch.yml
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
discovery.seed_hosts: ["10.128.0.25"]
node.name: node-a
cluster.initial_master_nodes:
   - node-a
```
```bash
# systemctl status elasticsearch
● elasticsearch.service - Elasticsearch
   Loaded: loaded (/usr/lib/systemd/system/elasticsearch.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-02-19 22:40:49 UTC; 13s ago
     Docs: https://www.elastic.co
 Main PID: 8535 (java)
   CGroup: /system.slice/elasticsearch.service
           ├─8535 /usr/share/elasticsearch/jdk/bin/java -Xshare:auto -Des.networkaddress.cache.ttl=60 -Des.networkaddress.cache.negative.ttl=...
           └─8732 /usr/share/elasticsearch/modules/x-pack-ml/platform/linux-x86_64/bin/controller

Feb 19 22:40:24 elastic-instance.ru-central1.internal systemd[1]: Starting Elasticsearch...
Feb 19 22:40:49 elastic-instance.ru-central1.internal systemd[1]: Started Elasticsearch.
```

Проверяем запущенную Kibana

```bash
# ssh eugene@51.250.5.174
```
```bash
# cat /etc/kibana/kibana.yml
server.port: 5601
server.host: 0.0.0.0
server.name: "My Kibana"

elasticsearch.hosts: ["http://10.128.0.25:9200"]

kibana.index: ".kibana"
```

```bash
# systemctl status kibana
● kibana.service - Kibana
   Loaded: loaded (/etc/systemd/system/kibana.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-02-19 22:48:11 UTC; 10s ago
     Docs: https://www.elastic.co
 Main PID: 8536 (node)
   CGroup: /system.slice/kibana.service
           └─8536 /usr/share/kibana/bin/../node/bin/node /usr/share/kibana/bin/../src/cli/dist --logging.dest="/var/log/kibana/kibana.log" --...

Feb 19 22:48:11 kibana-instance.ru-central1.internal systemd[1]: Started Kibana.
```

Проверяем запущенный Filebeat

```bash
ssh eugene@51.250.11.88
```
```bash
# cat /etc/filebeat/filebeat.yml
output.elasticsearch:
  hosts: ["http://10.128.0.25:9200"]
setup.kibana:
    host: ["http://10.128.0.6:5601"]
filebeat.config.modules.path: ${path.config}/modules.d/*.yml
```
```bash
# ps aux | grep [f]ilebeat
root      8493  5.1  4.8 1098236 189912 ?      Ssl  22:54   0:01 /usr/share/filebeat/bin/filebeat --environment systemd -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat --path.logs /var/log/filebeat
```



[Просмотр логов в Kibana](img/kibana.png)