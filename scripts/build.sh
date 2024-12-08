#!/usr/bin/bash

function print_help {
    cat <<EOM
Build PostgreSQL sources
Usage: $0 [-j N|--jobs=N]

Options:

    -j N, --jobs=N      Specify number of threads to use
    -h, --help          Print this help message

Example: $0 -j 12
EOM
}

set -e

THREADS=""
while [ "$1" ]; do
    ARG="$1"
    case $ARG in
    -j)
        shift
        THREADS="$1"
        ;;
    --jobs=*)
        THREADS="${$1#*=}"
        ;;
    -h|--help)
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

if [[ -n "$THREADS" ]]; then
    THREADS="-j $THREADS"
fi

cd postgresql
INSTALL_PATH="$PWD/build"

./configure --enable-debug \
    --enable-cassert

# ./configure --prefix="$INSTALL_PATH" \
#     --enable-debug \
#     --enable-cassert \
#     # --enable-tap-tests \
#     # --enable-depend \
#     CFLAGS="-O0 -g" \
#     CPPFLAGS="-O0 -g"

make $THREADS
sudo make install
sudo make install-world-bin

# Extensions (optional)
# cd contrib
# make $THREADS
# sudo make install
# cd ..
cd ..