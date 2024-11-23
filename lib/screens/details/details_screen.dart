import 'package:flutter/material.dart'; // Mengimpor paket Material untuk membangun UI Flutter.
import 'package:flutter_svg/svg.dart'; // Mengimpor paket untuk menggunakan gambar SVG.

import '../../constants.dart'; // Mengimpor file konstan untuk nilai-nilai tetap seperti `kDefaultPaddin`.
import '../../models/product.dart'; // Mengimpor model `Product` untuk mendefinisikan struktur produk.
import 'components/add_to_cart.dart'; // Mengimpor widget untuk menambahkan produk ke keranjang.
import 'components/color_and_size.dart'; // Mengimpor widget untuk memilih warna dan ukuran produk.
import 'components/counter_with_fav_btn.dart'; // Mengimpor widget untuk menghitung jumlah produk dan tombol favorit.
import 'components/description.dart'; // Mengimpor widget untuk menampilkan deskripsi produk.
import 'components/product_title_with_image.dart'; // Mengimpor widget untuk menampilkan judul dan gambar produk.

class DetailsScreen extends StatelessWidget { // Mendefinisikan widget stateless `DetailsScreen`.
  const DetailsScreen({super.key, required this.product}); // Konstruktor yang menerima objek `product`.

  final Product product; // Mendeklarasikan properti `product` dengan tipe `Product`.

  @override
  Widget build(BuildContext context) { // Metode untuk membangun tampilan widget.
    final Size size = MediaQuery.of(context).size; // Mendapatkan ukuran layar perangkat.
    return Scaffold( // Menggunakan widget Scaffold untuk struktur dasar halaman.
      backgroundColor: product.color, // Mengatur warna latar belakang sesuai dengan warna produk.
      appBar: AppBar( // Membuat AppBar di bagian atas layar.
        backgroundColor: product.color, // Mengatur warna AppBar sesuai warna produk.
        elevation: 0, // Menghilangkan bayangan AppBar.
        leading: IconButton( // Tombol kembali di sebelah kiri AppBar.
          icon: SvgPicture.asset( // Menggunakan gambar SVG untuk ikon kembali.
            'assets/icons/back.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), // Mengatur warna ikon menjadi putih.
          ),
          onPressed: () => Navigator.pop(context), // Menutup halaman saat tombol diklik.
        ),
        actions: <Widget>[ // Menambahkan ikon di sebelah kanan AppBar.
          IconButton(
            icon: SvgPicture.asset("assets/icons/search.svg"), // Ikon pencarian.
            onPressed: () {}, // Fungsi saat ikon diklik (belum diimplementasikan).
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/cart.svg"), // Ikon keranjang belanja.
            onPressed: () {}, // Fungsi saat ikon diklik (belum diimplementasikan).
          ),
          const SizedBox(width: kDefaultPaddin / 2) // Ruang antara ikon.
        ],
      ),
      body: SingleChildScrollView( // Membuat tampilan dapat digulir.
        child: Column( // Menggunakan kolom untuk menumpuk elemen secara vertikal.
          children: <Widget>[ // Daftar widget anak dalam kolom.
            SizedBox( // Membuat ukuran khusus untuk konten.
              height: size.height, // Mengatur tinggi sesuai ukuran layar.
              child: Stack( // Menggunakan stack untuk menempatkan elemen bertumpuk.
                children: <Widget>[
                  Container( // Kontainer untuk tampilan bagian bawah.
                    margin: EdgeInsets.only(top: size.height * 0.3), // Mengatur margin atas untuk kontainer.
                    padding: EdgeInsets.only(
                      top: size.height * 0.12, // Padding atas untuk konten di dalam kontainer.
                      left: kDefaultPaddin, // Padding kiri.
                      right: kDefaultPaddin, // Padding kanan.
                    ),
                    decoration: const BoxDecoration( // Mengatur dekorasi untuk kontainer.
                      color: Colors.white, // Mengatur warna latar belakang menjadi putih.
                      borderRadius: BorderRadius.only( // Mengatur sudut kontainer.
                        topLeft: Radius.circular(24), // Sudut kiri atas melengkung.
                        topRight: Radius.circular(24), // Sudut kanan atas melengkung.
                      ),
                    ),
                    child: Column( // Menggunakan kolom untuk menampilkan elemen di dalam kontainer.
                      children: <Widget>[
                        ColorAndSize(product: product), // Widget untuk memilih warna dan ukuran produk.
                        const SizedBox(height: kDefaultPaddin / 2), // Ruang antara elemen.
                        Description(product: product), // Widget untuk menampilkan deskripsi produk.
                        const SizedBox(height: kDefaultPaddin / 2), // Ruang antara elemen.
                        const CounterWithFavBtn(), // Widget untuk menghitung produk dan tombol favorit.
                        const SizedBox(height: kDefaultPaddin / 2), // Ruang antara elemen.
                        AddToCart(product: product) // Widget untuk menambahkan produk ke keranjang.
                      ],
                    ),
                  ),
                  ProductTitleWithImage(product: product) // Widget untuk menampilkan judul dan gambar produk di atas.
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
