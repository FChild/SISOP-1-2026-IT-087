BEGIN {
    soal = ARGV[2]
    delete ARGV[2]
    FS = ","

}

NR == 1 {
next
}

   {
    # a. jumlah penumpang
    if (soal == "a") {
        count++
    }

    # b. jumlah gerbong unik
    else if (soal == "b") {
	gsub(/\r/, "", $4)
        gerbong[$4]++
    }

    # c. penumpang tertua
    else if (soal == "c") {
        if ($2 > max_age) {
            max_age = $2
            oldest = $1
        }
    }

    # d. rata-rata usia
      else if (soal == "d") {
        total_age += $2
        count_age++
    }

    # e. jumlah Business Class
    else if (soal == "e") {
        if ($3 == "Business") {
            business++
        }
    }
}

END {
    if (soal == "a") {
        print "Jumlah seluruh penumpang KANJ adalah", count " orang"
    }

    else if (soal == "b") {
        print "Jumlah gerbong penumpang KANJ adalah", length(gerbong)
    }

    else if (soal == "c") {
        printf "%s adalah penumpang kereta tertua dengan usia %d tahun\n", oldest, max_age
    }

    else if (soal == "d") {
        rata = total_age / count_age
        printf "Rata-rata usia penumpang adalah %d tahun\n", int(rata)
    }

    else if (soal == "e") {
        print "Jumlah penumpang Business Class ada", business " orang"
    }

    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passanger.csv a"
    }
}
