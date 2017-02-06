#!/bin/sh

# replacing ' ' to '-' and UPPERCASE to lowercase 

# FIXME

fix= $(echo "$1" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
echo "$fix"
#mv -vi "$1" "$fix"

