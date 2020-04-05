# TUGAS 3 - KELAS 02 - KELOMPOK 7

## Petunjuk Penggunaan Program
Dalam direktori root lakukan kompilasi program dengan makefile:

* Untuk melakukan kompilasi dijkstra versi serial:

`make serial`

`bin/serial [number of vertices]`

* Untuk melakukan kompilasi dijkstra versi paralel (CUDA):

`make`

`[Jumlah threads] [Jumlah nodes] [nama file output]`

## Pembagian Tugas
* 13517074 - Taufikurrahman Anwar : Paralel Dijkstra CUDA, Laporan, Eksplorasi
* 13517128 - Yudy Valentino : Paralel Dijkstra CUDA, Main program, Laporan, Eksplorasi

## Laporan Pengerjaan
### Deskripsi Solusi Paralel

Solusi paralel yang kami buat adalah paralelisasi dalam menjalankan algoritma dijkstra secara keseluruhan. Sebagaimana yang diketahui, algoritma dijkstra dapat mencari jarak terdekat dari suatu node ke semua node lain. Oleh karena pada persoalan yang diberikan kita diminta untuk mencari jarak dari semua node ke semua node lain, paralelisasi yang kami lakukan adalah setiap thread menjalankan dijkstra dari titik asal (source) yang berbeda-beda, lalu kemudian menuliskan hasil jarak antara titik-titik lain dengan source tersebut pada baris yang bersangkutan di matriks yang merepresentasikan hasil akhir.

Misalkan ada 3 anak proses dan ada 3 node pada graf yang di-proses, maka diparalelisasi sehingga anak proses pertama memproses node A, anak proses kedua memproses node B, dan anak proses ketiga memproses node C. Misalkan pula sebuah matriks akhir `result` yang menyimpan matriks akhir, maka anak proses pertama akan menuliskan ke baris pertama `result` yang merepresentasikan jarak dari node A ke node-node lain, dst.


### Analisis Solusi
Untuk solusi kami dirasa cukup sederhana untuk diikuti dan akan mengurangi waktu eksekusi dengan cukup signifikan dengan asumsi terdapat processing speed yang sama
pada setiap thread. Tentunya masih ada solusi yang lebih baik daripada yang kami implementasi, sebagai contoh bisa saja pada algoritma kami untuk setiap thread
pekerjaan dibagi lagi agar algoritma dijkstra pada satu node dapat dijalankan paralel juga dan tidak menjadi terlalu rumit.


### Hasil Uji
Berikut Merupakan hasil uji yang kami lakukan untuk node 100, 500, 1000, dan 3000 baik untuk Serial Dijkstra dan Paralel Dijkstra (dalam seconds):

* **Serial Dijkstra**

| N             | Percobaan 1   | Percobaan 2 | Percobaan 3 | Rata-rata           |
| :-------------: |:-------------:| :-----:| :-------------: |:-------------:|
| 100      | 0.0216 | 0.0223 | 0.0222 | 0.0220 |
| 500      | 2.4426 | 2.4324 | 2.4758 | 2.4503 |
| 1000     | 15.086 | 16.184 | 13.527 | 14.932 |
| 3000     | 469.05 | 517.27 | 428.12 | 471.48 |


* **Paralel Dijkstra CUDA**

| N             | Percobaan 1   | Percobaan 2 | Percobaan 3 | Rata-rata           |
| :-------------: |:-------------:| :-----:| :-------------: |:-------------:|
| 100      | 0.3322 | 0.3322 | 0.3323 | 0.3322 |
| 500      | 9.0596 | 9.0672 | 9.0739 | 9.0669 |
| 1000     | 38.201 | 40.231 | 42.436 | 40.289 |
| 3000     | 324.53 | 221.70 | 174.48 | 240.23 |

**Thread yang digunakan untuk Paralel Dijkstra CUDA = N dan untuk N = 3000 digunakan 1000 thread**


### Analisis Uji
Dari hasil uji dapat dilihat bahwa waktu yang digunakan program parallel secara umum lebih lama dibandingkan yang serial, hal ini menurut kami terjadi karena
cara kami membagi workload pernode masih kurang kecil, diketahui bahwa processor CUDA tidak seberapa baik untuk menangani algoritma yang rumit tetapi untuk
pengujian di atas masing-masing thread mengerjakan satu buah algoritma Dijkstra yang membuat waktunya menjadi lebih lambat.

Di lain sisi untuk node 3000 waktu yang digunakan program menjadi lebih sedikit dibanding program serial, ini menunjukkan bahwa kompleksitas algoritma ini
dalam bentuk serial masih lebih tinggi dibanding ketika dijalankan secara paralel, karena dengan algoritma paralel kita secara kasar hanya mengerjakan 1 
buah algoritma dijkstra sedangkan pada algoritma serial kita mengerjakan n buah algoritma dijkstra.