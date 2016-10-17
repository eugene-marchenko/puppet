# Define: newrelic::service
#
class newrelic::service(
  $installed = true,
  $services  = hiera('newrelic_services'),
) {

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
