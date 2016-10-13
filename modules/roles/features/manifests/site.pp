# class roles::base

node 'class-roles-base' {
  include roles::base
}

# class roles::swap
node 'class-roles-swap' {
  include roles::swap
}

# class roles::logserver
node 'class-roles-logserver' {
  include roles::logserver
}

# class roles::logserver::varnish
node 'class-roles-logserver-varnish' {
  include roles::logserver::varnish
}

# class roles::mailrelay
node 'class-roles-mailrelay' {
  include roles::mailrelay
}

# class roles::varnishserver
node 'class-roles-varnishserver' {
  include roles::varnishserver
}

node 'class-roles-varnishserver-remotelog' {
  include roles::varnishserver::remotelog
}

# class roles::dispatcher
node 'class-roles-dispatcher' {
  include roles::dispatcher
}

# class roles::cq5::jvm
node 'class-roles-cq5-jvm' {
  include roles::cq5::jvm
}

# class roles::cq5::author
node 'class-roles-cq5-author' {
  include roles::cq5::author
}

# class roles::cq5::author::secure
node 'class-roles-cq5-author-secure' {
  include roles::cq5::author::secure
}

# class roles::cq5::author::secure_cache
node 'class-roles-cq5-author-secure_cache' {
  include roles::cq5::author::secure_cache
}

# class roles::cq5::publish
node 'class-roles-cq5-publish' {
  include roles::cq5::publish
}

# class roles::ftpserver
node 'class-roles-ftpserver' {
  include roles::ftpserver
}

# class roles::misc_vhosts
node 'class-roles-misc-vhosts' {
  include roles::misc::vhosts
}

# class roles::solrserver
node 'class-roles-solrserver' {
  include roles::solrserver
}

# class roles::jmeternode
node 'class-roles-jmeternode' {
  include roles::jmeternode
}

# class roles::cron::snapshot::rotator
node 'class-roles-cron-snapshot-rotator' {
  include roles::cron::snapshot::rotator
}

# class roles::cron::secgrp::check
node 'class-roles-cron-secgrp-check' {
  include roles::cron::secgrp::check
}

# class roles::cron::secgrp::export
node 'class-roles-cron-secgrp-export' {
  include roles::cron::secgrp::export
}

# class roles::cron::mysql::backup
node 'class-roles-cron-mysql-backups' {
  include roles::cron::mysql::backups
}

# class roles::cron::analytics
node 'class-roles-cron-analytics' {
  include roles::cron::analytics
}

# class roles::cron::digital
node 'class-roles-cron-digital' {
  include roles::cron::digital
}

# class roles::cronserver
node 'class-roles-cronserver' {
  include roles::cronserver
}

# class roles::pvault
node 'class-roles-pvault' {
  include roles::pvault
}

# class roles::debbuilder
node 'class-roles-debbuilder' {
  include roles::debbuilder
}

# class roles::backports
node 'class-roles-backports' {
  include roles::backports
}

# class roles::rootdomain
node 'class-roles-rootdomain' {
  include roles::rootdomain
}

# class roles::misc_mounts
node 'class-roles-misc-mounts' {
  include roles::misc::mounts
  realize Mount['/opt']
}

node 'class-roles-misc-mounts-from-facts' {
  include roles::misc::mounts
  realize Mount['/d0/data']
}

# class roles::remotelog
node 'class-roles-remotelog' {
  include roles::remotelog
}

# class roles::solr::core::author
node 'class-roles-solr-core-author' {
  include roles::solr::core::author
}

# class roles::solr::core::publish
node 'class-roles-solr-core-publish' {
  include roles::solr::core::publish
}

# class roles::users::developers
node 'class-roles-users-developers' {
  include roles::users::developers
}

# class roles::users::contractors
node 'class-roles-users-contractors' {
  include roles::users::contractors
}

# class roles::stompserver
node 'class-roles-stompserver' {
  include roles::stompserver
}

# class roles::buildserver
node 'class-roles-buildserver' {
  include roles::buildserver
}

# class roles::jenkins
node 'class-roles-jenkins' {
  include roles::jenkins
}

# class roles::qaproxy
node 'class-roles-qaproxy' {
  include roles::qaproxy
}

# class roles::appproxy
node 'class-roles-appproxy' {
  include roles::appproxy
}

# class roles::cron::github
node 'class-roles-cron-github' {
  include roles::cron::github
}

# class roles::grapher
node 'class-roles-grapher' {
  include roles::grapher
}
