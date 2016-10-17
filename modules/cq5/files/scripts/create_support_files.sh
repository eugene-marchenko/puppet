#!/bin/bash -ex

create_support_files() {
    dir=$1
    cd $dir || exit 1
    java -version 2> infoJavaVersion.log
    find . -name "crx*.jar" > infoCrxVersion.log
    ls -alR > infoFileList.log
    zip -r clusterNode-`hostname`-`date +'%y-%m-%d-%H:%M:%S'`.zip . -i */repository.xml */workspace.xml */*.log */*.log.* *.log */logs/*
    rm info*
}

if [ -d /opt/cq5/author ]; then
    time create_support_files /opt/cq5/author
    elif [ -d /opt/cq5/publish ]; then
        time create_support_files /opt/cq5/publish
    else echo "Host `hostname` neither and author or a publisher" && exit 1
fi
