#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "You need to provide at least one parameter, e.g $0 http://foo.bar"
  exit 1
fi

if ! curl --silent --head "$1" > /dev/null ; then
  echo "curl failed to fetch the link, are you sure it's valid?"
  exit 1
fi

tempdir=$(mktemp -d)
aws s3 cp s3://hodovi.ch/links.json "${tempdir}/links.json"

python - <<EOF
import json

link = "$1"
file_path = "$tempdir/links.json"
with open(file_path, "r+") as f:
  links_json = json.load(f)
  links_json.append(link)
  no_duplicates = set(links_json)
  f.seek(0)
  json.dump(list(no_duplicates), f, indent=2, separators=(',', ': '))
EOF

echo Adding "$1" to links.json
aws s3 cp "${tempdir}/links.json" s3://hodovi.ch/links.json
rm -r "${tempdir}"

