import 'package:flutter/material.dart'; // Mengimpor paket Material untuk komponen UI.

import '../../../constants.dart'; // Mengimpor file constants.dart untuk mengakses konstanta.
import '../../../models/product.dart'; // Mengimpor model `Product` yang berisi data produk.

class ColorAndSize extends StatelessWidget { // Deklarasi widget stateless untuk elemen warna dan ukuran.
  const ColorAndSize({super.key, required this.product}); // Konstruktor dengan parameter `product`.

  final Product product; // Mendeklarasikan variabel `product` bertipe `Product`.

  @override
  Widget build(BuildContext context) {
    return Row( // Mengembalikan Row untuk menampilkan elemen warna dan ukuran secara horizontal.
      children: <Widget>[
        const Expanded( // Expanded untuk memberikan lebar penuh pada kolom warna.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Mengatur posisi teks di awal (kiri).
            children: <Widget>[
              Text("Color"), // Menampilkan label "Color".
              Row( // Menyusun elemen warna secara horizontal.
                children: <Widget>[
                  ColorDot( // Widget bulatan warna.
                    color: Color(0xFF356C95), // Warna bulatan.
                    isSelected: true, // Menandakan warna ini terpilih.
                  ),
                  ColorDot( // Bulatan warna kedua.
                    color: Color(0xFFF8C078),
                    isSelected: true,
                  ),
                  ColorDot(color: Color(0xFFA29B9B), isSelected: false), // Bulatan warna ketiga, tidak terpilih.
                ],
              ),
            ],
          ),
        ),
        Expanded( // Bagian ukuran produk dengan gaya teks.
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: kTextColor), // Gaya teks untuk warna teks.
              children: [
                const TextSpan(text: "Size\n"), // Label "Size".
                TextSpan( // Menampilkan ukuran produk.
                  text: "${product.size} cm", // Mengambil ukuran dari objek `product`.
                  style: Theme.of(context) // Gaya teks untuk ukuran produk, ditampilkan tebal.
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ColorDot extends StatelessWidget { // Widget `ColorDot` untuk membuat titik warna.
  const ColorDot({super.key, required this.color, required this.isSelected}); // Konstruktor dengan warna dan status pemilihan.

  final Color color; // Warna dari titik.
  final bool isSelected; // Status apakah titik warna terpilih.

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( // Memberi margin atas dan kanan untuk titik warna.
        top: kDefaultPaddin / 4,
        right: kDefaultPaddin / 2,
      ),
      padding: const EdgeInsets.all(2.5), // Padding dalam titik warna.
      height: 24, // Tinggi titik warna.
      width: 24, // Lebar titik warna.
      decoration: BoxDecoration( // Dekorasi lingkaran titik.
        shape: BoxShape.circle, // Bentuk lingkaran.
        border: Border.all( // Menambahkan border lingkaran, tampil jika `isSelected` true.
          color: isSelected ? color : Colors.transparent,
        ),
      ),
      child: DecoratedBox( // Kotak dekorasi dengan warna.
        decoration: BoxDecoration(
          color: color, // Warna lingkaran sesuai parameter `color`.
          shape: BoxShape.circle, // Bentuk lingkaran.
        ),
      ),
    );
  }
}
