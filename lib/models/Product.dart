import 'package:flutter/material.dart'; // Mengimpor package Material Design dari Flutter

// Mendefinisikan class `Product` yang akan menjadi model data produk
class Product {
  final int id; // ID unik produk
  final String title; // Nama atau judul produk
  final double price; // Harga produk
  final int size; // Ukuran produk
  final String description; // Deskripsi produk
  final String image; // Path gambar produk
  final Color color; // Warna produk

  // Constructor untuk menginisialisasi semua properti dari produk
  Product({
    required this.id, // Harus diisi ID produk
    required this.title, // Harus diisi nama produk
    required this.price, // Harus diisi harga produk
    required this.size, // Harus diisi ukuran produk
    required this.description, // Harus diisi deskripsi produk
    required this.image, // Harus diisi path gambar produk
    required this.color, // Harus diisi warna produk
  });

  // Method `copyWith` untuk membuat salinan produk dengan properti yang diperbarui
  Product copyWith({
    String? title, // Nama baru produk (opsional)
    double? price, // Harga baru produk (opsional)
    int? size, // Ukuran baru produk (opsional)
    String? description, // Deskripsi baru produk (opsional)
    String? image, // Gambar baru produk (opsional)
    Color? color, // Warna baru produk (opsional)
  }) {
    // Mengembalikan produk baru dengan properti yang diperbarui atau tetap
    return Product(
      id: id, // ID tetap
      title: title ?? this.title, // Jika `title` diisi, gunakan, jika tidak, gunakan `title` lama
      price: price ?? this.price, // Jika `price` diisi, gunakan, jika tidak, gunakan `price` lama
      size: size ?? this.size, // Jika `size` diisi, gunakan, jika tidak, gunakan `size` lama
      description: description ?? this.description, // Jika `description` diisi, gunakan, jika tidak, gunakan `description` lama
      image: image ?? this.image, // Jika `image` diisi, gunakan, jika tidak, gunakan `image` lama
      color: color ?? this.color, // Jika `color` diisi, gunakan, jika tidak, gunakan `color` lama
    );
  }
}

// Teks dummy untuk deskripsi produk
String dummyText = "Lorem Ipsum adalah teks contoh standar dalam industri percetakan.";

// Daftar produk yang berisi beberapa instance dari `Product`
List<Product> products = [
  Product(
    id: 1,
    title: "Office Code", // Nama produk
    price: 234, // Harga produk
    size: 12, // Ukuran produk
    description: dummyText, // Deskripsi produk
    image: "assets/images/bag_1.png", // Path gambar produk
    color: const Color(0xFF3D82AE), // Warna produk
  ),
  Product(
    id: 2,
    title: "Belt Bag",
    price: 234,
    size: 8,
    description: dummyText,
    image: "assets/images/bag_2.png",
    color: const Color(0xFFD3A984),
  ),
  Product(
    id: 3,
    title: "Hang Top",
    price: 234,
    size: 10,
    description: dummyText,
    image: "assets/images/bag_3.png",
    color: const Color(0xFF989493),
  ),
  Product(
    id: 4,
    title: "Old Fashion",
    price: 234,
    size: 11,
    description: dummyText,
    image: "assets/images/bag_4.png",
    color: const Color(0xFFE6B398),
  ),
  Product(
    id: 5,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_5.png",
    color: const Color(0xFFFB7883),
  ),
  Product(
    id: 6,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: const Color(0xFFAEAEAE),
  ),
];
