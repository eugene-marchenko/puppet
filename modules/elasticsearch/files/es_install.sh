#!/bin/sh
if [ -d "/usr/local/share/elasticsearch" ]; then
    echo "We've already installed ElasticSearch"
    exit
fi

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.2.tar.gz -O /tmp/elasticsearch.tar.gz
cd /tmp/
tar zxf elasticsearch.tar.gz
sudo mv elasticsearch-* /usr/local/share/elasticsearch

curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz
sudo mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/
rm -Rf *servicewrapper*
sudo /usr/local/share/elasticsearch/bin/service/elasticsearch install
sudo ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch

sudo service elasticsearch start

# Update ES with our index template
curl -XPUT 'http://localhost:9200/_template/template_logstash/' -d @/tmp/logstash-template.json

# Install management plugins for elasticsearch
/usr/local/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
/usr/local/share/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic
