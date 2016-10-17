# Define: newrelic::config
#
define newrelic::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'newrelic-config' }

  create_resources(file, $configs, $defaults)

}
