#!/bin/sh

find $PG_DUMP_DIRECTORY/dump* -mtime +0 -exec rm {} \;

export PGPASSWORD="$PG_PASSWORD"

fileDt=$(date '+%Y_%m_%d_%H_%M_%S');
backUpFilePath="$PG_DUMP_DIRECTORY/dump_$fileDt.gz"
pg_dumpall -h $PG_HOST -U $PG_USER -c | gzip > $backUpFilePath
if [ $? -ne 0 ]; then
  rm $backUpFilePath
  echo "Unable to execute a BackUp. Please check DB connection settings"
  exit 1
fi
