#!/bin/sh
set -e

: ${PKG_NAME:='xbmc'}
: ${PKG_EPOCH:='2'}
: ${PPA:='xbmc'}
: ${SRC_URL:='https://github.com/xbmc/xbmc.git'}

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='22'
    local bs_ci_count=$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)
    local sha=$(git --git-dir="$SRC_DIR/.git" log --format='%h' -n1 $REV)
    local ci_count=$(git --git-dir="$SRC_DIR/.git" log --format='%H' $REV | wc -l)
    local v_major=$(git --git-dir="$SRC_DIR/.git" show $REV:xbmc/GUIInfoManager.h | grep 'define *VERSION_MAJOR' | awk '{print $3}')
    local v_minor=$(git --git-dir="$SRC_DIR/.git" show $REV:xbmc/GUIInfoManager.h | grep 'define *VERSION_MINOR' | awk '{print $3}')
    local version="${v_major}.${v_minor}-$(($ci_count + $bs_ci_count + $delta))~${sha}"
    echo "$version"
}

_checkout() {
     local src="$1"
    _git_checkout "$src"
}

_main $@
