#!/bin/sh

# Set up basic auth if USERNAME and PASSWORD are provided
if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
    echo "BasicAuth $USERNAME $PASSWORD" >> /etc/tinyproxy/tinyproxy.conf
fi

# Start Tinyproxy
exec tinyproxy -d
