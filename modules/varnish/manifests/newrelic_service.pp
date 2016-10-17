class varnish::newrelic_service(
  $installed = true,
  $services  = hiera('newrelic_service'),
) inherits varnish::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'newrelic-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }
}
