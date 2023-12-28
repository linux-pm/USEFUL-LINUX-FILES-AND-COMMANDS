#!/bin/bash

# REMEMBER TO CREATE ALL THIS DIRECTORIES
#mkdir -p $DUMP_ROOT_DIR/
#mkdir -p $DUMP_ROOT_DIR/daily
#mkdir -p $DUMP_ROOT_DIR/weekly
#mkdir -p $DUMP_ROOT_DIR/monthly
#mkdir -p $DUMP_ROOT_DIR/yearly


USERNAME=""
PASSWORD=""
SERVER=""
PORT=5432
DATABASE=""
DUMP_ROOT_DIR=""
DATE=`/bin/date +%d-%m-%Y,%A`
WEEK_DAY=`/bin/date +%a`

DATE=`/bin/date +%Y-%m-%d`

export WEEK_DAY=`/bin/date +%u`
export DAY=`/bin/date +%d`
export MONTH_DAY=`/bin/date +%d-%m`


cd $DUMP_ROOT_DIR/daily/

# delete the old file
rm -f $DATABASE-dmp$WEEK_DAY.sql

# dump a new file
PGPASSWORD="$PASSWORD" pg_dump -U $USERNAME -h $SERVER -p $PORT -d $DATABASE -f "$DATABASE-dmp$WEEK_DAY.sql"

# delete the old tar file
rm -f $DATABASE-dmp$WEEK_DAY.sql.tar.gz

# create a new tar file based on the new dumo file
tar czf $DATABASE-dmp$WEEK_DAY.sql.tar.gz $DATABASE-dmp$WEEK_DAY.sql

# delete the new dump file
rm -f $DATABASE-dmp$WEEK_DAY.sql

#####################
## WEEK BACKUP  ##
#####################
if [ "$WEEK_DAY" == "0" ]; then
echo 'DOING WEEK BACKUP'
cp $DUMP_ROOT_DIR/daily/$DATABASE-dmp$WEEK_DAY.sql.sql.tar.gz $DUMP_ROOT_DIR/weekly/$DATABASE-dmp$DATE.sql.tar.gz
fi


#####################
##  MONTH BACKUP  ##
#####################
if [ "$DAY" == "01" ]; then
echo 'DOING MONTH BACKUP'
cp $DUMP_ROOT_DIR/daily/$DATABASE-dmp$WEEK_DAY.sql.tar.gz $DUMP_ROOT_DIR/monthly/$DATABASE-dmp$DATE.sql.tar.gz
fi


#####################
##  YEAR BACKUP   ##
#####################
if [ "$MONTH_DAY" == "01-01" ]; then
echo 'DOING YEAR BACKUP'
cp $DUMP_ROOT_DIR/daily/$DATABASE-dmp$WEEK_DAY.sql.tar.gz $DUMP_ROOT_DIR/yearly/$DATABASE-dmp$DATE.sql.tar.gz
fi
