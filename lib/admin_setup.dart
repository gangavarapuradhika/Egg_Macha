import 'package:flutter/material.dart';
import 'admin_account_store.dart';
import 'models.dart';
import 'widgets.dart';

class AdminSetupPage extends StatefulWidget {
  const AdminSetupPage({super.key});
  @override
  State<AdminSetupPage> createState() => _AdminSetupPageState();
}

class _AdminSetupPageState extends State<AdminSetupPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool hidePassword = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  void createAccount() {
    if (name.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Enter your name, email and a password with at least 8 characters.')));
      return;
    }
    if (!email.text.trim().contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid email address.')));
      return;
    }
    if (password.text != confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')));
      return;
    }
    final created = AdminAccountStore.instance.create(
        adminName: name.text,
        adminEmail: email.text,
        adminPassword: password.text);
    if (!created) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('An Admin has already been created in this app session.')));
      return;
    }
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
              title: const Text('Admin account created'),
              content: const Text(
                  'Your frontend demo Admin account is ready. Return to Admin Login and sign in with these credentials.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                    child: const Text('GO TO LOGIN'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.deepBrown,
        appBar: AppBar(
            backgroundColor: AppColors.deepBrown,
            foregroundColor: Colors.white,
            title: const Text('Owner setup')),
        body: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                          color: AppColors.paper,
                          borderRadius: BorderRadius.circular(28)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Brand(),
                            const SizedBox(height: 28),
                            const Text('CREATE FIRST ADMIN',
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.brown)),
                            const SizedBox(height: 8),
                            const Text(
                                'Frontend-only owner setup. This screen is for creating the first demo Admin account.',
                                style: TextStyle(color: AppColors.muted)),
                            const SizedBox(height: 22),
                            TextField(
                                controller: name,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    labelText: 'Admin full name',
                                    prefixIcon: Icon(Icons.person_outline),
                                    border: OutlineInputBorder())),
                            const SizedBox(height: 14),
                            TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: 'Admin email',
                                    prefixIcon: Icon(Icons.email_outlined),
                                    border: OutlineInputBorder())),
                            const SizedBox(height: 14),
                            TextField(
                                controller: password,
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                    labelText:
                                        'Create password (8+ characters)',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                        onPressed: () => setState(
                                            () => hidePassword = !hidePassword),
                                        icon: Icon(hidePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    border: const OutlineInputBorder())),
                            const SizedBox(height: 14),
                            TextField(
                                controller: confirm,
                                obscureText: hideConfirm,
                                decoration: InputDecoration(
                                    labelText: 'Confirm password',
                                    prefixIcon: const Icon(Icons.lock_reset),
                                    suffixIcon: IconButton(
                                        onPressed: () => setState(
                                            () => hideConfirm = !hideConfirm),
                                        icon: Icon(hideConfirm
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    border: const OutlineInputBorder())),
                            const SizedBox(height: 22),
                            SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                    label: 'CREATE ADMIN ACCOUNT',
                                    icon: Icons.admin_panel_settings_outlined,
                                    onTap: createAccount)),
                            const SizedBox(height: 16),
                            const Text(
                                'Important: because this is frontend-only, this demo account is kept in memory and will reset when the app restarts. Use a backend before real business use.',
                                style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                    height: 1.4)),
                          ])),
                ))),
      );
}
