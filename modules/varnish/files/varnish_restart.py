#!/usr/bin/env python

import argparse
import os
import re
import sys
import varnish
import logging
import time

class VarnishException(Exception):
    """A Base Exception Class for Varnish Errors"""
    pass

def get_args():
    """Parses command line arguments"""
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--config", default="/etc/varnish/default.vcl",
        help="The files to load into into varnish")
    parser.add_argument("--hostname", default='127.0.0.1:6082',
        help="The hostname and port to connect")
    parser.add_argument("-s", "--secret", default=None,
        help="The secret key for the varnish admin interface")
    parser.add_argument("-l", "--loglevel", default='ERROR',
        choices=['CRITICAL','FATAL','ERROR','WARN','WARNING','INFO','DEBUG'],
        help="The level of logging output you wish to see")
    return parser.parse_args()

def increment():
    i = 0
    while True:
        yield i
        i += 1

def get_configs(opts):
    return opts.manager.run('vcl.list', secret=opts.secret)[0][0]

def make_active(opts):
    """Makes a new config, boot0 to bootN from the same config file on disk"""
    soft_error = re.compile('^.*Already a VCL program named.*$')
    for num in increment():
        cfg = ''.join(['boot',str(num)])
        try:
            opts.manager.run('vcl.load', cfg, opts.config, secret=opts.secret)        
            logging.info("Creating config %s" % cfg)
            opts.manager.run('vcl.use', cfg, secret=opts.secret)
            logging.info("Activating config %s" % cfg)
            break
        except AssertionError as e:
            if soft_error.match(e[0]):
                continue
            else:
                print repr(e)
                raise VarnishException(e)

def prune_inactive(opts):
    cfgs = sorted(get_configs(opts).keys())
    for k in cfgs:
        try:
            opts.manager.run('vcl.discard', k, secret=opts.secret)
        except AssertionError as e:
            # We shouldn't necessarily care if it can't discard the config
            logging.info(e)
            continue
      
def run():
    """
    Logs into varnish admin interface, installs a new config, makes it the active
    one and discards any other configs.
    """
    # Get our parsed arguments
    opts = get_args()
    # The varnish package ships with debug logging enabled...
    varnish.logging.root.setLevel(getattr(logging, opts.loglevel.upper()))
    # Connect to Varnish Adm
    manager = varnish.VarnishManager((opts.hostname,))
    opts.manager = manager
    # Load a new config and make it active
    make_active(opts)
    # Delete the other configs
    prune_inactive(opts)

if __name__ == '__main__':
    run()
