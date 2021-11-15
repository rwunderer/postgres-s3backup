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
#   S3_ENDPOINT
#   S3_BASEURL
#
# for cleaning up:
#   DAYS_TO_KEEP
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
        | aws s3 cp - --endpoint "${S3_ENDPOINT}" "${S3_FOLDER}/${FIL}"
done

#
# clean up old backups
if [ "${DAYS_TO_KEEP}" -gt "0" ]; then
    EXPIRY_DATE="$(date +%Y%m%d -d "${DAYS_TO_KEEP} days ago")"

    while read dat tim siz fil; do
        if [ "${dat//-/}" -lt "${EXPIRY_DATE}" ]; then
            aws s3 rm --endpoint "${S3_ENDPOINT}" "${S3_FOLDER}/${fil}"
        fi
    done < <(aws s3 ls --endpoint "${S3_ENDPOINT}" "${S3_FOLDER}/")
fi
