#!/bin/bash

INPUT_FILE="titik-penting.txt"
OUTPUT_FILE="posisipusaka.txt"

awk -F ', ' '
BEGIN {
    sum_lat = 0;
    sum_lon = 0;
    count = 0;
}
{
    sum_lat += $3;
    sum_lon += $4;
    count++;
}
END {
    if (count > 0) {
        mid_lat = sum_lat / count;
        mid_lon = sum_lon / count;
        
        printf "Koordinat pusat:\n%.6f, %.6f\n", mid_lat, mid_lon > "'"$OUTPUT_FILE"'";
        printf "Koordinat pusat:\n%.6f, %.6f\n", mid_lat, mid_lon;
    } else {
        print "File data kosong atau tidak ditemukan."
    }
}' "$INPUT_FILE"
