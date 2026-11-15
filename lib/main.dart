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
