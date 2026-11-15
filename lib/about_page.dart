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
