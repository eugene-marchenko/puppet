# class install
node 'class-route53-install-ipaddress' {
  class { 'route53::install' : }
}

node 'class-route53-install-ec2' {
  include route53::install
}

# class enable
node 'class-route53-service-true' {
  class { 'route53::service' : enable => true }
}

node 'class-route53-service-false' {
  class { 'route53::service' : enable => false}
}

node 'class-route53-service-invalid-enable' {
  class { 'route53::service' : enable => yes }
}

# class run
node 'class-route53-service-run-true' {
  class { 'route53::service::run' : run => true }
}

node 'class-route53-service-run-false' {
  class { 'route53::service::run' : run => false }
}

node 'class-route53-service-run-invalid' {
  class { 'route53::service::run' : run => yes }
}

# class init
node 'class-route53-init-ec2' {
  include route53
}

node 'class-route53-init-ip' {
  class { 'route53' : }
}

node 'class-route53-init-no-route53-keys' {
  include route53
}

node 'class-route53-init-no-run' {
  class { 'route53' : run => false }
}

node 'class-route53-init-no-enable' {
  class { 'route53' : enable => false }
}
