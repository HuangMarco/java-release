#!/bin/bash

set -eux

git status

cat >> config/private.yml <<EOF
---
blobstore:
  provider: s3
  options:
    access_key_id: "$BLOBSTORE_ACCESS_KEY_ID"
    secret_access_key: "$BLOBSTORE_SECRET_ACCESS_KEY"
EOF

bosh upload-blobs
bosh create-relase --final

git add -A
git status

git config --global user.email "ci@localhost"
git config --global user.name "CI Bot"
git commit -m "Final release via concourse"
