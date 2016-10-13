# = Class: logstash::shipper
#
# Description of logstash::shipper
#
# == Parameters:
#
# $param::   description of parameter. default value if any.
#
# == Actions:
#
# Describe what this class does. What gets configured and how.
#
# == Requires:
#
# Requirements. This could be packages that should be made available.
#
# == Sample Usage:
#
# == Todo:
#
# * Update documentation
#
class logstash::shipper (
  # make sure the logstash::config class is declared before logstash::shipper
  Class['logstash::config'] -> Class['logstash::shipper']

  file {'/etc/logstash/conf.d/shipper-input.conf':
    ensure   => 'file',
    group    => '0',
    mode     => '0644',
    owner    => '0',
    content  => $shipper-input
  }

  User  <| tag == 'logstash' |>
  Group <| tag == 'logstash' |>

}

