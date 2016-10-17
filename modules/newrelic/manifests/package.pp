# Define: newrelic::package
#
define newrelic::package(
  $packages,
  $defaults,
) {

  include stdlib
  include users

  create_resources(package, $packages, $defaults)
}
