1. Struktur Folder Proyek Flutter
Susun struktur folder proyek di dalam direktori utama aplikasi (misalnya catatan_pengeluaran_uts/) seperti berikut agar modular, bersih, dan mudah dipresentasikan:

Plaintext
catatan_pengeluaran_uts/
├── assets/
│   └── images/
│       └── logo_dompet.png        # Gambar ikon/logo lokal aplikasi (opsional, sudah dilengkapi fallback Icon)
├── lib/
│   ├── main.dart                  # Entry point aplikasi & konfigurasi tema Material 3
│   ├── expense_model.dart         # Model data transaksi & fungsi helper format mata uang Rupiah
│   ├── home_page.dart             # Halaman 1: Form input, tombol aksi, ringkasan dinamis, & layout responsif
│   ├── detail_page.dart           # Halaman 2: Penerima data via constructor & kartu rincian pengeluaran
│   └── about_page.dart            # Halaman 3: Halaman statis (StatelessWidget) profil aplikasi & developer
└── pubspec.yaml                   # Konfigurasi dependensi & pendaftaran folder assets/images/

2. Kode Lengkap pubspec.yaml dan Seluruh File .dart
A. pubspec.yaml
Pastikan indentasi (spasi) pada bagian assets: sejajar tepat di bawah uses-material-design: true (2 spasi dari flutter:, dan 4 spasi untuk - assets/images/).

YAML
name: catatan_pengeluaran_uts
description: Aplikasi Catatan Pengeluaran Harian untuk Tugas Proyek UTS Pemrograman Mobile.
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true

  # Mendaftarkan folder aset gambar lokal agar dapat dipanggil menggunakan Image.asset()
  assets:
    - assets/images/
B. lib/main.dart
Dart
import 'package:flutter/material.dart';
import 'home_page.dart';

/// Fungsi main() adalah titik masuk (entry point) utama saat aplikasi dijalankan.
void main() {
  runApp(const AplikasiPengeluaranHarian());
}

/// Menggunakan StatelessWidget karena konfigurasi tema dan root aplikasi
/// bersifat statis dan tidak menyimpan state yang berubah-ubah.
class AplikasiPengeluaranHarian extends StatelessWidget {
  const AplikasiPengeluaranHarian({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner tulisan "DEBUG" di pojok kanan atas layar
      debugShowCheckedModeBanner: false,
      title: 'Catatan Pengeluaran Harian',
      // Menggunakan Material 3 dengan skema warna dasar Teal agar tampilan modern
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      // Menetapkan HomePage sebagai halaman pertama yang muncul saat aplikasi dibuka
      home: const HomePage(),
    );
  }
}
C. lib/expense_model.dart
Dart
/// Kelas model untuk merepresentasikan satu item transaksi pengeluaran.
/// Menggunakan model objek seperti ini memudahkan pengiriman kumpulan data
/// dari Halaman 1 (HomePage) ke Halaman 2 (DetailPage) melalui constructor.
class PengeluaranItem {
  final String namaKeperluan;
  final int nominal;
  final String kategori;
  final String waktuCatat;

  const PengeluaranItem({
    required this.namaKeperluan,
    required this.nominal,
    required this.kategori,
    required this.waktuCatat,
  });
}

/// Fungsi utilitas untuk memformat angka integer menjadi format mata uang Rupiah
/// (contoh: 25000 -> "Rp 25.000") tanpa memerlukan package eksternal tambahan
/// sehingga bebas risiko konflik versi dependensi saat build APK.
String formatRupiah(int nominal) {
  final String angka = nominal.abs().toString();
  final StringBuffer buffer = StringBuffer();
  int hitungDigit = 0;

  for (int i = angka.length - 1; i >= 0; i--) {
    buffer.write(angka[i]);
    hitungDigit++;
    if (hitungDigit % 3 == 0 && i != 0) {
      buffer.write('.');
    }
  }

  final String hasilTerformat = buffer.toString().split('').reversed.join();
  return nominal < 0 ? '-Rp $hasilTerformat' : 'Rp $hasilTerformat';
}
D. lib/home_page.dart
Dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'about_page.dart';
import 'detail_page.dart';
import 'expense_model.dart';

