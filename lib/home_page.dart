import 'dart:io';
import 'package:flutter/material.dart';
import 'profile.dart';

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

  late String fullName;
  late String email;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    fullName = widget.fullName;
    email = widget.email;
    imagePath = widget.imagePath;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text("Cari tujuanmu...",
                        style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Pilih Layanan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ServiceButton(icon: Icons.two_wheeler, label: 'Motor', onTap: () {}),
              ServiceButton(icon: Icons.directions_car, label: 'Mobil', onTap: () {}),
              ServiceButton(icon: Icons.receipt_long, label: 'Tagihan', onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Tujuan Favorit",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text("Rumah"),
            subtitle: const Text("Atur alamat rumahmu"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Aktivitas'),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
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
    );
  }
}
