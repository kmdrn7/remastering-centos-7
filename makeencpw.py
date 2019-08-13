#!/bin/sh
if type python > /dev/null 2>&1; then
    echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$6$JNhgtyGHty65%4rt")' | python -
else
    echo "Python tidak terinstall pada sistem anda;"
fi
