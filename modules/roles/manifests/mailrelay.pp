# Class: roles::mailrelay
#
# This class installs mailrelay resources
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
# include roles::mailrelay
#
# class { 'roles::mailrelay' : }
#
#
class roles::mailrelay() {

  include roles::base

  if ! $::postfix_chroot { fail('Please set the postfix_chroot fact') }
  if ! $::sasl_relay_user_pass { fail('Please set the sasl_relay_user_pass fact') }
  if ! $::mpp_relay_user_pass { fail('Please set the mpp_relay_user_pass fact') }

  include sasl
  sasl::user { 'smtp-relay':
    password  => $::sasl_relay_user_pass,
    mx_domain => 'mxr.thedailybeast.com',
  }

  sasl::user { 'mpp-relay':
    password  => $::mpp_relay_user_pass,
    mx_domain => 'mxr.thedailybeast.com',
  }

  sasl::user { 'snailboy':
    password  => $::postfix_snailboy_user_pass,
    mx_domain => 'mxr.thedailybeast.com',
  }

  Class[roles::base]
    -> Class[sasl]
    -> Sasl::User['smtp-relay']
    -> Sasl::User['mpp-relay']
    -> Sasl::User['snailboy']
}
