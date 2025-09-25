class UserData {
  static final List<Map<String, String>> _users = [];

  /// Register dengan validasi email unik
  static bool register(String fullName, String email, String password) {
    final exists = _users.any((user) => user['email'] == email);

    if (exists) {
      return false; // email sudah terdaftar
    }

    _users.add({
      'fullName': fullName,
      'email': email,
      'password': password,
    });

    return true; // berhasil daftar
  }

  /// Login user
  static Map<String, String>? login(String email, String password) {
    try {
      return _users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );
    } catch (_) {
      return null; // user tidak ditemukan
    }
  }

  /// Update data profil user
  static bool updateProfile({
    required String oldEmail,
    required String newName,
    required String newEmail,
    String? newPassword,
  }) {
    for (var user in _users) {
      if (user['email'] == oldEmail) {
        // cek kalau newEmail sudah dipakai user lain
        final emailTaken = _users.any(
          (u) => u['email'] == newEmail && u['email'] != oldEmail,
        );
        if (emailTaken) return false;

        user['fullName'] = newName;
        user['email'] = newEmail;
        if (newPassword != null && newPassword.isNotEmpty) {
          user['password'] = newPassword;
        }
        return true; // berhasil update
      }
    }
    return false; // user tidak ditemukan
  }
}
