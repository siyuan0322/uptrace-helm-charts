#!/bin/bash

set -euxo pipefail

service postgresql start
service clickhouse-server start

# init uptrace database
sudo -u postgres psql -c "create database uptrace;"
sudo -u postgres psql -c "create user uptrace with encrypted password 'uptrace';"
sudo -u postgres psql -c "grant all privileges on database uptrace to uptrace;"
sudo -u postgres psql -d uptrace -c "grant all on schema public to uptrace"

if [ $# -eq 0 ]; then
    /uptrace --config=/etc/uptrace/uptrace.yml pg wait
    /uptrace --config=/etc/uptrace/uptrace.yml ch wait
    exec /uptrace --config=/etc/uptrace/uptrace.yml serve
else
    exec /uptrace --config=/etc/uptrace/uptrace.yml $@
fi
