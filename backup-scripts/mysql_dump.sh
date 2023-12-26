#!/bin/bash


ROOT_FOLDER="/DUMPS"
DUMP_NAME="my_mysql_dump"
USERNAME="MYSQL_USER"
PASSWORD="USER_PASSWORD"
SERVER="MYSQL_SERVER"
DATABASE="MYSQL_DB"
DATE=`/bin/date +%d-%m-%Y,%A`
WEEK_DAY=`/bin/date +%a`

echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo '@@ Backup start |'  $DATE
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

DATE=`/bin/date +%Y-%m-%d`

# LOCAL BACKUP

export WEEK_DAY=`/bin/date +%u`
export DAY=`/bin/date +%d`
export MONTH_DAY=`/bin/date +%d-%m`


cd $ROOT_FOLDER/daily/

rm -f $DUMP_NAME-dmp$WEEK_DAY.sql

/usr/bin/mysqldump -u"$USERNAME" -p"$PASSWORD" -h "$SERVER" "$DATABASE" --no-tablespaces > "$DUMP_NAME-dmp$WEEK_DAY.sql"

rm -f $DUMP_NAME-dmp$WEEK_DAY.sql.tar.gz

tar czf $DUMP_NAME-dmp$WEEK_DAY.sql.tar.gz $DUMP_NAME-dmp$WEEK_DAY.sql

rm -f $DUMP_NAME-dmp$WEEK_DAY.sql

#####################
## WEEK BACKUP  ##
#####################
if [ "$WEEK_DAY" == "0" ]; then
echo 'DOING WEEK BACKUP'
cp $ROOT_FOLDER/daily/database_dump_$WEEK_DAY.sql.tar.gz /$DUMP_NAME-dmps/weekly/database_dump_$DATE.sql.tar.gz
fi


#####################
##  MONTH BACKUP  ##
#####################
if [ "$DAY" == "01" ]; then
echo 'DOING MONTH BACKUP'
cp $ROOT_FOLDER/daily/database_dump_$WEEK_DAY.sql.tar.gz /$DUMP_NAME-dmps/monthly/database_dump_$DATE.sql.tar.gz
fi


#####################
##  YEAR BACKUP   ##
#####################
if [ "$MONTH_DAY" == "01-01" ]; then
echo 'DOING YEAR BACKUP'
cp $ROOT_FOLDER/daily/database_dump_$WEEK_DAY.sql.tar.gz /$DUMP_NAME-dmps/anual/database_dump_$DATE.sql.tar.gz
fi

echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo '@@ End of backup |'  $DATE
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
