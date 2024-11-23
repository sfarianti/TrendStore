import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop_app/displayproducts.dart';
import 'package:shop_app/register.dart'; // Ganti impor ini sesuai dengan nama file yang berisi DisplayProducts

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _idController =
      TextEditingController(); // Controller untuk ID
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? userId; // Variabel untuk menyimpan userId

  Future<void> _login() async {
    const String url = 'https://fashionecommerce.laundryexpress.site/login.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': _idController.text, // Tambahkan ID ke permintaan API
          'nama': _nameController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['pesan'] == 'Login successful') {
          // Pastikan userId diterima dari respons
          if (data.containsKey('userId') && data['userId'] != null) {
            userId = data['userId'];

            // Navigasi ke halaman berikutnya dengan meneruskan userId
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayProducts(
                    userId: userId!), // Pastikan userId tidak null
              ),
            );
          } else {
            // Jika userId tidak ada atau null, tampilkan pesan error
            _showMessage('Login failed: User ID not found in response');
          }
        } else {
          _showMessage('Login failed: ${data['pesan']}');
        }
      } else {
        _showMessage('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showMessage('Login error: $e');
    }
  }

  // Fungsi untuk menampilkan pesan error menggunakan SnackBar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Mengganti logo dengan Icon
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.shopping_bag,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Log in to begin your shopping!',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge),
                  labelText: 'Enter your ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'What is your name?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Login to your account'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'New here? Register',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
