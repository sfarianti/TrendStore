import 'package:flutter/material.dart';
import 'package:shop_app/crudproduct.dart';
import 'package:shop_app/reports.dart'; // Assuming you have a Reports page

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40), // Adjust the top padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              height: 50, // Height for better visibility
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CrudProduct(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text('Manage Product'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 350,
              height: 50, // Match height for both buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Reports(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text('Reports'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
