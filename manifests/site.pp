node default {
  $roless = split($facts['roles'], '\s*,\s*')
  notify { 'test message': message => "Custom fact is ${facts['roles']} message", }
  if 'developer' in $roless {
    notify { 'inside if statement ' : message => "Developer in roles" }
  }
  if 'run' in $roless {
    notify { 'inside statement 2' : message => "Test in roles" }
  }
}