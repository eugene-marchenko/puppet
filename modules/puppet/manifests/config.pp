define puppet::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'puppet-config' }

  create_resources(file, $configs, $defaults)

}
