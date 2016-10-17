#!/usr/bin/env python

try:
    from urllib.request import Request, urlopen
    from urllib.parse import urlparse, urlencode
except ImportError:
    # py2
    from urllib2 import Request, urlopen
    from urllib import urlencode
    from urlparse import urlparse

import json
from datetime import datetime

# slack
from slacker import Slacker
from os.path import expanduser
import logging
logging.basicConfig(filename="/tmp/parsely_cache_clear.log", filemode='a', level=logging.DEBUG)

# https://api.parsely.com/v2/analytics/posts
# apikey=thedailybeast.com
# secret=Uv0kmNLS1N59fWZE2JCH1Gq7YGo5aGl9OezwJwHkJvk
# limit=50

PARSELY_API="https://api.parsely.com/v2/analytics"
PARSELY_APIKEY="thedailybeast.com"
PARSELY_SHARED="Uv0kmNLS1N59fWZE2JCH1Gq7YGo5aGl9OezwJwHkJvk"
PARSELY_LIMIT="400"

params = urlencode( { 'apikey': PARSELY_APIKEY, 'secret': PARSELY_SHARED, 'limit': PARSELY_LIMIT } )
request_url = Request("https://api.parsely.com/v2/analytics/posts?{0}".format(params))

startTime = datetime.now()
logging.info( "task started at {0}".format( str(datetime.now()) ) )
logging.info( "fetching urls from parsely" )
response = urlopen( request_url )
# TODO: handle URLError

jsondata = response.read().decode('utf-8')
parsed_json = json.loads( jsondata )

def strip_urls(urls):
        return [ url.rsplit('.',1)[0] for url in urls ]

def url_plus_mobile(urls):
        return [ url + suffix for url in strip_urls(urls) for suffix in [ '.html', '.mobile.html' ] ]

parsely_urls = [ e['url'] for e in parsed_json['data'] if ('/articles' in e['url']) ]

logging.info( "starting work on {0} urls from parsely".format( len(parsely_urls) ) )

for article in url_plus_mobile(parsely_urls):
    parsed_url = urlparse(article)
    invalidation_request = Request("http://localhost/dispatcher/invalidate.cache", 
            headers = {
                'Host': 'www.thedailybeast.com',
                'CQ-Action' : 'DELETE',
                'Content-Length' : '0',
                'Content-Type'   : 'application/octet-stream',
                'CQ-Handle': parsed_url.path,
                'CQ-Path':   parsed_url.path
                }) # end req=Request
    logging.info( "[invalidating] {0}".format( parsed_url.path ) )
    urlopen( invalidation_request )
    precache_request = Request("http://localhost{0}".format( parsed_url.path ),
            headers = { 'Host': 'www.thedailybeast.com', }) # end req=Request
    logging.info( "  [precaching] {0}".format( parsed_url.path ) )
    urlopen( precache_request )

logging.info("task completed in {0}".format( datetime.now() - startTime ))

slack = Slacker('xoxb-3644722850-rxdmZvgFh4W7RCBaANv0LVer')
slack.chat.post_message('#logs', "[parsely_cache_clear] cleared {0} urls from cache in {1}".format( len(parsely_urls), datetime.now() - startTime ) )

