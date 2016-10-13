# Class: roles::pvault
#
# This class installs the password vault utility w3pw and necessary vhosts
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::pvault
#
# class { 'roles::pvault' : }
#
#
class roles::pvault() {

  include roles::base
  include roles::backports

  # Validate some necessary facts
  if ! $::w3pw_dbhost {
    fail('w3pw_dbhost fact not set')
  }

  if ! $::w3pw_dbname {
    fail('w3pw_dbname fact not set')
  }
  
  if ! $::w3pw_dbuser {
    fail('w3pw_dbuser fact not set')
  }

  if ! $::w3pw_dbpass {
    fail('w3pw_dbpass fact not set')
  }

  include apache
  include apache::mod::php
  include w3pw

  apache::vhost { 'pvault.ec2.thedailybeast.com_80' :
    port          => '80',
    docroot       => '/usr/share/w3pw',
    servername    => 'pvault.ec2.thedailybeast.com',
    redirect_ssl  => true,
  }

  apache::vhost { 'pvault.ec2.thedailybeast.com_443' :
    port        => '443',
    docroot     => '/usr/share/w3pw',
    servername  => 'pvault.ec2.thedailybeast.com',
    ssl         => true,
  }

  # Anchor the class
  Class[roles::base]  -> Class[apache]

  Class[apache] -> Class[w3pw]
  Class[w3pw]   -> Apache::Vhost['pvault.ec2.thedailybeast.com_80']
  Class[w3pw]   -> Apache::Vhost['pvault.ec2.thedailybeast.com_443']

}
