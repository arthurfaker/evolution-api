#!/bin/sh
# Patch Baileys node_modules pra honrar previewType vindo do urlInfo
# (Baileys hardcoda como 0 = preview pequeno; queremos suportar 1 = preview grande)
set -e
TARGET=node_modules/baileys/lib/Utils/messages.js
if [ ! -f "$TARGET" ]; then
  echo "Baileys target not found at $TARGET — skipping patch"
  exit 0
fi
node -e "
const fs = require('fs');
const path = '$TARGET';
let s = fs.readFileSync(path, 'utf8');
const old = 'extContent.previewType = 0;';
const neu = 'extContent.previewType = (urlInfo.previewType !== undefined ? urlInfo.previewType : 0); if (urlInfo[\"canonical-url\"]) extContent.canonicalUrl = urlInfo[\"canonical-url\"];';
if (!s.includes(old)) {
  console.error('✗ pattern not found in ' + path);
  process.exit(1);
}
s = s.replace(old, neu);
fs.writeFileSync(path, s);
console.log('✓ Baileys patched: previewType + canonicalUrl agora respeitam urlInfo');
"
