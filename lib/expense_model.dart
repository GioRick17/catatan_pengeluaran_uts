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
