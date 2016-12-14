class site::roles::base() {
  notify { 'test message' : message => "Custom fact is ${facts['roles']} message", }
  if 'developer' in $facts['roles'] {
    notify { 'inside if statement ' : message => "Developer in roles", }
  }
  if 'run' in $facts['roles'] {
    notify { 'inside statement 2' : message => "Test in roles", }
  }

  each($facts['system_uptime']) |$type, $value| {
  notice("system has been up ${value} ${type}")
}

}