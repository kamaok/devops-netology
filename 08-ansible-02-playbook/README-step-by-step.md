5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```bash
# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```bash
# ansible-playbook -i inventory/prod.yml site.yml --diff
PLAY [Install Java] ****************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]

TASK [Set facts for Java 11 vars] **************************************************************************************************************
ok: [localhost]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************
diff skipped: source file size is greater than 104448
changed: [localhost]

TASK [Ensure installation dir exists] **********************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.14",
-    "state": "absent"
+    "state": "directory"
 }

changed: [localhost]

TASK [Extract java in the installation directory] **********************************************************************************************
changed: [localhost]

TASK [Export environment variables] ************************************************************************************************************
--- before
+++ after: /home/eugene/.ansible/tmp/ansible-local-18593jydyb3jh/tmpt973g0r0/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.14
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [localhost]

PLAY [Install Elasticsearch] *******************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************
changed: [localhost]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/elastic/7.10.1",
-    "state": "absent"
+    "state": "directory"
 }

changed: [localhost]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************
changed: [localhost]

TASK [Set environment Elastic] *****************************************************************************************************************
--- before
+++ after: /home/eugene/.ansible/tmp/ansible-local-18593jydyb3jh/tmp9vgivm17/elk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export ES_HOME=/opt/elastic/7.10.1
+export PATH=$PATH:$ES_HOME/bin
\ No newline at end of file

changed: [localhost]

PLAY [Install Kibana] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************
changed: [localhost]

TASK [Create directrory for Kibana] ************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/kibana/7.10.1",
-    "state": "absent"
+    "state": "directory"
 }

changed: [localhost]

TASK [Extract Kibana in the installation directory] ********************************************************************************************
changed: [localhost]

TASK [Create kibana configuration file] ********************************************************************************************************
--- before: /opt/kibana/7.10.1/config/kibana.yml
+++ after: /home/eugene/.ansible/tmp/ansible-local-18593jydyb3jh/tmp05o8_c65/kibana.yml.j2
@@ -1,107 +1,17 @@
 # Kibana is served by a back end server. This setting specifies the port to use.
-#server.port: 5601
+server.port: 5601

 # Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
 # The default is 'localhost', which usually means remote machines will not be able to connect.
 # To allow connections from remote users, set this parameter to a non-loopback address.
-#server.host: "localhost"
-
-# Enables you to specify a path to mount Kibana at if you are running behind a proxy.
-# Use the `server.rewriteBasePath` setting to tell Kibana if it should remove the basePath
-# from requests it receives, and to prevent a deprecation warning at startup.
-# This setting cannot end in a slash.
-#server.basePath: ""
-
-# Specifies whether Kibana should rewrite requests that are prefixed with
-# `server.basePath` or require that they are rewritten by your reverse proxy.
-# This setting was effectively always `false` before Kibana 6.3 and will
-# default to `true` starting in Kibana 7.0.
-#server.rewriteBasePath: false
-
-# The maximum payload size in bytes for incoming server requests.
-#server.maxPayloadBytes: 1048576
+server.host: 0.0.0.0

 # The Kibana server's name.  This is used for display purposes.
-#server.name: "your-hostname"
+server.name: "My Kibana"

 # The URLs of the Elasticsearch instances to use for all your queries.
-#elasticsearch.hosts: ["http://localhost:9200"]
+elasticsearch.hosts: ["http://localhost:9200"]

 # Kibana uses an index in Elasticsearch to store saved searches, visualizations and
 # dashboards. Kibana creates a new index if the index doesn't already exist.
