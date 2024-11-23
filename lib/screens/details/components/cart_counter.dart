import 'package:flutter/material.dart'; // Mengimpor paket Material dari Flutter untuk komponen UI.

import '../../../constants.dart'; // Mengimpor file constants.dart untuk konstanta yang digunakan.

class CartCounter extends StatefulWidget { // Deklarasi widget Stateful untuk mengelola perubahan status.
  const CartCounter({super.key}); // Konstruktor untuk widget CartCounter.

  @override
  State<CartCounter> createState() => _CartCounterState(); // Membuat State untuk widget.
}

class _CartCounterState extends State<CartCounter> { // State untuk mengelola perubahan jumlah item.
  int numOfItems = 1; // Variabel untuk menyimpan jumlah item, dimulai dari 1.

  @override
  Widget build(BuildContext context) {
    return Row( // Mengembalikan widget Row untuk menampilkan elemen secara horizontal.
      children: <Widget>[
        SizedBox( // Membuat ukuran untuk tombol "kurangi".
          width: 40, // Lebar tombol.
          height: 32, // Tinggi tombol.
          child: OutlinedButton( // Tombol outline untuk mengurangi jumlah item.
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero, // Menghilangkan padding internal.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13), // Membuat sudut melengkung.
              ),
            ),
            onPressed: () { // Fungsi ketika tombol diklik.
              setState(() { // Memperbarui tampilan setelah mengurangi item.
                if (numOfItems > 1) { // Jika jumlah item lebih dari 1, kurangi 1.
                  numOfItems--;
                }
              });
            },
            child: const Icon(Icons.remove), // Ikon minus untuk tombol.
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2), // Menyisipkan jarak antar elemen.
          child: Text(
            numOfItems.toString().padLeft(2, "0"), // Menampilkan jumlah item dengan format 2 digit.
            style: Theme.of(context).textTheme.titleMedium, // Menggunakan gaya teks default.
          ),
        ),
        SizedBox( // Ukuran tombol untuk menambah item.
          width: 40, // Lebar tombol.
          height: 32, // Tinggi tombol.
          child: OutlinedButton( // Tombol outline untuk menambah jumlah item.
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero, // Menghilangkan padding internal.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13), // Membuat sudut melengkung.
              ),
            ),
            onPressed: () { // Fungsi ketika tombol tambah diklik.
              setState(() { // Memperbarui tampilan setelah menambah item.
                numOfItems++;
              });
            },
            child: const Icon(Icons.add), // Ikon tambah untuk tombol.
          ),
        ),
      ],
    );
  }
}
