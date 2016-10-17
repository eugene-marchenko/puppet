#!/bin/bash

usage() {
    echo ""
    echo "$0 <source-host> <destination-host> <content-path> <source-password> <destination-password> [execute]"
    echo ""
    echo "Example:"
    echo ""
    echo "$0 author01-prod author02-prod /content/dailybeast admin admin"
    echo "$0 author01-prod author02-prod /content/dailybeast admin admin execute"
    echo ""
}

if [ $# -lt 3 ]; then
    usage && exit 1
fi

src_host=$1
dst_host=$2
node_path=$3
src_pass=$4
dst_pass=$5

if [ "$6" == "execute" ]; then
    dry_run=no
else
    dry_run=yes
fi

hostname_regex="^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$"
node_path_regex="^((/content/[a-zA-Z]+)|(/etc/[a-zA-Z]+)|(/var/dam)).*[^/]$"

echo "$src_host" | egrep -q "$hostname_regex"
result=$?

if [ $result -eq 1 ]; then
    echo "Source Host: $src_host is not a valid hostname"
    usage && exit 1
fi

echo "$dst_host" | egrep -q "$hostname_regex"
result=$?

if [ $result -eq 1 ]; then
    echo "Destination Host: $dst_host is not a valid hostname"
    usage && exit 1
fi

echo "$node_path" | egrep -q "$node_path_regex"
result=$?

if [ $result -eq 1 ]; then
    echo "Content path must: start with a / and can only be in /content or /var/dam currently"
    echo "        1. Must start with a /"
    echo "        2. Cannot end with a /"
    echo "        3. Must start with either /content, /etc or /var/dam"
    echo "        4. Cannot be just /content, /etc or /var/dam, must be a subdirectory"
    usage && exit 1
fi

if [ -d /opt/cq5/author ]; then
    path=/opt/cq5/author
elif [ -d /opt/cq5/publish ]; then
    path=/opt/cq5/publish
else echo "Cannot find crx-quickstart directory for filevault utils" && exit 1
fi

if [ -f ${path}/crx-quickstart/opt/filevault/vault-cli-2.3.6/bin/vlt ]; then
    if [ "$dry_run" == no ]; then
        ${path}/crx-quickstart/opt/filevault/vault-cli-2.3.6/bin/vlt rcp -u -n -r http://admin:${src_pass}@${src_host}:8080/crx/-/jcr:root${node_path} http://admin:${dst_pass}@${dst_host}:8080/crx/-/jcr:root${node_path}
    else
        echo "${path}/crx-quickstart/opt/filevault/vault-cli-2.3.6/bin/vlt rcp -u -n -r http://admin:${src_pass}@${src_host}:8080/crx/-/jcr:root${node_path} http://admin:${dst_pass}@${dst_host}:8080/crx/-/jcr:root${node_path}"
    fi
else echo "vlt executable does not exist at ${path}/crx-quickstart/opt/filevault/vault-cli-2.3.6/bin/vlt !"
fi
