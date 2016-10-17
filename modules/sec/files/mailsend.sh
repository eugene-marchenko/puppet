#!/bin/sh
(
echo "From: webops@newsweekdailybeast.com"
echo "To: webops@newsweekdailybeast.com"
echo "MIME-Version: 1.0"
echo "Subject: [`hostname`] - $1"
echo ""
echo "$2"
echo ""
) | sendmail -t
