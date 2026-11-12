#!/bin/sh
set -eu
cd "$(dirname "$0")"
APP="$PWD/LocalContext.app"
EXT="$APP/Contents/PlugIns/LocalContextFinder.appex"
mkdir -p "$APP/Contents/MacOS" "$EXT/Contents/MacOS"
mkdir -p "$APP/Contents/Resources/Templates"
cp Templates/Blank.* "$APP/Contents/Resources/Templates/"
python3 - <<'PY'
import plistlib
from pathlib import Path
app=Path('LocalContext.app/Contents')
info=dict(CFBundleIdentifier='io.github.dongrikeaii.localcontext',CFBundleName='LocalContext',CFBundleDisplayName='本地右键工具',CFBundleExecutable='LocalContext',CFBundlePackageType='APPL',CFBundleVersion='3',CFBundleShortVersionString='2.1',LSMinimumSystemVersion='13.0',CFBundleURLTypes=[dict(CFBundleURLSchemes=['localcontext'],CFBundleURLName='io.github.dongrikeaii.localcontext.actions')])
info['NSServices']=[dict(NSMenuItem={'default':n},NSMessage=m,NSPortName='LocalContext',NSSendTypes=['public.file-url']) for n,m in [('复制完整路径','copyPaths'),('新建文本文件','newText')]]
(app/'Info.plist').write_bytes(plistlib.dumps(info))
info=dict(CFBundleIdentifier='io.github.dongrikeaii.localcontext.finder',CFBundleName='LocalContextFinder',CFBundleDisplayName='本地右键工具',CFBundleExecutable='LocalContextFinder',CFBundlePackageType='XPC!',CFBundleVersion='3',CFBundleShortVersionString='2.1',LSMinimumSystemVersion='13.0',NSExtension={'NSExtensionPointIdentifier':'com.apple.FinderSync','NSExtensionPrincipalClass':'FinderExtension'})
(app/'PlugIns/LocalContextFinder.appex/Contents/Info.plist').write_bytes(plistlib.dumps(info))
Path('finder.entitlements').write_bytes(plistlib.dumps({'com.apple.security.app-sandbox':True}))
PY
swiftc -module-cache-path /tmp/localcontext-swift-cache main.swift Operations.swift -o "$APP/Contents/MacOS/LocalContext"
swiftc -module-cache-path /tmp/localcontext-swift-cache -emit-executable -Xlinker -e -Xlinker _NSExtensionMain -framework FinderSync -framework Cocoa FinderExtension.swift -o "$EXT/Contents/MacOS/LocalContextFinder"
codesign --force --sign - --entitlements finder.entitlements "$EXT"
codesign --force --sign - "$APP"
