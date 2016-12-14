node default {

  include base

  if 'nodeserver' in $facts['roles'] {
    include nodeserver
  }

}