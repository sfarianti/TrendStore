import 'package:flutter/material.dart'; // Mengimpor paket Material untuk membuat antarmuka pengguna.
import '../../../constants.dart'; // Mengimpor file constants untuk akses ke nilai konstan `kDefaultPaddin`.
import '../../../models/product.dart'; // Mengimpor model `Product` untuk mengakses data produk.

class Description extends StatelessWidget { // Membuat widget stateless bernama `Description`.
  const Description({super.key, required this.product}); // Konstruktor dengan parameter `product` yang wajib.

  final Product product; // Mendeklarasikan variabel `product` bertipe `Product`.

  @override
  Widget build(BuildContext context) {
    return Padding( // Memberikan padding di sekitar teks.
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin), // Padding vertikal dengan nilai konstan.
      child: Text( // Menampilkan teks deskripsi produk.
        product.description, // Mengambil deskripsi dari properti `description` di `product`.
        style: const TextStyle(height: 1.5), // Mengatur tinggi baris teks untuk keterbacaan.
      ),
    );
  }
}
