#!/usr/bin/env python

"""
Description:
In the instances where a memorypool is greater than 85% a restart of services is required.
This script provides a means to do that based on triggers in Zabbix.

Requirements:
Python 2.7+
Python Mechanize module

Log examples:
09.12.2011 19:50:18 *MARK * webapp-CRX Launchpad Webapp: Start web application
09.12.2011 21:16:01 *MARK * webapp-CRX Launchpad Webapp: Stop web application

Expected input:
script.py <url> <log> <user> <pass>
crx_restart.py https://author02-uat.ec2.thedailybeast.com/admin/webapps /opt/cq5/author/crx-quickstart/logs/server.log admin admin

Sample webapp_info dict:
{'log_state': 'Start', 'string_time': '16.12.2011 17:30:05',
'datetime': datetime.datetime(2011, 12, 16, 17, 30),
'logline': '16.12.2011 17:30:05 *MARK * webapp-CRX Launchpad Webapp: Start web application\n'}

Problems:
In testing it was discovered that upon restarting the sling Launchpad process more than
a few times that memory would build up significantly. So much so that the application
became unresponsive and the VM would complain about needing to be terminated.

Starting Command:
java -XX:MaxPermSize=128m -Xmx1024M -jar cq5-author-4502.jar

JVM Message:

Notable log messages:
16.12.2011 20:16:37 *MARK * webapp-CRX Launchpad Webapp: Stop web application
16.12.2011 20:16:37 *MARK * webapp-CRX Launchpad Webapp: Stop servlet 'sling'
16.12.2011 20:16:38 *MARK * webapp-CRX Launchpad Webapp: Stop filter 'CRXLaunchpadLicenseFilter'
16.12.2011 20:16:39 *WARN * webapp-CRX Launchpad Webapp: Thread still active after stop request: 'Apache Sling Job Background Loader'
16.12.2011 20:16:39 *WARN * webapp-CRX Launchpad Webapp: Thread still active after stop request: 'Thread-88'
"""

import re
import sys
import time
import logging
import datetime
import argparse
import mechanize
import cookielib

from logging.handlers import SysLogHandler

br = mechanize.Browser()
cj = cookielib.LWPCookieJar()

start_datetime = datetime.datetime.now()
start_stringtime = start_datetime.strftime("%d.%m.%Y %H:%M:%S")

br.set_handle_equiv(True)
br.set_handle_redirect(True)
br.set_handle_referer(True)
br.set_handle_robots(False)
br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

parser = argparse.ArgumentParser(description='CRX Servlet Controller for Launchpad')
parser.add_argument('url', help='Provide the URL for CRX admin')
parser.add_argument('serverlog', help='Server log file location, example: /opt/cq5/publish/crx-quickstart/logs/server.log')
parser.add_argument('username', help='Admin name')
parser.add_argument('password', help='Give the password for the admin account')
args = parser.parse_args()


def servletController(url, username, password, action):
    """ Using mechanize to control our form """
    br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]
    br.set_cookiejar(cj)
    br.add_password(url, username, password)
    try:
        br.open(url)
    except Exception, e:
        logger.exception("CQ5 is really broke, check it out: %s" % e)

    if action == "stop":
        # Stop the CRX Launchpad Webapp
        br.select_form(nr=1) # nr=1 is the 2nd form element on the page
        stopInstance = br.click(type="submit", nr=0)
        br.open(stopInstance)
    elif action == "start":
        # Start the CRX Launchpad Webapp
        br.select_form(nr=0) # nr=0 is the 1st form element on the page
        startInstance = br.click(type="submit", nr=0)
        br.open(startInstance)


def logCheck():
    """ Return log values based on mode requested """
    try:
        webapp_log = open(args.serverlog, 'r').readlines()
        webapp_log.reverse()
    except Exception, e:
        logger.exception(e)

    while webapp_log:
        webapp_log_entry = webapp_log.pop()
        # 22.12.2011 20:57:53 *ERROR* webapp-CRX Launchpad Webapp: Servlet 'sling' threw exception
        match = re.search('(.*)\s\*MARK\s\*\swebapp-CRX\sLaunchpad\sWebapp:\s(.*)\sweb\sapplication.*', webapp_log_entry)
        exception = re.search('(.*)\s*ERROR*\swebapp-CRX\sLaunchpad\sWebapp:\s(.*)\s(threw\sexception|Root\scause).*', webapp_log_entry)
        if match:
            webapp_info = {'string_time': match.group(1), 'log_state': match.group(2), 'logline': webapp_log_entry}
            webapp_info['datetime'] = datetime.datetime(*time.strptime(webapp_info['string_time'], "%d.%m.%Y %H:%M:%S")[0:5])
        elif exception:
            webapp_info = {'string_time': exception.group(1), 'log_state': "exception", 'logline': webapp_log_entry}
            webapp_info['datetime'] = datetime.datetime(*time.strptime(webapp_info['string_time'], "%d.%m.%Y %H:%M:%S")[0:5])

    return webapp_info

if __name__ == '__main__':
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    syslog = SysLogHandler(address='/dev/log')
    formatter = logging.Formatter('%(name)s: %(levelname)s %(message)s')
    syslog.setFormatter(formatter)
    logger.addHandler(syslog)

    # This is where some loose validation is done on user input
    if re.search('http(.|)\:.*', args.url):
        pass
    else:
        sys.exit(logger.error("A valid url that begins with \"http(s):\" needs to be provided"))

    webapp_info = logCheck()

    if webapp_info['log_state'].lower() == "stop":
        servletController(args.url, args.username, args.password, "start")
        sys.exit("Service is being started")
    elif webapp_info['log_state'].lower() == "exception":
        logger.warning("We have run into a problem\n\n%s" % webapp_info['logline'])
    else:
        servletController(args.url, args.username, args.password, "stop")
        webapp_info = logCheck()
        while logCheck():
            logger.info("Waiting for the service to be in a stopped state")
            if webapp_info['log_state'].lower() == "stop":
                logger.info("Service has been stopped")
                break
        servletController(args.url, args.username, args.password, "start")
        logger.info("Starting the service")
        webapp_info = logCheck()
        while logCheck():
            if webapp_info['log_state'].lower() == "start":
                logger.info("Service has been started")
                break

