# **Laporan Resmi Praktikum Modul 1 Sistem Operasi**
---

**Muhammad Rifki Pribadi 5027251087**

---
## Soal_1

Pada soal ini, dilakukan analisis data penumpang kereta yang tersimpan dalam file passenger.csv untuk membantu kondektur (Rusdi) membuat laporan penumpang 
dengan beberapa analisis data sederhana.

##	
script ini mengasumsikan file CSV memiliki urutan kolom sebagai berikut:

Kolom 1 ($1): Nama Penumpang

Kolom 2 ($2): Usia

Kolom 3 ($3): Kelas Tiket (contoh: "Business")

Kolom 4 ($4): Nomor/Nama Gerbong
##
# Step by Step
- unduh file passanger.csv ke terminal dengan menggunakan (wget "URL" -O passanger.csv)
- Penjelasan sub-soal a: setelah itu lanjut ke sub soal a, yang diminta untuk menghitung seluruh penumpang namun mengabaikan baris pertama.
```
BEGIN {
    soal = ARGV[2]
    delete ARGV[2] 
    FS = "," 
}
```
soal = ARGV[2] untuk mengambil input dari termial (a,b,c dll)  
delete ARGV[2] untuk menghapus argumen diatas agar program tidak mengira itu nama file  
FS = "," untuk memisahkan data dengan koma
```
NR == 1 { 
next 
}

   {
    if (soal == "a") {
        count++
    } 
 ```
NR == 1 { membaca data dari baris pertama  
next baris pertama dilewati  
```  
if (soal == "a") {
        count++
    } 
```
Menghitung jumlah penumpang  

- Penjelasan sub-soal b: untuk sub-soal b diminta untuk menghitung ada berapa gerbong yang ada.
```
else if (soal == "b") {
    gsub(/\r/, "", $4) 
    gerbong[$4]++ 
} 
```
gsub(/\r/, "", $4) agar data yang dihitung bersih dan tidak terhitung double  
gerbong[$4]++ Ambil kolom ke-4 (gerbong) untuk dihitung  

- Penjelasan sub-soal c: sub-soal C diminta untuk mencari penumpang tertua di dalam kereta
```
    else if (soal == "c") {
        if ($2 > max_age) {
            max_age = $2
            oldest = $1
        }
    }
```
kode tersebut bekerja dengan membandingkan usia saat ini ($2) dengan usia tertinggi yang tercatat sejauh ini (max_age). 
Jika lebih besar, sistem akan memperbarui nilai max_age dan menyimpan nama orang tersebut ke variabel oldest ($1).

- Penjelasan sub-soal d: untuk sub-soal d diminta untuk menghitung rata-rata dari usia penumpang.
```
else if (soal == "d") {
        total_age += $2
        count_age++
    }
```
Kode tersebut bekerja dengan menjumlahkan seluruh usia ke dalam variabel total_age (total_age += $2) 
setelah itu menghitung jumlah data seluruh usia untuk rata-rata.

- Penjelasan sub-soal e: untuk sub-soal ini diminta untuk menghitung jumlah penumpang bussiness class yang ada.
```
else if (soal == "e") {
    if ($3 == "Business") {
        business++
    }
}
```
kode ini bekerja dengan mengecek kolom kelas ($3) dan menambah jumlah jika kelasnya "Business".

# OUTPUT UNTUK SOAL_1
```
END {
    if (soal == "a") {
        print "Jumlah penumpang:", count
    }

    else if (soal == "b") {
        print "Jumlah gerbong:", length(gerbong)
    }

    else if (soal == "c") {
        printf "%s adalah penumpang kereta tertua dengan usia %d tahun\n", oldest, max_age
    }

    else if (soal == "d") {
        rata = total_age / count_age
        printf "Rata-rata usia penumpang adalah " int(rata + 0.5) " tahun\n"
    }

    else if (soal == "e") {
        print "Jumlah penumpang Business Class:", business
    }
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
    }
}
```
![Output Soal 1](assets/Outputsoal_1.png)  
**Kendala**  
- Ada sedikit kendala untuk membersihkan data menghitung gerbong yang ada  

---


##Soal_2
Untuk soal kedua ini, kita mencari data koordinat dari file JSON dan bikin kalkulasi bash script buat nyari lokasi rahasia. 
##
# PENJELASAN ALUR (STEPBYSTEP)
- Menyiapkan tools untuk mendownload file gdrive dengan menggunakan venv dan pip
- Membuat folder baru di folder soal_2 yang bernama ekspedisi. Folder ini akan di isi dengan
  file gdrive
- setelah tools untuk mendownload file terinstall, gunakan (gdown <URL> -O peta-ekspedisi-amba.pdf)
- lalu gunakan cat untuk melihat isi file tersebut, yang dimana akan muncul sebuah link yang akan
  digunakan untuk mencari data koordinat
- gunakan (git clone <Link yang baru didapat> peta-gunung-kawi) di folder ekspedisi
- setelah mengclone link tersebut akan muncul gsxtrack.json yang berisi data koordinat
- buat file "parserkoordinat.sh" untuk mengisi file tersebut dengan script
```
#!/bin/bash

INPUT_FILE="gsxtrack.json"
OUTPUT_FILE="titik-penting.txt"

grep -E '"id"|"site_name"|"latitude"|"longitude"' "$INPUT_FILE" | awk '
/"id":/ {
    id = $0;
    sub(/."id":\s"/, "", id);
    sub(/".*/, "", id);
}
/"site_name":/ {
    name = $0;
    sub(/."site_name":\s"/, "", name);
    sub(/".*/, "", name);
}
/"latitude":/ {
    lat = $0;
    sub(/."latitude":\s/, "", lat);
    sub(/,.*/, "", lat);
}
/"longitude":/ {
    lon = $0;
    sub(/."longitude":\s/, "", lon);
    sub(/,.*/, "", lon);
    print id ", " name ", " lat ", " lon
}' | sort > "$OUTPUT_FILE"

echo "Berhasil parsing! Cek file $OUTPUT_FILE" ```
 
script ini digunakan agar id, site_name, latitude, longitude dari gsxtrack.json terlihat rapi  
output dari script tersebut akan diberi nama baru yaitu "titik-penting.txt"
- setelah itu lanjut membuat file baru "nemupusaka.sh" file tersebut akan di isi script 
```
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
}' "$INPUT_FILE" ```
script tersebut digunakan untuk mencari titik tengah diagonal letak pasti pusaka tersebut.  
output dari file tersebut akan diberi nama baru yaitu "posisipusaka.txt" yang berisi koordinat dari pusaka tersebut  
##
# OUTPUT titik-penting
![Output Soal 1](assets/Outputtitikpenting.png)  
##
# OUTPUT nemupusaka
![Output Soal 1](assets/Outputnemupusaka.png)
*Kendala*
- kendala pada saat mengerjakan soal 2 adalah sedikit kebingugan pada saat menginstal tools venv


