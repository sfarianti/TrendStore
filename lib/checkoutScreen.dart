import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/displayproducts.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> productData;
  final int quantity;
  final String userId;

  const CheckoutScreen({
    required this.productData,
    required this.quantity,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'Credit Card';
  String shippingAddress = "";
  String namaBank = ""; // Variabel untuk menyimpan nama bank
  String noRek = ""; // Variabel untuk menyimpan nomor rekening
  Map<String, dynamic>? selectedDiscount;
  List<Map<String, dynamic>> discounts = [];

  @override
  void initState() {
    super.initState();
    fetchDiscounts();
  }

  Future<void> fetchDiscounts() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      discounts = [
        {"id": 1, "description": "10% OFF", "percentage": 10},
        {"id": 2, "description": "15% OFF", "percentage": 15},
        {"id": 3, "description": "20% OFF", "percentage": 20},
      ];
    });
  }

  Future<void> submitOrderToDatabase(double finalPrice) async {
    const String apiUrl =
        "https://fashionecommerce.laundryexpress.site/addOrder.php";
    print("Sending user_id: ${widget.userId}");
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_id': widget.userId,
          'productname': widget.productData['productname'],
          'quantity': widget.quantity.toString(),
          'total_price': finalPrice.toStringAsFixed(2),
          'alamat_pengiriman': shippingAddress,
          'metode_pembayaran': selectedPaymentMethod,
          'discount': selectedDiscount?['description'] ?? 'No discount',
          'nama_bank': namaBank, // Kirimkan nama_bank
          'no_rek': noRek, // Kirimkan no_rek
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Order berhasil ditambahkan!")),
          );
          // Navigasi ke `DisplayProducts` dengan mengganti layar saat ini
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DisplayProducts(userId: widget.userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${responseData['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Gagal menghubungi server. Kode: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double price =
        double.tryParse(widget.productData['price'].toString()) ?? 0.0;
    double quantity = widget.quantity.toDouble();
    double totalPrice = quantity * price;
    double discountPercentage =
        (selectedDiscount?['percentage'] ?? 0).toDouble();
    double discountAmount = totalPrice * (discountPercentage / 100);
    double finalPrice = totalPrice - discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("User ID: ${widget.userId}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Order Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              buildOrderSummary(totalPrice, discountAmount, finalPrice),
              SizedBox(height: 20),
              Text("Shipping Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildShippingAddressField(),
              SizedBox(height: 20),
              Text("Select Discount",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildDiscountButton(),
              SizedBox(height: 20),
              Text("Payment Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildPaymentOptions(),
              SizedBox(height: 20),
              buildConfirmPurchaseButton(finalPrice),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderSummary(
      double totalPrice, double discountAmount, double finalPrice) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.productData['productname'] ?? "Product Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Quantity: ${widget.quantity}"),
              Text("\Rp${totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount:"),
              Text("-\Rp${discountAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total After Discount:"),
              Text("\Rp${finalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildShippingAddressField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          shippingAddress = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Enter your shipping address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget buildDiscountButton() {
    return ElevatedButton(
      onPressed: () => showDiscountSelectionDialog(),
      child: Text(selectedDiscount != null
          ? "Selected Discount: ${selectedDiscount!['description']}"
          : "Select Discount"),
    );
  }

  void showDiscountSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select a Discount"),
          content: discounts.isEmpty
              ? CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: discounts.map((discount) {
                    return ListTile(
                      title: Text(discount['description']),
                      onTap: () {
                        setState(() {
                          selectedDiscount = discount;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  Widget buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pilihan Credit Card
        RadioListTile<String>(
          title: Text("Credit Card"),
          value: 'Credit Card',
          groupValue: selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value!;
            });
          },
        ),
        // Pilihan Cash
        RadioListTile<String>(
          title: Text("Cash"),
          value: 'Cash',
          groupValue: selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value!;
            });
          },
        ),
        // Input untuk Credit Card
        if (selectedPaymentMethod == 'Credit Card') ...[
          TextField(
            decoration: InputDecoration(
              labelText: "Nama Bank",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                namaBank = value; // Menyimpan nilai nama bank
              });
            },
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "Nomor Rekening",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                noRek = value; // Menyimpan nilai nomor rekening
              });
            },
          ),
          SizedBox(height: 20),
          // Keterangan dan Barcode
          Text(
            "Transfer melalui barcode di bawah ini. Pastikan data sudah tepat semua. "
            "Jika ada kesalahan dan dana belum dikirim, maka pesanan tidak akan diproses. "
            "Data tidak dapat diubah setelah klik Konfirmasi. Jika ada kendala, hubungi "
            "+6285604667838 dengan melampirkan bukti.",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Center(
            child: Image.asset(
              'assets/images/barcode.jpeg', // Path ke gambar barcode
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
        // Keterangan untuk Cash
        if (selectedPaymentMethod == 'Cash') ...[
          SizedBox(height: 20),
          Text(
            "Silakan siapkan uang tunai yang sesuai dengan jumlah total pembelian Anda. "
            "Pembayaran akan dilakukan langsung pada saat pengantaran.",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.justify,
          ),
        ],
      ],
    );
  }

  Widget buildConfirmPurchaseButton(double finalPrice) {
    return SizedBox(
      width: double.infinity, // Memenuhi lebar layar
      child: ElevatedButton(
        onPressed: () {
          if (shippingAddress.isEmpty || namaBank.isEmpty || noRek.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please complete all fields")),
            );
          } else {
            submitOrderToDatabase(finalPrice);
          }
        },
        child: Text("Confirm Purchase"),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15), // Menambah tinggi tombol
          textStyle: TextStyle(fontSize: 16), // Menyesuaikan ukuran teks
        ),
      ),
    );
  }
}
