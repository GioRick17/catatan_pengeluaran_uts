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
