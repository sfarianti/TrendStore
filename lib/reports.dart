import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<dynamic> _orderData = [];
  List<dynamic> _filteredData = []; // Data yang sudah difilter
  bool _isLoading = true;

  // Fungsi untuk mengambil data dari API
  Future<void> _fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('https://fashionecommerce.laundryexpress.site/readOrder.php'),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          // Parse JSON hanya jika tipe konten adalah application/json
          try {
            final data = jsonDecode(response.body);

            // Memastikan bahwa data yang diterima adalah List
            if (data is List) {
              setState(() {
                _orderData = data; // Menyimpan data dan mengupdate tampilan
                _filteredData =
                    data; // Inisialisasi data filter dengan data lengkap
                _isLoading = false;
              });

              print('Data fetched: $_orderData');
            } else {
              print('Unexpected data format: $data');
              setState(() {
                _isLoading = false;
              });
            }
          } catch (e) {
            print("Error parsing JSON: $e");
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          print("Unexpected content type: ${response.headers['content-type']}");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Failed to load orders with status: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk memfilter data berdasarkan kata kunci pencarian
  void _filterOrders(String query) {
    if (query.isEmpty) {
      // Jika kolom pencarian kosong, tampilkan semua data
      setState(() {
        _filteredData = _orderData;
      });
    } else {
      setState(() {
        _filteredData = _orderData.where((order) {
          // Gabungkan semua kolom yang relevan ke dalam satu string
          final combinedData = [
            order['id_order']?.toString() ?? '',
            order['tgl_order'] ?? '',
            order['productname'] ?? '',
            order['quantity']?.toString() ?? '',
            order['total_price']?.toString() ?? '',
            order['metode_pembayaran'] ?? '',
            order['discount']?.toString() ?? '',
            order['alamat_pengiriman'] ?? '',
            order['user_id']?.toString() ?? '',
            order['product_id']?.toString() ?? ''
          ].join(' ').toLowerCase();

          // Periksa apakah kata kunci ada di data gabungan
          return combinedData.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Memanggil fungsi fetch data saat pertama kali tampilan dibuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: const Text(
          'Reports',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button action
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Membolehkan pengguliran vertikal
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Sold',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged:
                      _filterOrders, // Panggil _filterOrders saat teks berubah
                  decoration: const InputDecoration(
                    hintText: 'Search here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header tetap berada pada satu baris
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 150, child: Text('Order ID')),
                    SizedBox(width: 150, child: Text('Order Date')),
                    SizedBox(width: 150, child: Text('Product Name')),
                    SizedBox(width: 150, child: Text('Quantity')),
                    SizedBox(width: 150, child: Text('Total Price')),
                    SizedBox(width: 150, child: Text('Payment Method')),
                    SizedBox(width: 150, child: Text('Discount')),
                    SizedBox(width: 150, child: Text('Shipping Address')),
                    SizedBox(width: 150, child: Text('User ID')),
                    SizedBox(
                        width: 150,
                        child: Text('Bank Name')), // Kolom Bank Name
                    SizedBox(
                        width: 150,
                        child: Text('Account No')), // Kolom Account No
                  ],
                ),
              ),
              const Divider(thickness: 1),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredData.isEmpty
                      ? const Center(child: Text("Product Sold is empty"))
                      : ListView.builder(
                          shrinkWrap:
                              true, // Membatasi ukuran ListView agar tidak scrollable secara vertical
                          itemCount: _filteredData.length,
                          itemBuilder: (context, index) {
                            final order = _filteredData[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['id_order']?.toString() ??
                                                'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child:
                                            Text(order['tgl_order'] ?? 'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['productname'] ?? 'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['quantity']?.toString() ??
                                                'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['total_price']?.toString() ??
                                                'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['metode_pembayaran'] ??
                                                'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['discount']?.toString() ??
                                                'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['alamat_pengiriman'] ??
                                                'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(
                                            order['user_id']?.toString() ??
                                                'N/A')),
                                    SizedBox(
                                        width: 150,
                                        child: Text(order['nama_bank'] ??
                                            'N/A')), // Menampilkan nama bank
                                    SizedBox(
                                        width: 150,
                                        child: Text(order['no_rek'] ??
                                            'N/A')), // Menampilkan nomor rekening
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
