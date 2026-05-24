import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:it_asset_management_app/src/features/dashboard/screens/dashboard_screen.dart';
import 'package:it_asset_management_app/src/features/auth/screens/login_screen.dart';

void main() {
  runApp(const ItAssetApp());
}

class ItAssetApp extends StatelessWidget {
  const ItAssetApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT Asset Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.indigo.withAlpha(12),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.indigo.withAlpha(40)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
          ),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data! ? const DashboardScreen() : const LoginScreen();
        },
      ),
    );
  }
}
