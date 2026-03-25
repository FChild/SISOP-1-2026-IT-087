#!/bin/bash

# Tentukan path file input dan output
INPUT_FILE="gsxtrack.json"
OUTPUT_FILE="titik-penting.txt"

# Menggunakan grep untuk mengambil baris target, 
# lalu awk untuk membersihkan karakter JSON dan merapikan format [cite: 114]
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
    # Karena longitude umumnya menjadi atribut terakhir node, kita langsung cetak hasilnya
    print id ", " name ", " lat ", " lon
}' | sort > "$OUTPUT_FILE"

echo "Berhasil parsing! Cek file $OUTPUT_FILE"
