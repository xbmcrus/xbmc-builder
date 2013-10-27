#!/bin/sh

: ${PPA:='db'}
: ${PPA_URL:='http://ppa.launchpad.net/xbmcrus'}
: ${DIR:="$(cd "$(dirname "$0")" && pwd)"}
DEPENDS="$DEPENDS git"

[ ! -f "$HOME/.build.config" ] || . "$HOME/.build.config" && IGNORE_GLOBAL_CONFIG='true'
[ ! -f "$DIR/build.config" ]   || . "$DIR/build.config" && IGNORE_CONFIG='true'

: ${PPA_BUILDER:="$DIR/../ppa-builder"}
: ${PPA_BUILDER_URL:='https://github.com/bigbelec/xbmc-builder.git'}

[ -d "$PPA_BUILDER" ] || git clone "$PPA_BUILDER_URL" "$PPA_BUILDER"
. "$PPA_BUILDER/build.sh"

update() {
    _git_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV"
}
