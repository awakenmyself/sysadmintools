#!/bin/bash
# openoffice.org  headless server script
#
# chkconfig: 2345 80 30
# description: headless openoffice server script
# processname: openoffice

OOO_USER=openoffice
OOO_HOME=/home/$OOo_USER
SOFFICE_BIN=/usr/bin/ooffice
XVFB_BIN=/usr/bin/Xvfb
PIDFILE_XVFB=/var/run/xvfb-ooffice-server.pid
PIDFILE_OOO=/var/run/ooffice-server.pid
DISPLAY=":99"

cd $OOO_HOME

case "$1" in
    start)
     
    if [ -f $PIDFILE_XVFB ]; then
      echo "X frame buffer for OpenOfficeheadless server has already started."
    else 
      echo "Starting X Frame buffer for OpenOffice headless server"
      su $OOO_USER -c "Xvfb :99 -screen scrn0 800x600x16" & > /dev/null 2>&1
      touch $PIDFILE_XVFB
    fi
    if [ -f $PIDFILE_OOO ]; then
      echo "OpenOffice headless server has already started."
    else 
      echo "Starting OpenOffice headless server"
      su $OOO_USER -c "$SOFFICE_BIN -headless -display :99" & > /dev/null 2>&1
      touch $PIDFILE_OOO
    fi
    ;;

    stop)

    if [ -f $PIDFILE_OOO ]; then
      echo "Stopping OpenOffice headless server."
      su $OOO_USER -c "pkill -9 -U $OOO_USER soffice" \
      	&& su $OOO_USER -c "pkill -9 -U $OOO_USER soffice.bin" 
      rm -f $PIDFILE_OOO
    else
      echo "Openoffice headless server is not running, foo."
    fi

    if [ -f $PIDFILE_XVFB ]; then
      echo "Stopping X frame buffer for OpenOffice headless server."
      su $OOO_USER -c "pkill -9 -U $OOO_USER Xvfb"
      rm -f $PIDFILE_XVFB
    else
      echo "X frame buffer for Openoffice headless server is not running, foo."
    fi

    ;;
    *)
    echo "Usage: $0 {start|stop}"
esac
cd - >/dev/null
exit 0

