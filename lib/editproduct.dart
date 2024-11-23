import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> listData;

  const EditProduct({super.key, required this.listData});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  File? _image; // Declare _image as nullable
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Fill controllers with existing data
    productNameController.text = widget.listData['productname'];
    priceController.text = widget.listData['price'].toString();
    stockController.text = widget.listData['stock'].toString();
    detailController.text = widget.listData['detail'];
    sizeController.text = widget.listData['size'];
    typeController.text = widget.listData['type'];
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<bool> _edit() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://fashionecommerce.laundryexpress.site/edit.php'),
      );

      // Tambahkan data form
      request.fields['productname'] = productNameController.text;
      request.fields['price'] = priceController.text;
      request.fields['stock'] = stockController.text;
      request.fields['detail'] = detailController.text;
      request.fields['size'] = sizeController.text;
      request.fields['type'] = typeController.text;
      request.fields['product_id'] = widget.listData['product_id'].toString();

      // Jika ada gambar, tambahkan file gambar
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // Nama parameter di PHP
          _image!.path,
        ));
      }

      // Kirim request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        print('Response: $responseString');
        return true; // Berhasil
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Call the _pickImage method
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Choose image here",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_image != null) Image.file(_image!, height: 100, width: 100),
              const SizedBox(height: 20),
              TextFormField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Silakan masukkan nama produk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Silakan masukkan harga produk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Silakan masukkan jumlah stok';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: detailController,
                decoration: const InputDecoration(labelText: 'Detail'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Silakan masukkan detail produk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: sizeController,
                decoration: const InputDecoration(labelText: 'Size'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Silakan masukkan ukuran produk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Silakan masukkan jenis produk';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _edit().then((success) {
                      final snackBar = SnackBar(
                        content: Text(success
                            ? 'Produk berhasil diperbarui'
                            : 'Gagal memperbarui produk'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      if (success) {
                        // Update the listData with new values
                        setState(() {
                          widget.listData['productname'] =
                              productNameController.text;
                          widget.listData['price'] = priceController.text;
                          widget.listData['stock'] = stockController.text;
                          widget.listData['detail'] = detailController.text;
                          widget.listData['size'] = sizeController.text;
                          widget.listData['type'] = typeController.text;
                          // Optionally, if you want to update the image path as well, add this line:
                          if (_image != null) {
                            widget.listData['image'] =
                                _image!.path; // Update image path
                          }
                        });
                        Navigator.pop(context); // Navigate back after update
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set the background color
                  foregroundColor: Colors.white, // Set the text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  elevation: 0, // Remove elevation
                  side: BorderSide.none, // Remove border
                ),
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
