#!/bin/bash

shopt -s extglob

# https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver15#get-sqlpackage-net-core-for-linux
function version_name {
  case $1 in
    14.* | 16.*) echo "libicu55" ;;
    17.*) echo "libicu57" ;;
    18.*) echo "libicu60" ;;
    20.*) echo "libicu66" ;;
    *) echo "Unsupported version: $1" && exit 1 ;;
  esac
}

sudo apt-get update
sudo apt-get install -y libunwind8 wget "$(version_name $1)" || exit 1
