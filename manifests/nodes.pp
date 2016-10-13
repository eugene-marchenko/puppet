node default {
  notify { "test message is: ${::fqdn}" :}
}
