#!/bin/sh

: ${DIR:="$(cd "$(dirname "$0")" && pwd)"}
PPA_BUILDER="$DIR/../ppa-builder"
PPA_BUILDER_URL='https://github.com/AndreyPavlenko/ppa-builder.git'
DEPENDS="$DEPENDS git"
PPA_URL='http://ppa.launchpad.net/aap'

[ -d "$PPA_BUILDER" ] || git clone "$PPA_BUILDER_URL" "$PPA_BUILDER"
. "$PPA_BUILDER/build.sh"

update() {
    _git_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV"
}
