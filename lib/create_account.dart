import 'package:flutter/material.dart';
import 'customer_shell.dart';
import 'models.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              'Account screen preview only. Save accounts through your backend when ready.')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const CustomerShell()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('JOIN EGG MACHA',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.brown)),
                  const SizedBox(height: 8),
                  const Text('Create your account to get started.',
                      style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 24),
                  _field(_name, 'Full name', Icons.person_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter your name'
                          : null),
                  const SizedBox(height: 14),
                  _field(_email, 'Email address', Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || !v.contains('@') || !v.contains('.'))
                              ? 'Enter a valid email'
                              : null),
                  const SizedBox(height: 14),
                  _field(_phone, 'Phone number', Icons.phone_outlined,
                      keyboard: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().length < 10)
                          ? 'Enter a valid phone number'
                          : null),
                  const SizedBox(height: 14),
                  _field(_password, 'Password (min 6 characters)',
                      Icons.lock_outline,
                      obscure: true,
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Use at least 6 characters'
                          : null),
                  const SizedBox(height: 14),
                  _field(_confirm, 'Confirm password', Icons.lock_reset,
                      obscure: true,
                      validator: (v) => v != _password.text
                          ? 'Passwords do not match'
                          : null),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: _createAccount,
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.deepBrown,
                        padding: const EdgeInsets.all(16)),
                    child: const Text('CREATE ACCOUNT',
                        style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder()),
    );
  }
}
