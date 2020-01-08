#!/bin/bash
set -e

# set eggdrop user name and password
USER="eggdrop"
PASSWORD="eggdropPassword"

# set database schema and table name
SCHEMA="test"
TABLE="funmatch"

# add eggdrop user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
<<-EOSQL
CREATE SCHEMA ${SCHEMA};
CREATE USER ${USER} PASSWORD '${PASSWORD}';
EOSQL

# create a new table for the eggdrop user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
<<-EOSQL
CREATE TABLE ${SCHEMA}.${TABLE}(
   id SERIAL PRIMARY KEY,
   date DATE NOT NULL DEFAULT CURRENT_DATE,
   time TIME NOT NULL,
   xonx INTEGER NOT NULL,
   clantag VARCHAR (16) NOT NULL,
   irc VARCHAR (16) NOT NULL,
   www VARCHAR (256) NOT NULL,
   server VARCHAR (256) NOT NULL,
   org VARCHAR (128) NOT NULL
);
EOSQL

# insert some testing data into new table
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
<<-EOSQL
INSERT INTO ${SCHEMA}.${TABLE} (time, xonx, clantag, irc, www, server, org)
VALUES
('18:30', 8, '[WIN]', '#win', 'www.winclan.com', 'et.winclan.com:1337',
'winrar'),
('19:30', 16, '[FAIL]', '#fail', 'www.failclan.com', 'et.failclan.com:7331',
'failbot'),
('20:30', 32, '<unknown>', '#unknown', 'www.unknownclan.com',
'et.unknownclan.com:3000', 'incognito');
EOSQL

# make sure the eggdrop user can access the new table
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
<<-EOSQL
GRANT ALL ON SCHEMA ${SCHEMA} TO ${USER};
GRANT ALL ON ALL TABLES IN SCHEMA ${SCHEMA} TO ${USER};
EOSQL
