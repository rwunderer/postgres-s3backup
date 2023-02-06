#!/bin/bash

set -euo pipefail

# environment variables:
#
# for getting the databases to back up:
#   DB_REGEX
#
# for postgres:
#   PGUSER
#   PGHOST
#   PGPORT
#   PGPASSWORD
#
# for gpg:
#   GPG_RECIPIENT
#
# for s3:
#   AWS_ACCESS_KEY_ID
#   AWS_SECRET_ACCESS_KEY
#   S3_REGION
#   S3_ENDPOINT
#   S3_BASEURL
#
# volumes:
# /mnt/backup-public-key.asc 

S3_FOLDER="${S3_BASEURL}/$(date +%Y%m%d)"

databases=$(psql -Atl postgres | grep -E "${DB_REGEX}" | awk -F '|' '{print $1}')

if [ -n "${GPG_RECIPIENT:-}" ]; then
    gpg --import /mnt/backup-public-key.asc
    GPG="gpg --batch --no-tty --trust-model always --recipient "${GPG_RECIPIENT}" --encrypt"
else
    GPG="cat"
fi

#
# back up databases
for db in $databases; do
    FIL="${db}.sql.bz2"
    [ -n "${GPG_RECIPIENT:-}" ] && FIL="${FIL}.gpg"

    pg_dump $db \
        | bzip2 -c \
        | ${GPG} \
        | aws s3 cp - --region "${S3_REGION}" --endpoint "${S3_ENDPOINT}" "${S3_FOLDER}/${FIL}"
done
