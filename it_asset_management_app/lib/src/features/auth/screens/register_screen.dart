import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _api = ApiService();
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final response = await _api.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    await showAppAlert(
      context,
      title: response.success ? 'สมัครสมาชิกสำเร็จ' : 'สมัครสมาชิกไม่สำเร็จ',
      message: response.message,
      success: response.success,
    );
    if (!mounted) return;
    if (response.success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const AnimatedAppIcon(
                icon: Icons.person_add_alt_1,
                color: Colors.indigo,
                size: 86,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
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
                validator: (value) => value == null || value.length < 6
                    ? 'Use at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _loading ? null : _register,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.person_add),
                label: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
