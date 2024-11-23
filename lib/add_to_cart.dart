import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToCart extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final String userId;

  const AddToCart({super.key, this.productData, required this.userId});

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  List<dynamic> cartItems = [];
  double total = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Memulai permintaan ke server...');
      final response = await http.get(
        Uri.parse(
            'https://fashionecommerce.laundryexpress.site/get_cart.php?user_id=${widget.userId}'),
      );

      print('Respons diterima dengan status code: ${response.statusCode}');
      print('Isi respons (body): ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print('Data yang diterima dari server: $data');

          if (data is List) {
            print('Data valid berupa List. Memproses data...');
            setState(() {
              cartItems = data.cast<Map<String, dynamic>>();
              print('Isi cartItems: $cartItems');

              total = cartItems.fold(
                0,
                (sum, item) {
                  print('Proses item: $item');
                  return sum + (item['price'] * item['quantity']);
                },
              );
              print('Total harga: $total');
              _isLoading = false;
            });
          } else {
            print('Data yang diterima bukan List.');
            _showError('Data yang diterima bukan dalam format list');
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          _showError('Gagal mengambil data keranjang. Silakan coba lagi.');
        }
      } else {
        print(
            'Server memberikan respons dengan status code: ${response.statusCode}');
        _showError(
            'Gagal mengambil data keranjang. Server memberikan respons: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data: $e');
      _showError('Terjadi kesalahan saat mengambil data keranjang: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
      print('Proses pengambilan data selesai.');
    }
  }

  Future<void> _removeItem(int index) async {
    final item = cartItems[index];
    try {
      final response = await http.post(
        Uri.parse(
            'https://fashionecommerce.laundryexpress.site/delete_from_cart.php'),
        body: {'cart_item_id': item['id'].toString()},
      );

      if (response.statusCode == 200) {
        setState(() {
          total -= cartItems[index]['price'] * cartItems[index]['quantity'];
          cartItems.removeAt(index);
        });
      } else {
        _showError(
            'Failed to remove item. Server responded with: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error removing item: $e');
    }
  }

  Future<void> _updateQuantity(int index, int newQuantity) async {
    final item = cartItems[index];
    try {
      final response = await http.put(
        Uri.parse(
            'https://fashionecommerce.laundryexpress.site/update_cart.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_item_id': item['id'],
          'quantity': newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems[index]['quantity'] = newQuantity;
          total = cartItems.fold(
            0,
            (sum, item) => sum + (item['price'] * item['quantity']),
          );
        });
      } else {
        _showError(
            'Failed to update quantity. Server responded with: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error updating quantity: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : cartItems.isEmpty
                    ? const Center(child: Text('Your cart is empty'))
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Card(
                            child: ListTile(
                              leading: item['image'] != null &&
                                      item['image'].isNotEmpty
                                  ? Image.memory(
                                      base64Decode(item['image']),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported),
                              title: Text(item['name']),
                              subtitle: Text(
                                  '\$${item['price']} x ${item['quantity']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (item['quantity'] > 1) {
                                        _updateQuantity(
                                            index, item['quantity'] - 1);
                                      }
                                    },
                                  ),
                                  Text(item['quantity'].toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      _updateQuantity(
                                          index, item['quantity'] + 1);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _removeItem(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
