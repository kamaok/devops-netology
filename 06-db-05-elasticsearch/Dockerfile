FROM centos:7

ARG ES_VERSION

ENV ES_VERSION=${ES_VERSION}

WORKDIR /tmp

RUN yum update -y && \
    yum install wget perl-Digest-SHA -y && \
    yum clean all -y && \
    wget -q -O elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    wget -q -O elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz.sha512 https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz -C /opt/ && \
    rm -rf /tmp/elasticsearch-${ES_VERSION}-* && \
    groupadd -g 1000 elasticsearch && \
    adduser --uid 1000 --gid 1000 --home /opt/elasticsearch-${ES_VERSION} elasticsearch && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch-${ES_VERSION} && \
    mkdir /var/lib/elasticsearch && \
    chown -R elasticsearch:elasticsearch /var/lib/elasticsearch

EXPOSE 9200 9300

WORKDIR /opt/elasticsearch-${ES_VERSION}

USER elasticsearch

ENTRYPOINT ["./bin/elasticsearch"]
