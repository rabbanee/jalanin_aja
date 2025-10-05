import 'dart:io';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'edit_profile.dart';
import 'settings_page.dart';
import 'pusat_bantuan.dart'; // import HelpCenterPage
import 'topup_page.dart'; // Import untuk halaman Top Up
import 'history_page.dart'; // Halaman Riwayat Pesanan
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String? imagePath;

  const ProfilePage({
    super.key,
    required this.fullName,
    required this.email,
    this.imagePath,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: imagePath != null
                  ? FileImage(File(imagePath!))
                  : const NetworkImage('https://i.pravatar.cc/150?img=32')
                        as ImageProvider,
            ),
            const SizedBox(height: 14),
            Text(
              fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
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

                  Navigator.pop(context, {
                    'fullName': fullName,
                    'email': email,
                    'profileImage': result['profileImage'],
                  });
                }
              },
              icon: const Icon(Icons.edit, size: 20),
              label: const Text("Edit Profil"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Divider(),

            // Menu Item BARU: Top Up Saldo
            _buildMenuItem(
              icon: Icons.account_balance_wallet,
              title: "Top Up Saldo",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TopUpPage()),
                );
              },
            ),

            // Menu Items Lama
            _buildMenuItem(
              icon: Icons.history,
              title: "Riwayat Pesanan",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.settings,
              title: "Pengaturan",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.lock,
              title: "Ganti Password",
              onTap: () {
                // Langsung ke halaman EditProfile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      fullName: fullName,
                      email: email,
                      imagePath: imagePath,
                    ),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Pusat Bantuan",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Divider(),
            _buildMenuItem(
              icon: Icons.logout,
              title: "Logout",
              textColor: Colors.red,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('logged_in_user_email'); // HAPUS SESI

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
