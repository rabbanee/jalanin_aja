import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // Ubah Profil
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blueAccent),
            title: const Text("Ubah Profil"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman edit profil
              Navigator.pushNamed(context, '/editProfile');
            },
          ),
          const Divider(),

          // Ganti Password
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.blueAccent),
            title: const Text("Ganti Password"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman ganti password
              Navigator.pushNamed(context, '/editPassword');
            },
          ),
          const Divider(),

          // Notifikasi
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blueAccent),
            title: const Text("Notifikasi"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan notifikasi
            },
          ),
          const Divider(),

          // Tentang Aplikasi
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blueAccent),
            title: const Text("Tentang Aplikasi"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Tampilkan dialog tentang aplikasi
              showAboutDialog(
                context: context,
                applicationName: "Jalanin Aja",
                applicationVersion: "1.0.0",
                children: const [
                  Text("Aplikasi sederhana untuk contoh Flutter."),
                ],
              );
            },
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Logout → kembali ke halaman login dan hapus semua halaman sebelumnya
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