-#kibana.index: ".kibana"
-
-# The default application to load.
-#kibana.defaultAppId: "home"
-
-# If your Elasticsearch is protected with basic authentication, these settings provide
-# the username and password that the Kibana server uses to perform maintenance on the Kibana
-# index at startup. Your Kibana users still need to authenticate with Elasticsearch, which
-# is proxied through the Kibana server.
-#elasticsearch.username: "kibana_system"
-#elasticsearch.password: "pass"
-
-# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
-# These settings enable SSL for outgoing requests from the Kibana server to the browser.
-#server.ssl.enabled: false
-#server.ssl.certificate: /path/to/your/server.crt
-#server.ssl.key: /path/to/your/server.key
-
-# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
-# These files are used to verify the identity of Kibana to Elasticsearch and are required when
-# xpack.security.http.ssl.client_authentication in Elasticsearch is set to required.
-#elasticsearch.ssl.certificate: /path/to/your/client.crt
-#elasticsearch.ssl.key: /path/to/your/client.key
-
-# Optional setting that enables you to specify a path to the PEM file for the certificate
-# authority for your Elasticsearch instance.
-#elasticsearch.ssl.certificateAuthorities: [ "/path/to/your/CA.pem" ]
-
-# To disregard the validity of SSL certificates, change this setting's value to 'none'.
-#elasticsearch.ssl.verificationMode: full
-
-# Time in milliseconds to wait for Elasticsearch to respond to pings. Defaults to the value of
-# the elasticsearch.requestTimeout setting.
-#elasticsearch.pingTimeout: 1500
-
-# Time in milliseconds to wait for responses from the back end or Elasticsearch. This value
-# must be a positive integer.
-#elasticsearch.requestTimeout: 30000
-
-# List of Kibana client-side headers to send to Elasticsearch. To send *no* client-side
-# headers, set this value to [] (an empty list).
-#elasticsearch.requestHeadersWhitelist: [ authorization ]
-
-# Header names and values that are sent to Elasticsearch. Any custom headers cannot be overwritten
-# by client-side headers, regardless of the elasticsearch.requestHeadersWhitelist configuration.
-#elasticsearch.customHeaders: {}
-
-# Time in milliseconds for Elasticsearch to wait for responses from shards. Set to 0 to disable.
-#elasticsearch.shardTimeout: 30000
-
-# Logs queries sent to Elasticsearch. Requires logging.verbose set to true.
-#elasticsearch.logQueries: false
-
-# Specifies the path where Kibana creates the process ID file.
-#pid.file: /var/run/kibana.pid
-
-# Enables you to specify a file where Kibana stores log output.
-#logging.dest: stdout
-
-# Set the value of this setting to true to suppress all logging output.
-#logging.silent: false
-
-# Set the value of this setting to true to suppress all logging output other than error messages.
-#logging.quiet: false
-
-# Set the value of this setting to true to log all events, including system usage information
-# and all requests.
-#logging.verbose: false
-
-# Set the interval in milliseconds to sample system and process performance
-# metrics. Minimum is 100ms. Defaults to 5000.
-#ops.interval: 5000
-
-# Specifies locale to be used for all localizable strings, dates and number formats.
-# Supported languages are the following: English - en , by default , Chinese - zh-CN .
-#i18n.locale: "en"
+kibana.index: ".kibana"

changed: [localhost]

TASK [Set environment Elastic] *****************************************************************************************************************
--- before
+++ after: /home/eugene/.ansible/tmp/ansible-local-18593jydyb3jh/tmphbog3p8p/kibana.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export KIBANA_HOME=/opt/kibana/7.10.1
+export PATH=$PATH:$KIBANA_HOME/bin
\ No newline at end of file

changed: [localhost]

PLAY RECAP *************************************************************************************************************************************
localhost                  : ok=17   changed=13   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```





```bash
# echo $JAVA_HOME
/opt/jdk/11.0.14
```
```bash
# echo $ES_HOME
/opt/elastic/7.10.1
```
```bash
# echo $KIBANA_HOME
/opt/kibana/7.10.1
```
```bash
# java -version
java version "11.0.14" 2022-01-18 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.14+8-LTS-263)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.14+8-LTS-263, mixed mode)
```
```bash
# kibana --version
7.10.1
```

```bash
cat /opt/kibana/7.10.1/config/kibana.yml
# Kibana is served by a back end server. This setting specifies the port to use.
server.port: 5601

# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
server.host: 0.0.0.0

# The Kibana server's name.  This is used for display purposes.
server.name: "My Kibana"

# The URLs of the Elasticsearch instances to use for all your queries.
elasticsearch.hosts: ["http://localhost:9200"]

# Kibana uses an index in Elasticsearch to store saved searches, visualizations and
# dashboards. Kibana creates a new index if the index doesn't already exist.
kibana.index: ".kibana"
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.


```bash
# ansible-playbook -i inventory/prod.yml site.yml --diff


PLAY [Install Java] ****************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]

TASK [Set facts for Java 11 vars] **************************************************************************************************************
ok: [localhost]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************
ok: [localhost]

TASK [Ensure installation dir exists] **********************************************************************************************************
ok: [localhost]

TASK [Extract java in the installation directory] **********************************************************************************************
skipping: [localhost]

TASK [Export environment variables] ************************************************************************************************************
ok: [localhost]

PLAY [Install Elasticsearch] *******************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************
ok: [localhost]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************
ok: [localhost]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************
skipping: [localhost]

TASK [Set environment Elastic] *****************************************************************************************************************
ok: [localhost]

PLAY [Install Kibana] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************
ok: [localhost]

TASK [Create directrory for Kibana] ************************************************************************************************************
ok: [localhost]

TASK [Extract Kibana in the installation directory] ********************************************************************************************
skipping: [localhost]

TASK [Create kibana configuration file] ********************************************************************************************************
ok: [localhost]

TASK [Set environment Elastic] *****************************************************************************************************************
ok: [localhost]

PLAY RECAP *************************************************************************************************************************************
localhost                  : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```
