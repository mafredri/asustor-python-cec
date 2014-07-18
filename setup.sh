#!/bin/bash
set -e

FETCH_PACKAGES=0

show_help() {
    echo "Options:
  -f    Fetch packages instead of using local ones
  -h    This help"
    exit 0
}

while getopts :fgh opts; do
   case $opts in
        f)
            FETCH_PACKAGES=1
            ;;
        h)
            show_help
            ;;
   esac
done


ROOT=$(cd $(dirname "${0}") && pwd)
PACKAGE=$(basename "${ROOT}")
VERSION=$(<version.txt)

# This defines the arches available and from where to fetch the files
# ARCH:PREFIX
ADM_ARCH=(
    "x86-64:/cross/x86_64-asustor-linux-gnu"
    "i386:/cross/i686-asustor-linux-gnu"
)

# Set hostname (ssh) from where to fetch the files
HOST=asustorx

# We are only interested in files from these directories
KEEP_FILES="
usr/bin
usr/lib*
"

cd $ROOT

if [[ ! -d dist ]]; then
    mkdir dist
fi

for arch in ${ADM_ARCH[@]}; do
    cross=${arch#*:}
    arch=${arch%:*}

    echo "Building ${arch} from ${HOST}:${cross}"

    # Create temp directory and copy the APKG template
    PKG_DIR=build/packages/$arch
    if [ ! -d $PKG_DIR ]; then
        mkdir -p $PKG_DIR
    fi
    if [ $FETCH_PACKAGES -eq 1 ]; then
        echo "Rsyncing packages..."
        rsync -ram --delete --include-from=packages.txt --exclude="*/*" --exclude="Packages" $HOST:$cross/packages/* $PKG_DIR
        PKG_INSTALLED=$(cd $PKG_DIR; ls -1 */*.tbz2 | sort)
        echo -e "# This file is auto-generated.\n${PKG_INSTALLED//.tbz2/}" > pkgversions_$arch.txt
    else
        echo "Using cached packages..."
    fi

    WORK_DIR=build/$arch
    [ ! -d $ARCH_LIB ] && mkdir $ARCH_LIB

    ARCH_LIB=$ROOT/source/lib-$arch
    [ ! -d $WORK_DIR ] && mkdir -p $WORK_DIR

    echo "Cleaning out ${WORK_DIR}..."
    rm -rf $WORK_DIR/*

    echo "Unpacking and grabbing files..."
    (cd $WORK_DIR;
        for pkg in $ROOT/$PKG_DIR/*/*.tbz2; do
            tar xjf $pkg;
        done
        find . -type d -name "python2.7" -exec cp -af {} $ARCH_LIB \;)

    echo "Done!"
done

TMP_DIR=$(mktemp -d /tmp/$PACKAGE.XXXXXX)
cp -af source/* $TMP_DIR

echo "Finalizing..."
echo "Setting version to ${VERSION}"
sed -i '' -e "s^ADM_ARCH^any^" -e "s^APKG_VERSION^${VERSION}^" $TMP_DIR/CONTROL/config.json

echo "Building APK..."
# APKs require root privileges, make sure priviliges are correct
sudo chown -R 0:0 $TMP_DIR
sudo scripts/apkg-tools.py create $TMP_DIR --destination dist/
sudo chown -R $(whoami) dist
