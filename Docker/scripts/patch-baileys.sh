#!/bin/bash
# Patch Baileys node_modules pra honrar previewType vindo do urlInfo
# (Baileys hardcoda como 0 = preview pequeno; queremos suportar 1 = preview grande)
set -e
TARGET=node_modules/baileys/lib/Utils/messages.js
if [ ! -f "$TARGET" ]; then
  echo "Baileys target not found at $TARGET — skipping patch"
  exit 0
fi
# Substituir a linha hardcoded por uma que honra urlInfo.previewType
# Tambem injeta canonicalUrl que Baileys esquece de propagar
perl -i -pe 's|extContent\.previewType = 0;|extContent.previewType = (urlInfo.previewType !== undefined ? urlInfo.previewType : 0); if (urlInfo["canonical-url"]) extContent.canonicalUrl = urlInfo["canonical-url"];|g' "$TARGET"

if grep -q "urlInfo.previewType" "$TARGET"; then
  echo "✓ Baileys patched: previewType + canonicalUrl agora respeitam urlInfo"
else
  echo "✗ Patch falhou em $TARGET"
  exit 1
fi
