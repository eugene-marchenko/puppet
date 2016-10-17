# Class: nginx
#
# Manages nginx.
# Include it to install and run nginx with default settings
#
# Usage:
# include nginx

import 'classes/*.pp'

class nginx {

        include nginx::base

}