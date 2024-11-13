#!/usr/bin/bash

function print_help {
    cat <<EOM
Run database and/or PSQL with settings for current installation.
Log file is written to ./dev/postgresql.log

Usage: $0 [--init-db] [--run-db] [--psql] [--stop-db] [--script=SCRIPT]

    --init-db           Initialize database files
    --run-db            Run database
    --psql              Run PSQL
    --script=SCRIPT     Script for PSQL to run
    --stop-db           Stop running database

Example: $0 --run-db --psql --stop-db
EOM
}

set -e

RUN_DB=""
RUN_PSQL=""
STOP_DB=""
INIT_DB=""
PSQL_SCRIPT=""

while [[ -n "$1" ]]; do
    ARG="$1"
    case "$ARG" in
        --init-db)
            INIT_DB="1"
            ;;
        --run-db)
            RUN_DB="1"
            ;;
        --psql)
            RUN_PSQL="1"
            ;;
        --stop-db)
            STOP_DB="1"
            ;;
        --script=*)
            PSQL_SCRIPT="${ARG#*=}"
            ;;
        --help|-h) 
            print_help
            exit 0
            ;;
        *)
            echo "Unknown argument: $ARG"
            print_help
            exit 1
            ;;
    esac
    shift
done

if [ "$INIT_DB" ]; then
    {
        # sudo su - postgres -c "initdb -k -D /usr/local/pgsql/data && pg_ctl start"
        initdb -k -D /usr/local/pgsql/data
    }
fi

if [ "$RUN_DB" ]; then
    {
        pg_ctl start
    }
fi

if [ "$RUN_PSQL" ]; then
    if [ "$PSQL_SCRIPT" ]; then
        psql -f "$PSQL_SCRIPT"
    else
        psql
    fi
fi

if [ "$STOP_DB" ]; then
    {
        pg_ctl stop
    }
fi
