import 'package:flutter/material.dart'; // Mengimpor paket Material untuk UI.
import 'package:flutter_svg/flutter_svg.dart'; // Mengimpor paket untuk menampilkan gambar SVG.

import 'cart_counter.dart'; // Mengimpor file `cart_counter.dart` yang berisi widget `CartCounter`.

class CounterWithFavBtn extends StatelessWidget { // Deklarasi widget stateless untuk counter dan tombol favorit.
  const CounterWithFavBtn({super.key}); // Konstruktor widget dengan key opsional.

  @override
  Widget build(BuildContext context) {
    return Row( // Mengembalikan Row untuk menampilkan elemen secara horizontal.
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mengatur spasi di antara elemen.
      children: <Widget>[
        const CartCounter(), // Menampilkan widget `CartCounter` untuk pengaturan jumlah item.
        Container( // Membuat kontainer untuk tombol favorit (ikon hati).
          padding: const EdgeInsets.all(8), // Memberikan padding di dalam kontainer.
          height: 32, // Tinggi kontainer.
          width: 32, // Lebar kontainer.
          decoration: const BoxDecoration( // Dekorasi kontainer dengan warna dan bentuk.
            color: Color(0xFFFF6464), // Warna latar belakang merah.
            shape: BoxShape.circle, // Bentuk lingkaran untuk kontainer.
          ),
          child: SvgPicture.asset("assets/icons/heart.svg"), // Menampilkan ikon hati (favorite) dari file SVG.
        )
      ],
    );
  }
}
