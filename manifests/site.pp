node default {
  $roles = split($::roles, '\s*,\s*')
  notify { 'test message': message => "Custom fact is ${facts['roles']} message", }
  if 'developer' in $roles {
    notify { 'inside if statement ' : message => "Developer in roles" }
  }
  if 'test' in $roles {
    notify { 'inside statement 2' : message => "Test in roles" }
  }
}