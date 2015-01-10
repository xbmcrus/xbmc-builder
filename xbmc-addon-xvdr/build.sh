#!/bin/sh
set -e

: ${PKG_NAME:='xbmc-addon-xvdr'}
: ${SRC_URL:='https://github.com/pipelka/xbmc-addon-xvdr.git'}
: ${REV:=origin/xbmc-gotham}

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='29'
    local bs_ci_count=$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)
    local sha=$(git --git-dir="$SRC_DIR/.git" log --format='%h' -n1 $REV)
    local ci_count=$(git --git-dir="$SRC_DIR/.git" log --format='%H' $REV | wc -l)
    local v_major=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | grep -E 'm4_define\(\[MAJOR\]' | awk '{print $2}' | tr -d ')')
    local v_minor=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | grep -E 'm4_define\(\[MINOR\]' | awk '{print $2}' | tr -d ')')
    local v_micro=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | grep -E 'm4_define\(\[MICRO\]' | awk '{print $2}' | tr -d ')')
    local version="${v_major}.${v_minor}.${v_micro}-$(($ci_count + $bs_ci_count + $delta))~${sha}"
    echo "$version"
}

_checkout() {
     local dest="$1"
    _git_checkout "$dest"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        local src="$1"
        local tmp_src="$BUILD_DIR/tmp_src"
        cp -r "$src" "$tmp_src"
        cd "$tmp_src"
        ./autogen.sh > /dev/null
        cp -r debian "$deb_dir"
        cd - > /dev/null
        $RM -rf "$tmp_src"
        sed -i "s/^Depends:/Depends: xbmc, /" "$deb_dir/control"
        cp -r "$DIR/debian"/* "$deb_dir"
    fi
    
    echo "$deb_dir"
}

_main $@
