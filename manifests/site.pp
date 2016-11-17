node default {
  # $roless = split($facts['roles'], '\s*,\s*')
  notify { 'test message': message => "Custom fact is ${facts['roles']} message", }
  if 'developer' in $facts['roles'] {
    notify { 'inside if statement ' : message => "Developer in roles" }
  }
  if 'run' in $facts['roles'] {
    notify { 'inside statement 2' : message => "Test in roles" }
  }
}