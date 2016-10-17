# Class: apache::vhost::default
#
# This class creates a virtual resource for the default virtualhost for other
# classes to include and realize.
#
# == Parameters:
#
# == Required:
#
# == Optional:
#
# == Requires:
# stdlib, apache
#
# == Sample Usage:
# # Simple example:
# include apache::vhost::default
# realize Apache::Vhost[default]
#
# # Collection example:
# include apache::vhost::default
# Apache::Vhost <| title == 'default' |> {
#   enable  => false,
# }
#
class apache::vhost::default(
) inherits apache::params {

  # Create virtual resource for the default virtualhost so other classes can
  # realize it which avoids the duplicate definition problem.
  @apache::vhost { 'default' :
    docroot => '/var/www',
    port    => '80',
  }
}
