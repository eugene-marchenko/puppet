notify { 'test message': message => "Custom fact is ${facts['roles']} message", }
if 'developer' in $facts['roles'] {
  notify { 'inside if statement ': message => "Developer in roles"}
}
