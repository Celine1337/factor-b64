#!/usr/bin/env bash
# Self-contained test suite for factor-b64 (RFC 4648 base64 test vectors + roundtrips).
set -uo pipefail
cd "$(dirname "$0")"
./build.sh >/dev/null || { echo "FAIL: build"; exit 1; }
B="./bin/factor-b64"
pass=0; fail=0
ok(){ pass=$((pass+1)); }
bad(){ fail=$((fail+1)); echo "FAIL: $1"; }
eq(){ # name expected actual
  if [ "$2" = "$3" ]; then ok; else bad "$1 (got '$3', want '$2')"; fi
}

# RFC 4648 section 10 test vectors
eq "encode ''"        ""           "$($B encode '' 2>/dev/null)"
eq "encode f"         "Zg=="       "$($B encode f 2>/dev/null)"
eq "encode fo"        "Zm8="       "$($B encode fo 2>/dev/null)"
eq "encode foo"       "Zm9v"       "$($B encode foo 2>/dev/null)"
eq "encode foob"      "Zm9vYg=="   "$($B encode foob 2>/dev/null)"
eq "encode fooba"     "Zm9vYmE="   "$($B encode fooba 2>/dev/null)"
eq "encode foobar"    "Zm9vYmFy"   "$($B encode foobar 2>/dev/null)"
eq "decode Zg=="      "f"          "$($B decode Zg== 2>/dev/null)"
eq "decode Zm9v"      "foo"        "$($B decode Zm9v 2>/dev/null)"
eq "decode Zm9vYmFy"  "foobar"     "$($B decode Zm9vYmFy 2>/dev/null)"

# multi-word input is joined with a single space
eq "encode two words" "aGVsbG8gd29ybGQ=" "$($B encode hello world 2>/dev/null)"
eq "decode two words" "hello world"      "$($B decode aGVsbG8gd29ybGQ= 2>/dev/null)"

# roundtrip a string with punctuation and spaces
rt="The quick brown fox, jumps over 13 lazy dogs!"
enc="$($B encode "$rt" 2>/dev/null)"
eq "roundtrip punctuation" "$rt" "$($B decode "$enc" 2>/dev/null)"

# usage path does not crash
$B >/dev/null 2>&1; ok

echo "----------------------------------------"
echo "factor-b64: $pass passed, $fail failed"
[ "$fail" -eq 0 ] && echo "ALL CHECKS PASSED" || exit 1