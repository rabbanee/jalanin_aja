import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusat Bantuan"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "FAQ & Bantuan",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Contoh FAQ
          _buildFAQItem(
            question: "Bagaimana cara mendaftar akun?",
            answer: "Klik tombol 'Daftar' pada halaman login, isi formulir dengan benar, lalu submit.",
          ),
          _buildFAQItem(
            question: "Lupa password, apa yang harus dilakukan?",
            answer: "Gunakan fitur 'Ganti Password' pada halaman pengaturan untuk memperbarui password Anda.",
          ),
          _buildFAQItem(
            question: "Bagaimana cara mengubah profil?",
            answer: "Buka halaman Profil, lalu tekan tombol 'Edit Profil'.",
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(answer),
        ),
        const Divider(),
      ],
    );
  }
}
