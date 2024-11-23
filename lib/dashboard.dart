import 'package:flutter/material.dart';
import 'package:shop_app/login.dart';

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> recentlyAddedItems = [
    {'name': 'Hand Bag', 'imagePath': 'assets/iconhome/bag.png'},
    {'name': 'Sports Shoes', 'imagePath': 'assets/iconhome/shoes.png'},
    {'name': 'T-Shirt', 'imagePath': 'assets/iconhome/tshirt.png'},
  ];

  final List<Map<String, String>> youMightLoveItems = [
    {'name': 'Watch', 'imagePath': 'assets/iconhome/watch.png'},
    {'name': 'Nirvana T-Shirt', 'imagePath': 'assets/iconhome/tshirt2.png'},
    {'name': 'Heels', 'imagePath': 'assets/iconhome/heels.png'},
  ];

  final List<Map<String, dynamic>> categoryItems = [
    {'name': 'Accessories', 'icon': Icons.accessibility},
    {'name': 'Clothes', 'icon': Icons.checkroom},
    {'name': 'Bag', 'icon': Icons.work},
    {'name': 'Shoes', 'icon': Icons.shop},
    {'name': 'Others', 'icon': Icons.more_horiz},
  ];

  List<Map<String, dynamic>> filteredCategoryItems = [];

  @override
  void initState() {
    super.initState();
    filteredCategoryItems = categoryItems;
    _searchController.addListener(_performSearch);
  }

  void _performSearch() {
    String searchText = _searchController.text.toLowerCase();

    setState(() {
      if (searchText.isEmpty) {
        // Jika pencarian kosong, tampilkan semua ikon
        filteredCategoryItems = categoryItems;
      } else {
        // Filter ikon berdasarkan pencarian
        filteredCategoryItems = categoryItems
            .where((item) => item['name']!.toLowerCase().contains(searchText))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildCategoryGrid(),
            const SizedBox(height: 20),
            const Text(
              "Recently Added",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildItemRow(recentlyAddedItems), // Tidak berubah
            const SizedBox(height: 20),
            const Text(
              "You might love",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildItemRow(youMightLoveItems), // Tidak berubah
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blueAccent),
            onPressed: _performSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      crossAxisCount: 3, // Mengatur grid menjadi 3 kolom agar lebih rapi
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: filteredCategoryItems.map((item) {
        return _buildCategoryButton(item['icon'], item['name'], () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
      }).toList(),
    );
  }

  Widget _buildCategoryButton(
      IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blueAccent[100],
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(List<Map<String, String>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          items.map((item) => _buildItemCard(item['imagePath']!)).toList(),
    );
  }

  Widget _buildItemCard(String imagePath) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
