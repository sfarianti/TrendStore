import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/addproduct.dart';
import 'package:shop_app/editproduct.dart';

class CrudProduct extends StatefulWidget {
  const CrudProduct({super.key});

  @override
  State<CrudProduct> createState() => _CrudProductState();
}

class _CrudProductState extends State<CrudProduct> {
  List<dynamic> _listdata = [];
  List<dynamic> _filteredList = [];
  bool _isloading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _getdata() async {
    try {
      final response = await http.get(
        Uri.parse('https://fashionecommerce.laundryexpress.site/read.php'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _filteredList = data; // Initialize filtered list with all data
          _isloading = false;
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isloading = false;
      });
    }
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredList = _listdata; // Show all products if query is empty
      });
    } else {
      setState(() {
        _filteredList = _listdata
            .where((product) => product['productname']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<bool> _delete(String id) async {
    try {
      final response = await http.post(
        Uri.parse('https://fashionecommerce.laundryexpress.site/delete.php'),
        body: {
          "productname": id,
        },
      );
      if (response.statusCode == 200) {
        // Reload data after deletion
        await _getdata(); // Refresh the data after deletion
        return true;
      } else {
        print('Failed to delete data');
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Your Product"),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: _isloading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduct(
                                  listData: {
                                    "id": _filteredList[index]['id'],
                                    "productname": _filteredList[index]
                                        ['productname'],
                                    "price": _filteredList[index]['price'],
                                    "stock": _filteredList[index]['stock'],
                                    "detail": _filteredList[index]['detail'],
                                    "size": _filteredList[index]['size'],
                                    "type": _filteredList[index]['type'],
                                    "image": _filteredList[index]['image'],
                                  },
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: _filteredList[index]['image'] != null &&
                                    _filteredList[index]['image'].isNotEmpty
                                ? Image.memory(
                                    base64Decode(_filteredList[index]['image']),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(
                              _filteredList[index]['productname'] ??
                                  'No ProductName',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_filteredList[index]['price'] ??
                                    'No Price'),
                                Text(_filteredList[index]['stock'] ??
                                    'No Stock'),
                                Text(_filteredList[index]['detail'] ??
                                    'No Detail'),
                                Text(_filteredList[index]['size'] ?? 'No Size'),
                                Text(_filteredList[index]['type'] ?? 'No Type'),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Are you sure to delete this product?"),
                                      actions: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(Icons.cancel),
                                          label: const Text("Cancel"),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _delete(_filteredList[index]
                                                    ['productname'])
                                                .then((isDeleted) {
                                              final snackBar = SnackBar(
                                                content: Text(isDeleted
                                                    ? "Deleting success"
                                                    : "Deleting failed"),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            });
                                          },
                                          icon: const Icon(Icons.delete),
                                          label: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
