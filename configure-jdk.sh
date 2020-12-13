#!/bin/bash

## Assuming we are in base directory

bash configure --with-extra-cflags="$CFLAGS" --with-extra-cxxflags="$CXXFLAGS" --with-extra-ldflags="$LDFLAGS" --disable-warnings-as-errors --with-log=info
