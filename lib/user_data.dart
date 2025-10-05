// user_data.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static const _usersKey = 'app_users'; // Kunci untuk menyimpan list user

  // Helper untuk mendapatkan list user dari SharedPreferences
  static Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson
        .map((user) => jsonDecode(user) as Map<String, dynamic>)
        .toList();
  }

  // Helper untuk menyimpan list user ke SharedPreferences
  static Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((user) => jsonEncode(user)).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }

  /// Register dengan validasi email unik
  static Future<bool> register(
    String fullName,
    String email,
    String password,
  ) async {
    final users = await _getUsers();
    final exists = users.any((user) => user['email'] == email);

    if (exists) {
      return false; // email sudah terdaftar
    }

    users.add({
      'fullName': fullName,
      'email': email,
      'password': password,
      'imagePath': null, // Tambahkan imagePath default
    });

    await _saveUsers(users);
    return true; // berhasil daftar
  }

  /// Login user
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    final users = await _getUsers();
    try {
      return users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );
    } catch (_) {
      return null; // user tidak ditemukan
    }
  }

  /// Update data profil user
  static Future<bool> updateProfile({
    required String oldEmail,
    required String newName,
    required String newEmail,
    String? newPassword,
    String? newImagePath,
  }) async {
    final users = await _getUsers();

    // Cek kalau newEmail sudah dipakai user lain
    final emailTaken = users.any(
      (u) => u['email'] == newEmail && u['email'] != oldEmail,
    );
    if (emailTaken) return false;

    for (var user in users) {
      if (user['email'] == oldEmail) {
        user['fullName'] = newName;
        user['email'] = newEmail;
        if (newPassword != null && newPassword.isNotEmpty) {
          user['password'] = newPassword;
        }
        if (newImagePath != null) {
          user['imagePath'] = newImagePath;
        }

        await _saveUsers(users);
        return true; // berhasil update
      }
    }
    return false; // user tidak ditemukan
  }

  /// Helper untuk mendapatkan data user berdasarkan email
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final users = await _getUsers();
    try {
      return users.firstWhere((user) => user['email'] == email);
    } catch (e) {
      return null;
    }
  }
}
