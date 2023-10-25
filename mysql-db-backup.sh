#!/bin/bash
YEAR=`date '+%Y'`
MOUNTH=`date '+%m'`
DAY=`date '+%d'`
HOUR=`date '+%H'`
P_YEAR=`date '+%Y' --date="6 hours ago"`
P_MOUNTH=`date '+%m' --date="6 hours ago"`
P_DAY=`date '+%d' --date="6 hours ago"`
P_HOUR=`date '+%H' --date="6 hours ago"`
USER=$1
PASS=$2

mkdir -p /var/lib/mysql/backups/bk-$YEAR-$MOUNTH-$DAY
xtrabackup --user=$USER --password=$PASS --backup --target-dir=/var/lib/mysql/backups/bk-$YEAR-$MOUNTH-$DAY

cd /var/lib/mysql/backups/

tar -zcvf mysql_$YEAR-$MOUNTH-$DAY.tar.gz  bk-$YEAR-$MOUNTH-$DAY
sleep 5

scp mysql_$YEAR-$MOUNTH-$DAY.tar.gz bk-talentcoach@94.130.223.231:~/backup/database/percona8

find  /var/lib/mysql/backups/  -type d -name "bk-*" -mtime +4 -exec rm -rf {} +
