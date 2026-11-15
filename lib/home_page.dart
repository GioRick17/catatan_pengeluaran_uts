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
