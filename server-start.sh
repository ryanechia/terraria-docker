#!/bin/bash

if [[ "$1" == 'run' ]]; then
  exec ./TerrariaServer -x64 -config serverconfig.txt
fi

exec "$@"
