# Class: roles::cq5::jvm
#
# This class installs cq5::jvm resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::cq5::jvm
#
# class { 'roles::cq5::jvm' : }
#
#
class roles::cq5::jvm() {

  include java

  if $::java_version {
    $java_version = $::java_version
  } else {
    $java_version = 'latest'
  }

  Package <| name == 'openjdk-6-jre' |> { ensure  => $java_version }
  Package <| name == 'openjdk-6-jdk' |> { ensure  => $java_version }
  Package <| name == 'openjdk-6-jre-headless' |> { ensure  => $java_version }
  Package <| name == 'openjdk-6-jre-lib' |> { ensure  => $java_version }

}
