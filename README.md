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
/////


### Hasil Uji
Berikut Merupakan hasil uji yang kami lakukan untuk node 100, 500, 1000, dan 3000 baik untuk Serial Dijkstra dan Paralel Dijkstra (dalam seconds):

* **Serial Dijkstra**

| N             | Percobaan 1   | Percobaan 2 | Percobaan 3 | Rata-rata           |
| ------------- |:-------------:| -----:| ------------- |:-------------:|
| 100      | - | - | - | - |
| 500      | - | - | - | - |
| 1000     | - | - | - | - |
| 3000     | - | - | - | - |


* **Paralel Dijkstra OpenMP**

| N             | Percobaan 1   | Percobaan 2 | Percobaan 3 | Rata-rata           |
| ------------- |:-------------:| -----:| ------------- |:-------------:|
| 100      | - | - | - | - |
| 500      | - | - | - | - |
| 1000     | - | - | - | - |
| 3000     | - | - | - | - |

**Thread yang digunakan untuk Paralel Dijkstra CUDA = ///////////////////////////**


### Analisis Uji
/////////////////////////////////////////////////////////////