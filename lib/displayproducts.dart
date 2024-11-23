import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/dashboardadmin.dart';
import 'package:shop_app/productdetailapp.dart';

class DisplayProducts extends StatefulWidget {
  final String userId; // Tambahkan parameter userId

  const DisplayProducts({super.key, required this.userId});

  @override
  State<DisplayProducts> createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  List<dynamic> _listdata = [];
  List<dynamic> _filteredData = [];
  bool _isloading = true;
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'General',
    'Accessories',
    'Clothes',
    'Bag',
    'Shoes'
  ]; // Kategori "Others" telah dihapus

  @override
  void initState() {
    super.initState();
    _getData();
    _searchController.addListener(() {
      _filterProducts();
    });
  }

  Future<void> _getData() async {
    setState(() {
      _isloading = true;
    });

    // URL untuk setiap kategori
    String url;
    switch (_selectedCategoryIndex) {
      case 1:
        url =
            'https://fashionecommerce.laundryexpress.site/readAccessories.php';
        break;
      case 2:
        url = 'https://fashionecommerce.laundryexpress.site/readClothes.php';
        break;
      case 3:
        url = 'https://fashionecommerce.laundryexpress.site/readBag.php';
        break;
      case 4:
        url = 'https://fashionecommerce.laundryexpress.site/readShoes.php';
        break;
      default:
        url = 'https://fashionecommerce.laundryexpress.site/readGeneral.php';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _filteredData = data;
          _isloading = false;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isloading = false;
      });
    }
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _listdata.where((product) {
        final productName = product['productname']?.toLowerCase() ?? '';
        return productName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Categories'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Bagian Kategori
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              spacing: 8.0, // jarak antar tombol kategori
              children: List.generate(_categories.length, (index) {
                return ChoiceChip(
                  label: Text(_categories[index]),
                  selected: _selectedCategoryIndex == index,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategoryIndex = index;
                      _searchController
                          .clear(); // Kosongkan pencarian saat kategori berubah
                    });
                    _getData();
                  },
                  selectedColor: Colors.blue[100],
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: _selectedCategoryIndex == index
                        ? Colors.blue
                        : Colors.black,
                    fontWeight: _selectedCategoryIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }),
            ),
          ),

          // Bagian Pencarian
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Bagian Grid Produk
          Expanded(
            child: _isloading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  productData: {
                                    "product_id": _filteredData[index]
                                        ['product_id'],
                                    "productname": _filteredData[index]
                                        ['productname'],
                                    "price": _filteredData[index]['price'],
                                    "stock": _filteredData[index]['stock'],
                                    "size": _filteredData[index]['size'],
                                    "type": _filteredData[index]['type'],
                                    "image": _filteredData[index]['image'],
                                  },
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar Produk
                                _filteredData[index]['image'] != null &&
                                        _filteredData[index]['image'].isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.memory(
                                          base64Decode(
                                              _filteredData[index]['image']),
                                          width: double.infinity,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.image_not_supported),
                                const SizedBox(height: 8.0),

                                // Detail Produk
                                Text(
                                  _filteredData[index]['productname'] ??
                                      'No ProductName',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(_filteredData[index]['price'] ??
                                    'No Price'),
                                Text(_filteredData[index]['stock'] ??
                                    'No Stock'),
                                Text(_filteredData[index]['size'] ?? 'No Size'),
                                Text(_filteredData[index]['type'] ?? 'No Type'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Tombol Tambah Produk (Hanya muncul jika userId dimulai dengan "A")
      floatingActionButton: widget.userId.startsWith('A')
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellerPage()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, size: 30),
            )
          : null,
    );
  }
}
