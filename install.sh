#!/usr/bin/env bash

BINARY=eztables
CONFIG=eztables.cfg
INITSCRIPT=init.d/eztables

BINARY_TARGET=/usr/sbin
INITSCRIPT_TARGET=/etc/init.d
CONFIG_TARGET=/etc/eztables
PLUGINS=$CONFIG_TARGET/plugins

if [ ! -z "$1" ]
then
    if [ "$1" == "remove" ]
    then
        if [ -e /etc/debian_version ]
        then
            update-rc.d -f eztables remove
        elif [ -e /etc/redhat-release ]
        then
            chkconfig --del eztables
        fi

        rm "$BINARY_TARGET/$BINARY"
        rm "$CONFIG_TARGET/$CONFIG"
        rm "$CONFIG_TARGET/$TARGETS"
        rm $INITSCRIPT_TARGET/`basename $INITSCRIPT`
        exit
    fi
fi

if [ ! -e "$CONFIG_TARGET" ]
then
    mkdir -p "$CONFIG_TARGET"
fi

cp "$BINARY" "$BINARY_TARGET"
cp "$INITSCRIPT" "$INITSCRIPT_TARGET"

chmod 755 "$BINARY_TARGET/$BINARY"
chmod 755 "$INITSCRIPT_TARGET/`basename $INITSCRIPT`"

if [ -e $CONFIG_TARGET/$CONFIG ]
then
    echo
    echo "-------------------------------------------------------------------"
    echo "Existing configuration found. Creating $CONFIG_TARGET/$CONFIG.new."
    echo "Update your existing configuration file with the new one or EZTABLES may"
    echo "not operate properly due to changes. Press enter to continue."
    echo "-------------------------------------------------------------------"
    read YN
    cp "$CONFIG".example "$CONFIG_TARGET/$CONFIG.new"
else
    cp "$CONFIG".example "$CONFIG_TARGET/$CONFIG"
    mkdir "$PLUGINS" 
    cp plugins/*.eztables "$PLUGINS"
fi

if [ -e /etc/debian_version ]
then
    update-rc.d eztables defaults 99 10
elif [ -e /etc/redhat-release ]
then
    chkconfig --levels 2345 eztables on
fi
