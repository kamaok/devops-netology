Проверка плейбука линтером
```bash
# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```

Проверка идемпотентности плейбука
```bash
# ansible-playbook -i inventory/prod/ site.yml --diff

PLAY [Install Elasticsearch] *******************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [elastic-instance]

TASK [Download Elasticsearch's rpm] ************************************************************************************************************
ok: [elastic-instance]

TASK [Install Elasticsearch] *******************************************************************************************************************
ok: [elastic-instance]

TASK [Configure Elasticsearch] *****************************************************************************************************************
ok: [elastic-instance]

PLAY [Install Kibana] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [kibana-instance]

TASK [Download Kibana's rpm] *******************************************************************************************************************
ok: [kibana-instance]

TASK [Install Kibana] **************************************************************************************************************************
ok: [kibana-instance]

TASK [Configure Kibana] ************************************************************************************************************************
ok: [kibana-instance]

PLAY [Install Filebeat] ************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [filebeat-instance]

TASK [Download Filebeat's rpm] *****************************************************************************************************************
ok: [filebeat-instance]

TASK [Install Filebeat] ************************************************************************************************************************
ok: [filebeat-instance]

TASK [Configure Filebeat] **********************************************************************************************************************
ok: [filebeat-instance]

TASK [Set filebeat to collect system logs] *****************************************************************************************************
ok: [filebeat-instance]

PLAY RECAP *************************************************************************************************************************************
elastic-instance           : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
filebeat-instance          : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kibana-instance            : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Проверка доступности ElasticSearch
```bash
# ssh eugene@51.250.9.175 curl -s localhost:9200
{
  "name" : "node-a",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "0ieKDBgJQ7-no9jlwzlqzw",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Проверка доступности Kibana
```bash
# ssh eugene@51.250.8.194 curl -vvv -s localhost:5601
* About to connect() to localhost port 5601 (#0)
*   Trying ::1...
* Connection refused
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 5601 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.29.0
> Host: localhost:5601
> Accept: */*
>
< HTTP/1.1 302 Found
< location: /spaces/enter
< x-content-type-options: nosniff
< referrer-policy: no-referrer-when-downgrade
< kbn-name: My Kibana
< kbn-license-sig: e3691c09283592fdeb21cb4bc401e8cad0c86f4e4b55a78141f8c117169f16e1
< cache-control: private, no-cache, no-store, must-revalidate
< content-length: 0
< Date: Sat, 12 Feb 2022 22:05:36 GMT
< Connection: keep-alive
< Keep-Alive: timeout=120
<
* Connection #0 to host localhost left intact
```

Проверка доступности Filebeat
```bash
# ssh eugene@51.250.5.192 ps aux | grep filebeat
root      8877  0.1  4.6 1032700 181364 ?      Ssl  21:41   0:02 /usr/share/filebeat/bin/filebeat --environment systemd -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat --path.logs /var/log/filebeat
```

[Просмотр логов в Kibana](img/kibana.png)
