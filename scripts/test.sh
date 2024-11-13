#!/usr/bin/bash

function print_help {
    cat <<EOM 
Run tests for PostgreSQL
Usage: $0 --regress|--full [-j N,--jobs=N]

Options:

    --regress           Run regress tests (~ make check)
    --full              Run all tests (~ make check-world)
    -j N, --jobs=N      Specify number of jobs for make
    -h, --help          Print this help message

Example: $0 --regress -j 12
EOM
}

set -e

THREADS=""
FULL=""
REGRESS=""

while [ "$1" ]; do
    ARG="$1"
    case "$ARG" in
        -j)
            shift
            THREADS="$1"
            ;;
        --jobs=*)
            THREADS="${ARG#*=}"
            ;;
        --regress)
            REGRESS="1"
            ;;
        --full)
            FULL="1"    
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo "Unknnown argument: $ARG"
            print_help
            exit 1
            ;;
    esac
    shift
done

if [ "$THREADS" ]; then
    THREADS="-j $THREADS"
fi

cd postgresql
if [ "$REGRESS" ]; then
    {
        make check $THREADS
    }
fi

if [ "$FULL" ]; then
    {
        make check-world $THREADS
        cd contrib
        make check $THREADS
        cd ..
    }
fi

cd ..