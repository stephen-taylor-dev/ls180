# run chmod +x name_of_file.sh

DATABASE_NAME=$1

dropdb $DATABASE_NAME

createdb $DATABASE_NAME

psql $DATABASE_NAME -f $DATABASE_NAME.sql