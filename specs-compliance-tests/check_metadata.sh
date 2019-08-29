#!/bin/sh

TEMP_PATH='/tmp/data/'
TEMP_METADATA='sp-metadata.xml'
SSL_ENV='testwithssl.rc'
NOSSL_ENV='testwithnossl.rc'
SOURCE_C="'source "
TOX=" && /usr/bin/tox -e cleanup,sp-metadata-strict,sp-metadata-certs,sp-metadata-extra'"
RECALL_SCRIPT=$SOURCE_C$SSL_ENV$TOX


if [ ! -d "$TEMP_PATH" ]; then
	mkdir $TEMP_PATH
	chmod 777 $TEMP_PATH	
fi

if [ "$#" = 0 ]; then
    echo "Metadata url is missing"
else

if [ "$#" = 1 && "$1" == "--notls" ]; then
    echo "Metadata url is missing"
else
    /usr/bin/wget $1 -O $TEMP_PATH$TEMP_METADATA --no-check-certificate --no-cache --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" 
    /bin/bash -c 'source testwithssl.rc && tox -e cleanup,sp-metadata-strict,sp-metadata-certs,sp-metadata-extra'
fi
fi
exit 0
