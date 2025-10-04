import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'checkout_page.dart';

import 'profile.dart';
import 'map_page.dart';
import 'topup_page.dart'; // <<< BARIS BARU: Import TopUpPage

class HomePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String? imagePath;

  const HomePage({
    super.key,
    required this.fullName,
    required this.email,
    this.imagePath,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  late String fullName;
  late String email;
  String? imagePath;

  int _walletBalance = 150000;

  final List<Map<String, dynamic>> _quickDestinations = [
    {
      'label': 'Rumah',
      'icon': Icons.home,
      'latLng': const LatLng(-6.2001, 106.8166),
      'serviceType': 'motor',
    },
    {
      'label': 'Kantor',
      'icon': Icons.work,
      'latLng': const LatLng(-6.1754, 106.8270),
      'serviceType': 'mobil',
    },
    {
      'label': 'Titik Baru',
      'icon': Icons.pin_drop,
      'latLng': const LatLng(-6.2208, 106.8055),
      'serviceType': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    fullName = widget.fullName;
    email = widget.email;
    imagePath = widget.imagePath;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildWalletCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dompet Jalanin Aja",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Rp $_walletBalance",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TopUpPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("Top Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Halo, Mau ke mana hari ini?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          _buildWalletCard(),
          TextFormField(
            controller: _searchController,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchMapPage()),
              );
            },
            decoration: InputDecoration(
              hintText: "Cari tujuanmu...",
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (query) {},
          ),
          const SizedBox(height: 12),
          const Text(
            "Pencarian Cepat",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _quickDestinations.map((dest) {
              return ActionChip(
                avatar: Icon(
                  dest['icon'],
                  size: 18,
                  color: Colors.blue.shade800,
                ),
                label: Text(dest['label']),
                onPressed: () {
                  if (dest['serviceType'] == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Pilih lokasi ${dest['label']} di peta!"),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchMapPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          selectedLocation: dest['latLng'],
                          serviceType: dest['serviceType'],
                        ),
                      ),
                    );
                  }
                },
                backgroundColor: Colors.blue.shade50,
                labelStyle: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(color: Colors.blue.shade200),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            "Pilih Layanan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              ServiceButton(
                icon: Icons.two_wheeler,
                label: 'Motor',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SearchMapPage(serviceType: "motor"),
                    ),
                  );
                },
              ),
              ServiceButton(
                icon: Icons.directions_car,
                label: 'Mobil',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SearchMapPage(serviceType: "mobil"),
                    ),
                  );
                },
              ),
              ServiceButton(
                icon: Icons.local_shipping,
                label: 'Kirim Barang',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SearchMapPage(serviceType: "kurir"),
                    ),
                  );
                },
              ),
              ServiceButton(
                icon: Icons.emergency,
                label: 'Layanan Darurat',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SearchMapPage(serviceType: "darurat"),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePageContent(),
      const Center(child: Text('Halaman Aktivitas')),
      ProfilePage(fullName: fullName, email: email, imagePath: imagePath),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jalanin_Aja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: imagePath != null
                  ? FileImage(File(imagePath!))
                  : const NetworkImage('https://i.pravatar.cc/150?img=32')
                        as ImageProvider,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    fullName: fullName,
                    email: email,
                    imagePath: imagePath,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  fullName = result['fullName'];
                  email = result['email'];
                  imagePath = result['profileImage']?.path;
                });
              }
            },
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Aktivitas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ServiceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 16.0 * 2;
    final spacing = 16.0;
    final itemWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return SizedBox(
      width: itemWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              width: itemWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.blue.shade800),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
