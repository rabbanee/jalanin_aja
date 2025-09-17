import 'package:flutter/material.dart';

void main() {
  runApp(const JalaninAjaApp());
}

class JalaninAjaApp extends StatelessWidget {
  const JalaninAjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jalanin_Aja',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Anda bisa ganti dengan font favorit
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        title: Text(
          'Jalanin_Aja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Aksi saat ikon profil diklik
            },
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),

      // 2. Body Utama
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo, Mau ke mana hari ini?",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),

              // 3. Kartu Pencarian Utama
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Input palsu untuk tujuan
                      InkWell(
                        onTap: () {
                          // Aksi saat input tujuan diklik -> Buka halaman pencarian
                        },
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.blue),
                            SizedBox(width: 12.0),
                            Text(
                              "Cari tujuanmu...",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),

              // 4. Pilihan Layanan
              Text(
                "Pilih Layanan",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ServiceButton(
                    icon: Icons.two_wheeler,
                    label: 'Motor',
                    onTap: () {},
                  ),
                  ServiceButton(
                    icon: Icons.directions_car,
                    label: 'Mobil',
                    onTap: () {},
                  ),
                  ServiceButton(
                    icon: Icons.receipt_long, // contoh ikon lain
                    label: 'Tagihan',
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 24.0),

              // 5. Akses Cepat / Favorit
              Text(
                "Tujuan Favorit",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              ListTile(
                leading: Icon(Icons.home, color: Colors.blue),
                title: Text("Rumah"),
                subtitle: Text("Atur alamat rumahmu"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                onTap: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ],
          ),
        ),
      ),

      // 6. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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

// Widget kustom untuk tombol layanan agar lebih rapi
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
      borderRadius: BorderRadius.circular(12.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, size: 32.0, color: Colors.blue.shade800),
          ),
          SizedBox(height: 8.0),
          Text(label),
        ],
      ),
    );
  }
}
