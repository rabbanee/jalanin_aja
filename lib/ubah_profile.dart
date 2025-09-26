import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';

class UbahProfilePage extends StatefulWidget {
  final String? imagePath;

  const UbahProfilePage({super.key, this.imagePath});

  @override
  State<UbahProfilePage> createState() => _UbahProfilePageState();
}

class _UbahProfilePageState extends State<UbahProfilePage> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      _profileImage = File(widget.imagePath!);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // Kirim kembali hasil foto ke halaman sebelumnya
      Navigator.pop(context, {'profileImage': _profileImage});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Foto Profil"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 80,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : const NetworkImage('https://i.pravatar.cc/150?img=32')
                    as ImageProvider,
            child: const Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(Icons.camera_alt, size: 24, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Contoh ListTile Logout untuk SettingsPage
Widget logoutListTile(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.logout, color: Colors.redAccent),
    title: const Text("Logout"),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      // Logout → kembali ke halaman login dan hapus semua halaman sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // semua halaman sebelumnya dihapus
      );
    },
  );
}
