#!/usr/bin/env bash

if [ $1 -eq 1 ]; then
  chmod -vR a+w /var/www
else
  chmod -vR a-w /var/www
fi
