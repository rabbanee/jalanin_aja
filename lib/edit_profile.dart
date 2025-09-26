import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_data.dart';

class EditProfilePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String? imagePath;

  const EditProfilePage({
    super.key,
    required this.fullName,
    required this.email,
    this.imagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  File? _profileImage;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();

    if (widget.imagePath != null) {
      _profileImage = File(widget.imagePath!);
    }
  }

  // Fungsi pilih foto dari gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Fungsi simpan perubahan
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final newName = _nameController.text.trim();
      final newEmail = _emailController.text.trim();
      final newPassword = _passwordController.text.trim();

      // Update data di UserData
UserData.updateProfile(
  oldEmail: widget.email,
  newName: newName,
  newEmail: newEmail,
  newPassword: newPassword?.isNotEmpty == true ? newPassword : null,
);

      // Kirim balik data terbaru ke halaman sebelumnya
      Navigator.pop(context, {
        'fullName': newName,
        'email': newEmail,
        'password': newPassword.isNotEmpty ? newPassword : null,
        'profileImage': _profileImage,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Foto Profil
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const NetworkImage('https://i.pravatar.cc/150?img=32')
                            as ImageProvider,
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Nama Lengkap
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Email tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),

                // Password Baru (opsional)
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password Baru",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Simpan Perubahan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
