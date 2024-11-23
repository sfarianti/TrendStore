import 'package:flutter/material.dart'; // Mengimpor package Material dari Flutter untuk mendukung komponen UI
import 'package:shop_app/dashboard.dart';
import 'constants.dart'; // Mengimpor file 'constants.dart' yang mungkin berisi konstanta-konstanta yang digunakan dalam aplikasi
// Mengimpor file 'home_screen.dart' yang kemungkinan berisi tampilan utama aplikasi

void main() {
  runApp(
      const MyApp()); // Fungsi main untuk menjalankan aplikasi Flutter dan memanggil widget MyApp
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); // Konstruktor untuk MyApp, menandakan bahwa kelas ini adalah stateless widget

  // Widget utama (root) aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Menghilangkan label debug di pojok aplikasi
      title:
          'The Flutter Way', // Judul aplikasi, akan muncul saat multitasking di perangkat
      theme: ThemeData(
        // Mengatur tema aplikasi
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor:
                kTextColor), // Menerapkan warna teks dari 'kTextColor' yang didefinisikan di 'constants.dart'
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Mengatur kepadatan visual agar responsif di berbagai platform
      ),
      home:
          const Dashboard(), // Menetapkan 'HomeScreen' sebagai halaman utama saat aplikasi dibuka
    );
  }
}
