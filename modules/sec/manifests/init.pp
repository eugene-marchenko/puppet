# Class: sec
#
# Load Simple Event Correlation

import 'classes/*.pp'
import 'defines/*.pp'

class sec {

    include sec::base
    include sec::initscript

}
