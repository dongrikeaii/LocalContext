#!/bin/sh
set -eu
cd "$(dirname "$0")"
./build.sh
mkdir -p "$HOME/Applications"
ditto LocalContext.app "$HOME/Applications/LocalContext.app"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$HOME/Applications/LocalContext.app"
pluginkit -a "$HOME/Applications/LocalContext.app/Contents/PlugIns/LocalContextFinder.appex"
pluginkit -e use -i io.github.dongrikeaii.localcontext.finder
open "$HOME/Applications/LocalContext.app"
