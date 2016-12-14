class base() {
  notify { 'test message' : message => "Custom fact is ${facts['roles']} message", }
  if 'nodeserver' in $facts['roles'] {
    include nodeserver
  }
  if 'run' in $facts['roles'] {
    notify { 'inside statement 2' : message => "Test in roles", }
  }

  each($facts['system_uptime']) |$type, $value| {
  notice("system has been up ${value} ${type}")
}

}