/// Menggunakan StatefulWidget karena halaman utama ini memiliki banyak interaksi
/// dinamis: input form, penambahan item pengeluaran, perhitungan total real-time,
/// serta tombol reset yang memperbarui tampilan layar melalui setState().
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GlobalKey digunakan untuk memvalidasi seluruh TextFormField di dalam Form sekaligus
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller untuk membaca dan mengosongkan teks pada masing-masing input field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  // State utama aplikasi: daftar transaksi dan batas anggaran harian default
  final List<PengeluaranItem> _daftarPengeluaran = [];
  final int _batasAnggaranHarian = 150000;

  // Getter untuk menghitung total pengeluaran secara dinamis dari daftar yang tersimpan
  int get _totalPengeluaran {
    int total = 0;
    for (final item in _daftarPengeluaran) {
      total += item.nominal;
    }
    return total;
  }

  // Getter untuk menentukan status hemat/boros berdasarkan persentase batas harian
  String get _statusKeuangan {
    if (_daftarPengeluaran.isEmpty) {
      return 'Belum Ada Transaksi';
    } else if (_totalPengeluaran <= _batasAnggaranHarian * 0.6) {
      return 'Aman & Terkendali';
    } else if (_totalPengeluaran <= _batasAnggaranHarian) {
      return 'Waspada Mendekati Batas';
    } else {
      return 'Melebihi Batas Harian!';
    }
  }

  // Getter warna indikator status agar perubahan kondisi langsung terlihat secara visual
  Color get _warnaStatus {
    if (_daftarPengeluaran.isEmpty) {
      return Colors.blueGrey;
    } else if (_totalPengeluaran <= _batasAnggaranHarian * 0.6) {
      return Colors.green.shade700;
    } else if (_totalPengeluaran <= _batasAnggaranHarian) {
      return Colors.orange.shade800;
    } else {
      return Colors.red.shade700;
    }
  }

  @override
  void dispose() {
    // Membersihkan controller dari memori ketika widget dihancurkan (mencegah memory leak)
    _namaController.dispose();
    _nominalController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  /// Fungsi untuk memvalidasi form, menyimpan item baru, dan memicu render ulang UI
  void _simpanPengeluaran() {
    // Mengecek apakah seluruh validator di TextFormField bernilai valid (null)
    if (_formKey.currentState!.validate()) {
      final String nama = _namaController.text.trim();
      final int nominal = int.parse(_nominalController.text.trim());
      final String kategori = _kategoriController.text.trim();

      // Mengambil jam & menit saat ini secara sederhana
      final DateTime sekarang = DateTime.now();
      final String jam = sekarang.hour.toString().padLeft(2, '0');
      final String menit = sekarang.minute.toString().padLeft(2, '0');

      // setState() memberi tahu Flutter bahwa data state berubah sehingga build()
      // dijalankan ulang untuk memperbarui total, status, dan daftar di layar.
      setState(() {
        _daftarPengeluaran.insert(
          0,
          PengeluaranItem(
            namaKeperluan: nama,
            nominal: nominal,
            kategori: kategori,
            waktuCatat: '$jam:$menit WIB',
          ),
        );
      });

      // Mengosongkan kembali kolom input setelah data berhasil disimpan
      _namaController.clear();
      _nominalController.clear();
      _kategoriController.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mencatat "$nama" (${formatRupiah(nominal)})'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.teal.shade700,
        ),
      );
    }
  }

  /// Fungsi untuk mereset seluruh input form dan menghapus riwayat pengeluaran harian
  void _resetSemuaData() {
    setState(() {
      _daftarPengeluaran.clear();
      _namaController.clear();
      _nominalController.clear();
      _kategoriController.clear();
    });
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua catatan pengeluaran dan input telah direset.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'DompetHarian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol navigasi menuju Halaman 3 (AboutPage) menggunakan Navigator.push
          IconButton(
            tooltip: 'Tentang Aplikasi',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ),
              );
            },
          ),
        ],
      ),
      // SafeArea menjaga tampilan tidak tertutup notch kamera atau status bar
      body: SafeArea(
        // OrientationBuilder mendeteksi orientasi layar perangkat secara otomatis
        // setiap kali layar diputar antara Portrait dan Landscape.
        child: OrientationBuilder(
          builder: (context, orientation) {
            final bool isPortrait = orientation == Orientation.portrait;

            if (isPortrait) {
              // ===============================================================
              // MODE PORTRAIT: Tersusun vertikal (atas ke bawah) memakai Column
              // dibungkus SingleChildScrollView agar dapat di-scroll saat keyboard muncul.
              // ===============================================================
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderBanner(isPortrait: true),
                    const SizedBox(height: 16),
                    _buildKartuRingkasan(),
                    const SizedBox(height: 16),
                    _buildKartuFormInput(),
                    const SizedBox(height: 16),
                    _buildDaftarTransaksiTerbaru(),
                  ],
                ),
              );
            } else {
              // ===============================================================
              // MODE LANDSCAPE: Layar dibagi menjadi 2 kolom kiri-kanan memakai Row
              // dan Expanded. Masing-masing sisi memiliki SingleChildScrollView
              // tersendiri untuk mencegah error RenderFlex overflow pada layar pendek.
              // ===============================================================
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolom Kiri (48% lebar): Form Input Pengeluaran
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: _buildKartuFormInput(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Kolom Kanan (52% lebar): Banner, Ringkasan Total, & Riwayat
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeaderBanner(isPortrait: false),
                            const SizedBox(height: 12),
                            _buildKartuRingkasan(),
                            const SizedBox(height: 12),
                            _buildDaftarTransaksiTerbaru(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /// Komponen Banner Header yang menampilkan aset gambar lokal (Image.asset)
  /// dan informasi mode orientasi aktif saat ini.
  Widget _buildHeaderBanner({required bool isPortrait}) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        children: [
          // Container pembungkus Image.asset dengan dekorasi lingkaran/sudut membulat
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            // Memuat gambar lokal dari folder assets/images/.
            // errorBuilder ditambahkan sebagai pengaman agar jika file PNG belum
            // ditaruh ke folder assets, aplikasi tetap tampil rapi memakai Icon.
            child: Image.asset(
              'assets/images/logo_dompet.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.teal.shade700,
                  size: 30,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan Pengeluaran Harian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPortrait
                      ? 'Tampilan Portrait (Susunan Vertikal)'
                      : 'Tampilan Landscape (2 Kolom Kiri-Kanan)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Komponen Kartu Ringkasan yang menampilkan total pengeluaran secara dinamis
  /// beserta tombol navigasi menuju Halaman 2 (DetailPage).
  Widget _buildKartuRingkasan() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pengeluaran Hari Ini',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_daftarPengeluaran.length} Item',
                  style: TextStyle(
                    color: Colors.teal.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Text dinamis menampilkan total uang yang diformat ke Rupiah
          Text(
            formatRupiah(_totalPengeluaran),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          // Badge status kondisi keuangan harian
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Status: $_statusKeuangan',
              style: TextStyle(
                color: _warnaStatus,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Tombol untuk berpindah ke Halaman 2 (DetailPage) sambil mengirimkan
          // data daftarPengeluaran, totalPengeluaran, dan batasAnggaranHarian via constructor.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal.shade800,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.receipt_long_rounded),
              label: const Text(
                'Lihat Ringkasan & Detail Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      daftarPengeluaran: List.unmodifiable(_daftarPengeluaran),
                      totalPengeluaran: _totalPengeluaran,
                      batasAnggaranHarian: _batasAnggaranHarian,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Komponen Form Input berisi 3 TextFormField dengan validasi serta tombol Simpan & Reset.
  Widget _buildKartuFormInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tambah Pengeluaran Baru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            // Input 1: Nama Pengeluaran / Keperluan
            TextFormField(
              controller: _namaController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nama Keperluan',
                hintText: 'Contoh: Makan Siang / Bensin',
                prefixIcon: const Icon(Icons.edit_note_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama keperluan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            // Input 2: Nominal Pengeluaran (hanya menerima digit angka)
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Nominal (Rp)',
                hintText: 'Contoh: 25000',
                prefixIcon: const Icon(Icons.payments_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nominal pengeluaran wajib diisi';
                }
                final int? angka = int.tryParse(value.trim());
                if (angka == null || angka <= 0) {
                  return 'Masukkan nominal lebih dari Rp 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            // Input 3: Kategori Pengeluaran
            TextFormField(
              controller: _kategoriController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Kategori',
                hintText: 'Contoh: Konsumsi, Transportasi, Tagihan',
                prefixIcon: const Icon(Icons.category_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Kategori tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Baris Tombol Aksi: Simpan (ElevatedButton) & Reset (OutlinedButton)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text(
                      'Simpan & Hitung',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _simpanPengeluaran,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reset'),
                    onPressed: _resetSemuaData,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Komponen Pratinjau Daftar Transaksi yang baru saja dicatat di halaman utama.
  Widget _buildDaftarTransaksiTerbaru() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Input Hari Ini',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          if (_daftarPengeluaran.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Belum ada pengeluaran yang dicatat. Silakan isi form di atas.',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            )
          else
            Column(
              children: _daftarPengeluaran.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        foregroundColor: Colors.teal.shade800,
                        child: const Icon(Icons.shopping_bag_outlined, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.namaKeperluan,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${item.kategori} • ${item.waktuCatat}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatRupiah(item.nominal),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
E. lib/detail_page.dart
Dart
import 'package:flutter/material.dart';
import 'expense_model.dart';

/// Halaman 2: DetailPage menggunakan StatelessWidget karena bertugas menampilkan
/// ringkasan dan rincian data yang dikirimkan dari HomePage melalui constructor.
class DetailPage extends StatelessWidget {
  final List<PengeluaranItem> daftarPengeluaran;
  final int totalPengeluaran;
  final int batasAnggaranHarian;

  // Constructor menerima parameter wajib yang dikirim saat Navigator.push dipanggil
  const DetailPage({
    super.key,
    required this.daftarPengeluaran,
    required this.totalPengeluaran,
    required this.batasAnggaranHarian,
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung sisa anggaran harian dan rata-rata per transaksi secara dinamis
    final int sisaAnggaran = batasAnggaranHarian - totalPengeluaran;
    final int rataRata = daftarPengeluaran.isEmpty
        ? 0
        : (totalPengeluaran ~/ daftarPengeluaran.length);

    final bool melebihiBatas = sisaAnggaran < 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Ringkasan & Detail Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kartu Ringkasan Utama menggunakan Container + BoxDecoration
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: melebihiBatas
                        ? Colors.red.shade300
                        : Colors.teal.shade200,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          melebihiBatas
                              ? Icons.warning_amber_rounded
                              : Icons.verified_rounded,
                          color: melebihiBatas
                              ? Colors.red.shade700
                              : Colors.teal.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            melebihiBatas
                                ? 'Evaluasi: Pengeluaran Overbudget'
                                : 'Evaluasi: Keuangan Harian Sehat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: melebihiBatas
                                  ? Colors.red.shade700
                                  : Colors.teal.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildBarisInfo(
                      label: 'Total Pengeluaran',
                      nilai: formatRupiah(totalPengeluaran),
                      warnaNilai: Colors.black87,
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    _buildBarisInfo(
                      label: 'Batas Anggaran Harian',
                      nilai: formatRupiah(batasAnggaranHarian),
                      warnaNilai: Colors.black54,
                    ),
                    const SizedBox(height: 8),
                    _buildBarisInfo(
                      label: melebihiBatas ? 'Selisih Kelebihan' : 'Sisa Anggaran',
                      nilai: formatRupiah(sisaAnggaran.abs()),
                      warnaNilai: melebihiBatas
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    _buildBarisInfo(
                      label: 'Rata-rata per Transaksi',
                      nilai: formatRupiah(rataRata),
                      warnaNilai: Colors.teal.shade800,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bagian Rincian Item yang Diterima dari Halaman 1
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rincian Transaksi (${daftarPengeluaran.length} Catatan)',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (daftarPengeluaran.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Data transaksi masih kosong. Silakan kembali ke halaman utama untuk menambahkan catatan pengeluaran.',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      )
                    else
                      Column(
                        children: List.generate(daftarPengeluaran.length, (index) {
                          final item = daftarPengeluaran[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.teal.shade700,
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.namaKeperluan,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Kategori: ${item.kategori} (${item.waktuCatat})',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatRupiah(item.nominal),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade900,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Navigator.pop(context) untuk menutup DetailPage dan kembali ke HomePage
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  'Kembali ke Halaman Utama',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget untuk menampilkan pasangan label dan nilai ringkasan secara rapi
  Widget _buildBarisInfo({
    required String label,
    required String nilai,
    required Color warnaNilai,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        Text(
          nilai,
          style: TextStyle(
            fontSize: 14,
            color: warnaNilai,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
F. lib/about_page.dart
Dart
import 'package:flutter/material.dart';

/// Halaman 3: AboutPage menggunakan StatelessWidget murni karena seluruh konten
/// di dalamnya bersifat statis (informasi aplikasi dan identitas pembuat).
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kartu Identitas Aplikasi
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal.shade100),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Menampilkan aset gambar lokal dengan fallback Icon jika file belum tersedia
                    Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/logo_dompet.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 42,
                            color: Colors.teal.shade700,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'DompetHarian v1.0',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aplikasi Catatan Pengeluaran Harian',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Aplikasi mobile Android berbasis Flutter yang dirancang untuk '
                      'membantu pencatatan pengeluaran harian secara cepat, memantau '
                      'batas anggaran, serta beradaptasi otomatis pada layar Portrait '
                      'maupun Landscape.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Kartu Profil Developer / Mahasiswa
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profil Developer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildItemProfil(
                      icon: Icons.person_outline_rounded,
                      judul: 'Nama Mahasiswa',
                      isi: 'Giovanni Ricky Agung Sanyoto',
                    ),
                    const SizedBox(height: 10),
                    _buildItemProfil(
                      icon: Icons.badge_outlined,
                      judul: 'NIM',
                      isi: '235411028',
                    ),
                    const SizedBox(height: 10),
                    _buildItemProfil(
                      icon: Icons.school_outlined,
                      judul: 'Program Studi & Kelas',
                      isi: 'Informatika (Kelas Karyawan) - UTDI',
                    ),
                    const SizedBox(height: 10),
                    _buildItemProfil(
                      icon: Icons.assignment_outlined,
                      judul: 'Keterangan Proyek',
                      isi: 'Proyek Ujian Tengah Semester (UTS) Pemrograman Mobile',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Navigator.pop(context) untuk kembali ke halaman sebelumnya
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal.shade800,
                  side: BorderSide(color: Colors.teal.shade700),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  'Kembali',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget untuk menampilkan baris detail informasi developer
  Widget _buildItemProfil({
    required IconData icon,
    required String judul,
    required String isi,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.teal.shade700),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                isi,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
3. Panduan Eksekusi di Android Studio & GitHub
A. Menyiapkan Aset Gambar & Menjalankan di Android Emulator
Pada panel Project di Android Studio (ubah tampilan dropdown kiri atas dari Android ke Project), klik kanan folder utama proyek -> New > Directory -> ketik assets/images.

Simpan file gambar ikon .png (misalnya logo_dompet.png) ke dalam folder assets/images/. (Catatan: Jika belum sempat memasukkan file PNG, aplikasi tetap berjalan aman tanpa error karena kode Image.asset sudah dilengkapi errorBuilder ke ikon dompet).

Buka pubspec.yaml, sesuaikan isinya dengan kode di atas, lalu klik Pub get di bilah notifikasi atas editor (atau jalankan flutter pub get di tab Terminal).

Pilih perangkat virtual pada toolbar atas Android Studio (misal Pixel 7 API 34), lalu klik tombol Run (▶) atau tekan Shift + F10.

B. Cara Memutar Layar Emulator (Portrait ke Landscape) untuk Screenshot
Pastikan fitur Auto-rotate pada sistem Android Emulator aktif: tarik bilah notifikasi (Quick Settings) dari atas layar Emulator ke bawah, lalu pastikan ikon Auto-rotate dalam keadaan menyala.

Klik ikon Rotate Left atau Rotate Right pada toolbar samping jendela Emulator (atau tekan pintasan keyboard Ctrl + Left Arrow / Ctrl + Right Arrow di Windows/Linux, dan Cmd + Left Arrow / Cmd + Right Arrow di macOS).

OrientationBuilder pada HomePage akan langsung mengubah susunan UI dari 1 kolom vertikal (Portrait) menjadi 2 kolom kiri-kanan (Landscape) tanpa me-reset data yang sudah diinput.

C. Cara Melakukan Build APK
Melalui Menu GUI Android Studio:

Klik menu Build > Flutter > Build APK.

Tunggu proses kompilasi Gradle selesai. Setelah muncul notifikasi "Built build/app/outputs/flutter-apk/app-release.apk", klik tautan locate untuk langsung membuka folder file .apk yang siap diinstal di HP Android atau dikumpulkan.

Melalui Terminal Android Studio (Alternatif Cepat):

Bash
flutter clean
flutter pub get
flutter build apk --release
File hasil build berada di: build/app/outputs/flutter-apk/app-release.apk.

D. Urutan Perintah Git untuk Push ke GitHub
Buka tab Terminal di bagian bawah Android Studio, lalu jalankan perintah berikut secara berurutan (ganti <URL_REPOSITORY_GITHUB_ANDA> dengan link repo GitHub yang sudah dibuat):

Bash
git init
git add .
git commit -m "feat: implementasi aplikasi catatan pengeluaran harian UTS Flutter"
git branch -M main
git remote add origin https://github.com/GioRick17/catatan_pengeluaran_uts
git push -u origin main
4. Rangkuman Alur Kode (Code Flow) untuk Presentasi
Inisialisasi Aplikasi (main.dart & expense_model.dart): Saat aplikasi dibuka, fungsi main() menjalankan widget AplikasiPengeluaranHarian (StatelessWidget) yang mengatur tema Material 3 berwarna dasar Teal dan memuat HomePage sebagai layar awal. Seluruh transaksi yang dicatat nantinya dibungkus ke dalam objek model PengeluaranItem dan diformat menggunakan fungsi formatRupiah() agar konsisten di seluruh halaman.

Halaman 1 — Input & Responsivitas (home_page.dart): HomePage menggunakan StatefulWidget karena menyimpan daftar transaksi _daftarPengeluaran yang terus bertambah secara dinamis. Ketika pengguna mengisi ketiga TextFormField dan menekan Simpan & Hitung, _formKey memvalidasi agar tidak ada kolom kosong atau nominal nol, lalu memanggil setState() untuk menambahkan item ke list sehingga Text total pengeluaran dan status anggaran langsung ter-update di layar. Untuk responsivitas, OrientationBuilder memeriksa orientasi layar: jika Portrait maka seluruh komponen disusun vertikal menggunakan Column, sedangkan jika Landscape layar dibelah dua secara horizontal menggunakan Row dan Expanded (form di kiri, ringkasan serta riwayat di kanan).

Halaman 2 — Pengiriman Data & Ringkasan (detail_page.dart): Ketika tombol Lihat Ringkasan & Detail Data ditekan, HomePage memanggil Navigator.push dengan MaterialPageRoute dan mengirimkan _daftarPengeluaran, _totalPengeluaran, serta _batasAnggaranHarian melalui parameter constructor DetailPage. Di halaman ini, data diolah menjadi evaluasi sisa anggaran dan rata-rata per transaksi di dalam Container berdekorasi, serta menyediakan tombol Kembali ke Halaman Utama yang memanggil Navigator.pop(context) untuk menutup halaman dan kembali ke HomePage.

Halaman 3 — Informasi Statis (about_page.dart): Saat pengguna menekan ikon info (i) di pojok kanan atas AppBar, Navigator.push mengarahkan tampilan ke AboutPage yang dibangun murni dengan StatelessWidget karena isinya statis. Halaman ini menampilkan logo lokal dari Image.asset beserta deskripsi aplikasi dan profil developer, lalu menyediakan tombol Kembali yang mengeksekusi Navigator.pop(context).