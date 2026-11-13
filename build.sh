#!/usr/bin/env bash
# Build a launcher at bin/factor-b64. Factor is interpreted (boot image); no compilation.
# NOTE: the system `factor` on PATH is GNU coreutils, NOT the Factor language, so the
# launcher points at the real Factor binary explicitly (override with FACTOR_BIN).
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p bin
FACTOR_BIN="${FACTOR_BIN:-$HOME/.local/toolchains/factor-lang/factor/factor}"
[ -x "$FACTOR_BIN" ] || { echo "FATAL: Factor language binary not found at $FACTOR_BIN (set FACTOR_BIN)"; exit 1; }
cat > bin/factor-b64 <<WRAP
#!/usr/bin/env bash
DIR="\$(cd "\$(dirname "\$0")/.." && pwd)"
exec "$FACTOR_BIN" "\$DIR/src/main.factor" "\$@"
WRAP
chmod +x bin/factor-b64
echo "built bin/factor-b64"