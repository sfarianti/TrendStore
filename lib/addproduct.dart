import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/crudproduct.dart'; // Sesuaikan dengan path file CrudProduct Anda

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController productName = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final TextEditingController size = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController caption = TextEditingController();
  File? _image; // Variable for storing the selected image

  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        caption.text = pickedFile.path.split('/').last; // Display the file name
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<bool> _add() async {
    if (_image == null) {
      // Show an error message if no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose an image')),
      );
      return false;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://fashionecommerce.laundryexpress.site/create.php'), // Sesuaikan URL sesuai server Anda
      );

      request.fields['productname'] = productName.text;
      request.fields['price'] = price.text;
      request.fields['stock'] = stock.text;
      request.fields['detail'] = detail.text;
      request.fields['size'] = size.text;
      request.fields['type'] = type.text;

      // Menambahkan file gambar ke request
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Nama parameter untuk gambar di sisi server PHP
        _image!.path,
      ));

      // Kirim request ke server dan tunggu respons
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        print('Response: $responseString');
        return true; // Return true jika berhasil
      } else {
        final responseString = await response.stream.bytesToString();
        print('Failed with status code: ${response.statusCode}');
        print('Error response: $responseString');
      }
    } catch (e) {
      print('Error adding product: $e'); // Menampilkan error jika ada masalah
    }
    return false; // Return false jika gagal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _chooseImage,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: caption,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Choose image here",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_image != null)
                  Image.file(_image!, height: 100, width: 100),
                const SizedBox(height: 20),
                TextFormField(
                  controller: productName,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Product name cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: price,
                  decoration: InputDecoration(
                    hintText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Price cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: stock,
                  decoration: InputDecoration(
                    hintText: "Stock",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Stock cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: detail,
                  decoration: InputDecoration(
                    hintText: "Detail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Detail cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: size,
                  decoration: InputDecoration(
                    hintText: "Size",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Size cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: type,
                  decoration: InputDecoration(
                    hintText: "Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Type cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _add().then((success) {
                        final snackBar = SnackBar(
                          content: Text(
                            success
                                ? 'Product successfully added'
                                : 'Failed to add product',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        if (success) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CrudProduct(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
