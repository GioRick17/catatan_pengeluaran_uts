# DompetHarian - Aplikasi Catatan Pengeluaran Harian

Proyek Ujian Tengah Semester (UTS) — Pemrograman Mobile (Semester 7)  
Program Studi Informatika, Universitas Teknologi Digital Indonesia (UTDI)

---

## Identitas Mahasiswa
- Nama: Giovanni Ricky Agung Sanyoto
- NIM: 235411028
- Program Studi: Informatika (Kelas Karyawan)
- Mata Kuliah: Pemrograman Mobile / Framework Mobile
- Repositori: https://github.com/GioRick17/catatan_pengeluaran_uts

---

## Deskripsi Proyek
DompetHarian adalah aplikasi mobile berbasis Flutter yang dikembangkan untuk memenuhi tugas proyek Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile. Aplikasi ini berfungsi mencatat transaksi pengeluaran harian, memantau batas anggaran harian (budget limit), dan menampilkan status evaluasi kondisi keuangan secara real-time.

Aplikasi dirancang dengan antarmuka yang adaptif terhadap orientasi layar, sehingga tata letak tampilan dapat menyesuaikan secara otomatis saat perangkat berada pada mode Portrait maupun Landscape.

---

## Pemetaan Implementasi Materi Perkuliahan
Berikut adalah rincian implementasi materi perkuliahan ke dalam kode program aplikasi:

| Materi Perkuliahan | Implementasi dalam Aplikasi | Lokasi File |
| :--- | :--- | :--- |
| Layout (Row, Column) & Responsiveness | Menggunakan widget OrientationBuilder untuk mendeteksi orientasi layar. Pada mode Portrait, komponen disusun vertikal menggunakan Column di dalam SingleChildScrollView. Pada mode Landscape, layar dibagi menjadi 2 kolom berdampingan menggunakan Row dan Expanded agar tidak terjadi render overflow saat keyboard aktif. | lib/home_page.dart |
| Scaffold, AppBar, & Container | Struktur tampilan utama memanfaatkan Scaffold dengan AppBar bertema Teal Material 3. Komponen kartu ringkasan dan riwayat transaksi didekorasi menggunakan Container dengan properti BoxDecoration (warna latar, batas/border, radius sudut, dan bayangan/box shadow). | lib/home_page.dart<br>lib/detail_page.dart<br>lib/about_page.dart |
| StatelessWidget & StatefulWidget | - StatefulWidget: Digunakan pada HomePage untuk mengelola data transaksi yang dinamis, kalkulasi total pengeluaran secara real-time, validasi input form, serta pembaruan tampilan layar melalui setState().<br>- StatelessWidget: Digunakan pada class AplikasiPengeluaranHarian, DetailPage (menerima data melalui constructor), dan AboutPage (halaman profil dengan konten statis). | lib/main.dart<br>lib/home_page.dart<br>lib/detail_page.dart<br>lib/about_page.dart |
| Basic Widget (Text, Image, Button, EditText) | - Text: Menampilkan label, ringkasan, dan teks dinamis dengan format Rupiah.<br>- Image: Memuat aset gambar lokal menggunakan Image.asset('assets/images/logo_dompet.png') yang dilengkapi errorBuilder sebagai fallback ke Icon.<br>- Button: Menggunakan ElevatedButton, OutlinedButton, dan IconButton.<br>- EditText: Menggunakan TextFormField yang terhubung dengan TextEditingController, validator untuk mencegah input kosong/tidak valid, dan FilteringTextInputFormatter.digitsOnly. | lib/home_page.dart<br>lib/about_page.dart |
| Navigator & Route | Perpindahan halaman menggunakan Navigator.push dengan MaterialPageRoute untuk membuka DetailPage sambil mengirimkan data transaksi melalui constructor. Halaman AboutPage juga dibuka melalui Navigator.push, dan kedua halaman menyediakan tombol kembali yang mengeksekusi Navigator.pop(context). | lib/home_page.dart<br>lib/detail_page.dart<br>lib/about_page.dart |

---

## Fitur Aplikasi

1. Pencatatan Pengeluaran:
   - Pengguna dapat menginput nama keperluan, nominal biaya, dan kategori pengeluaran.
   - Waktu pencatatan (jam dan menit) disimpan secara otomatis.

2. Validasi Form:
   - Kolom nama keperluan, nominal, dan kategori wajib diisi sebelum data dapat disimpan.
   - Kolom nominal hanya menerima karakter angka dan wajib bernilai lebih dari Rp 0.

3. Perhitungan Total dan Status Anggaran Real-time:
   - Total pengeluaran harian terakumulasi otomatis saat data baru ditambahkan.
   - Aplikasi menampilkan status kondisi anggaran (Aman & Terkendali, Waspada Mendekati Batas, Melebihi Batas Harian) sesuai batas anggaran harian default (Rp 150.000).

4. Ringkasan dan Rincian Transaksi (DetailPage):
   - Data transaksi, total biaya, dan batas anggaran dikirim dari HomePage ke DetailPage melalui constructor.
   - Menghitung sisa anggaran harian (atau selisih kelebihan jika overbudget) dan rata-rata pengeluaran per transaksi.

5. Tata Letak Responsif (Portrait dan Landscape):
   - Mode Portrait: Tampilan satu kolom vertikal.
   - Mode Landscape: Tampilan dua kolom (kiri: form input; kanan: ringkasan dan riwayat).

6. Reset Data:
   - Mengosongkan form input dan menghapus seluruh catatan transaksi pada hari tersebut.

---

## Struktur Direktori Proyek

```plaintext
catatan_pengeluaran_uts/
├── android/                   # Konfigurasi platform Android, Gradle, dan AndroidManifest
├── assets/
│   └── images/
│       └── logo_dompet.png    # Berkas gambar logo aplikasi
├── lib/
│   ├── main.dart              # Titik masuk aplikasi dan konfigurasi tema Material 3
│   ├── expense_model.dart     # Model data PengeluaranItem dan fungsi formatRupiah()
│   ├── home_page.dart         # Halaman utama: form input, ringkasan, dan responsivitas
│   ├── detail_page.dart       # Halaman detail: penerima data via constructor dan evaluasi
│   └── about_page.dart        # Halaman informasi: profil pengembang dan deskripsi aplikasi
├── pubspec.yaml               # Konfigurasi dependensi dan registrasi folder aset
└── README.md                  # Dokumentasi laporan proyek
```

---
