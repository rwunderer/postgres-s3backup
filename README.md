# postgres-s3backup

Alpine image with aws-cli, gpg, bzip2, psql and backup script

## backup_databases

Backup postgres databases, compress the backup, optionally encrypt it with pgp and store the resulting blob in S3.
Each database will be stored to a separate S3 object.

### Environment variables

| Variable                                 | Description                                                                       |
|------------------------------------------|-----------------------------------------------------------------------------------|
| DB_REGEX                                 | Filter the databases to backup, eg `(dbname[1-3])`                                |
| DAYS_TO_KEEP                             | Remove backups older than this many days                                          |
| PGUSER, PGHOST, PGPORT, PGPASSWORD       | Connection parameters for pg_dump                                                 |
| GPG_RECIPIENT                            | User to encrypt content to. Should match public key (see below)                   |
| AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY | Connection credentials to S3                                                      |
| S3_ENDPOINT                              | S3 endpoint server (eg `https://s3-de-central.profitbricks.com`)                  |
| S3_BASEURL                               | S3 bucket name and optional leading path (eg `s3://my-basket/backups/database/    |

### Volumes

| Path                          | Description                                                                                  |
|-------------------------------|----------------------------------------------------------------------------------------------|
| `/mnt/backup-public-key.asc`  | Public key to encrypt the backup to                                                          |
