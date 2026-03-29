#!/bin/bash

INPUT_FILE="gsxtrack.json"
OUTPUT_FILE="titik-penting.txt"

grep -E '"id"|"site_name"|"latitude"|"longitude"' "$INPUT_FILE" | awk '
/"id":/ {
    id = $0;
    sub(/.*"id":\s*"/, "", id);
    sub(/".*/, "", id);
}
/"site_name":/ {
    name = $0;
    sub(/.*"site_name":\s*"/, "", name);
    sub(/".*/, "", name);
}
/"latitude":/ {
    lat = $0;
    sub(/.*"latitude":\s*/, "", lat);
    sub(/,.*/, "", lat);
}
/"longitude":/ {
    lon = $0;
    sub(/.*"longitude":\s*/, "", lon);
    sub(/,.*/, "", lon);
    print id ", " name ", " lat ", " lon
}' | sort > "$OUTPUT_FILE"

echo "Berhasil parsing! Cek file $OUTPUT_FILE"
