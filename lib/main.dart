import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_page.dart';
import 'user_data.dart';

void main() async {
  // Pastikan Flutter binding sudah siap sebelum memanggil SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final loggedInEmail = prefs.getString('logged_in_user_email');

  Widget initialScreen = const LoginScreen();

  if (loggedInEmail != null) {
    // Jika ada email tersimpan, coba dapatkan data lengkap user
    final user = await UserData.getUserByEmail(loggedInEmail);
    if (user != null) {
      // Jika data user ditemukan, arahkan ke HomePage
      initialScreen = HomePage(
        fullName: user['fullName']!,
        email: user['email']!,
        imagePath: user['imagePath'],
      );
    }
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Login Register',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: initialScreen, // Gunakan initialScreen yang sudah dicek
    );
  }
}
