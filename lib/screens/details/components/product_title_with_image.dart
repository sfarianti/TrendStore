import 'package:flutter/material.dart'; // Mengimpor paket Material untuk membangun UI Flutter.
import '../../../constants.dart'; // Mengimpor file konstan untuk nilai-nilai tetap seperti `kDefaultPaddin`.
import '../../../models/product.dart'; // Mengimpor model `Product` untuk mendefinisikan struktur produk.

class ProductTitleWithImage extends StatelessWidget { // Mendefinisikan widget stateless `ProductTitleWithImage`.
  const ProductTitleWithImage({super.key, required this.product}); // Konstruktor yang menerima objek `product`.

  final Product product; // Mendeklarasikan properti `product` dengan tipe `Product`.

  @override
  Widget build(BuildContext context) {
    return Padding( // Mengatur padding di sekitar kolom.
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin), // Padding horizontal dengan nilai konstan.
      child: Column( // Menggunakan kolom untuk menumpuk elemen secara vertikal.
        crossAxisAlignment: CrossAxisAlignment.start, // Mengatur perataan kolom ke kiri.
        children: <Widget>[ // Daftar widget anak dalam kolom.
          const Text( // Teks tetap yang menunjukkan nama produk.
            "Aristocratic Hand Bag",
            style: TextStyle(color: Colors.white), // Mengatur warna teks menjadi putih.
          ),
          Text( // Menampilkan judul produk yang diambil dari objek `product`.
            product.title,
            style: Theme.of(context) // Menggunakan tema aplikasi untuk styling.
                .textTheme
                .titleLarge! // Mengambil style judul besar.
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold), // Mengatur warna dan ketebalan font.
          ),
          const SizedBox(height: kDefaultPaddin), // Menambahkan ruang antara teks dan baris berikutnya.
          Row( // Menggunakan baris untuk menampilkan harga dan gambar produk.
            children: <Widget>[
              RichText( // Menggunakan RichText untuk menggabungkan teks biasa dan teks dengan styling.
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Price\n"), // Menampilkan label "Price".
                    TextSpan( // Menampilkan harga produk.
                      text: "\$${product.price}", // Mengambil harga dari objek `product`.
                      style: Theme.of(context) // Menggunakan tema aplikasi untuk styling harga.
                          .textTheme
                          .headlineSmall! // Mengambil style headline kecil.
                          .copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold), // Mengatur warna dan ketebalan font.
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPaddin), // Menambahkan ruang antara harga dan gambar.
              Expanded( // Membiarkan gambar mengambil ruang yang tersisa.
                child: Hero( // Menggunakan widget Hero untuk animasi transisi gambar.
                  tag: "${product.id}", // Menentukan tag unik untuk animasi hero.
                  child: Image.asset( // Menggunakan gambar aset untuk menampilkan gambar produk.
                    product.image, // Mengambil nama gambar dari objek `product`.
                    fit: BoxFit.fill, // Mengatur ukuran gambar untuk mengisi area yang tersedia.
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
