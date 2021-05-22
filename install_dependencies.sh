#!/bin/bash

shopt -s extglob

# https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver15#get-sqlpackage-net-core-for-linux
function version_name {
  echo "libicu66"
}

sudo apt-get update
sudo apt-get install -y libunwind8 wget "$(version_name $1)" || exit 1
