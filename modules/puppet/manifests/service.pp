define puppet::service(
  $services,
) {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'puppet-service' }

  create_resources(service, $services, $defaults)

}
