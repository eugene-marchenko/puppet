# = Class: roles::params
#
# This class manages default parameters. It does the heavy lifting
# to determine environment specific parameters for other hosts to include.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# include roles::params
#
# $my_var = $roles::params::some_var
#
class roles::params {

  if $::roles {
    $roles = split($::roles, '\s*,\s*')
  } else {
    $roles = []
  }

}
