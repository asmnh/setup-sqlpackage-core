#!/bin/bash

# see: https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver15#get-sqlpackage-net-core-for-linux

download_link="https://go.microsoft.com/fwlink/?linkid=2157202"

tempdir=$(mktemp -d)
tempfile="${tempdir}/sqlpackage.zip"
unpackdir="${tempdir}/sqlpackage"

function cleanup {
  rm -r "${tempdir}"
}

echo "Downloading sqlpackage archive to ${tempfile}"
wget -O "${tempfile}" "${download_link}" || (echo "SQLPackage download failed" && exit 1)

echo "Unpacking"
mkdir -p "${unpackdir}"
unzip "${tempfile}" -d "${unpackdir}" || (echo "Failed to unpack SQLPackage" && cleanup && exit 1)

if [[ ! -f "${unpackdir}/sqlpackage" ]] ; then
  echo "SQLPackage error: invalid archive format - missing sqlpackage file"
  cleanup
  exit 1
fi

rm "${tempfile}"

echo "Adding to PATH"
chmod +x "${unpackdir}/sqlpackage"
"${unpackdir}/sqlpackage" /version || (echo "Error: failed to check sqlpackage version" && cleanup && exit 1)

echo "SQLPackage successfully installed, exporting PATH"
if [[ "$1" == "true" ]] ; then
  export PATH="${PATH}:${unpackdir}"
  echo "::set-env name=PATH::${PATH}:${unpackdir}"
fi
echo "::set-output name=path::${unpackdir}"
echo "::set-output name=executable::${unpackdir}/sqlpackage"
echo "::set-output name=version::$("${unpackdir}/sqlpackage" /version)"
