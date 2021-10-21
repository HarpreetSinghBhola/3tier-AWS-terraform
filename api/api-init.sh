#!/usr/bin/env bash

DBUSER=$1
DBPASS=$2
DBHOST=$3
DB=$4
DBPORT=$5

CON=postgres://${DBUSER}:${DBPASS}@${DBHOST}/${DB} PORT=${DBPORT} npm start $1 $2 $3 $4 $5