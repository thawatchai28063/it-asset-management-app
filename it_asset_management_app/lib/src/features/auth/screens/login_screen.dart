import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';
import 'package:it_asset_management_app/src/features/dashboard/screens/dashboard_screen.dart';
import 'package:it_asset_management_app/src/features/auth/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'admin@example.com');
  final _password = TextEditingController(text: 'password');
  final _api = ApiService();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final response = await _api.login(_email.text.trim(), _password.text);
    setState(() => _loading = false);
    if (!mounted) return;
    await showAppAlert(
      context,
      title: response.success ? 'ล็อกอินสำเร็จ' : 'ล็อกอินไม่สำเร็จ',
      message: response.message,
      success: response.success,
    );
    if (!mounted) return;
    if (response.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: AnimatedAppIcon(
                      icon: Icons.inventory_2,
                      color: Colors.indigo,
                      size: 96,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'IT Asset Management',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter password'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _loading ? null : _login,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text('Create account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
