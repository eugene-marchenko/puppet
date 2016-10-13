# define motd::register
node 'motd-register' {
  motd::register { 'Apache' : }
  motd::register { 'Nginx' : order => '11' }
  motd::register { 'Devtools help' :
    content => 'Do the following to create a debian package\n',
  }
}

# class motd
node 'class-motd' {
  include motd
}
