import 'package:flutter/material.dart';
import 'admin_account_store.dart';
import 'admin_dashboard.dart';
import 'admin_setup.dart';
import 'landing.dart';
import 'models.dart';
import 'widgets.dart';
import 'staff_login.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool hide = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    if (AdminAccountStore.instance.verify(
      email.text,
      password.text,
    )) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid Admin credentials. Create the first demo Admin using Owner Setup if you have not done so.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.deepBrown,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Brand(),
                    const SizedBox(height: 35),

                    const Text(
                      'ADMIN LOGIN',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brown,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Sign in to manage Egg Macha.',
                      style: TextStyle(color: AppColors.muted),
                    ),

                    const SizedBox(height: 25),

                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: password,
                      obscureText: hide,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => hide = !hide),
                          icon: Icon(
                            hide ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        label: 'LOGIN',
                        icon: Icons.login,
                        onTap: login,
                      ),
                    ),

                    if (!AdminAccountStore.instance.isCreated) ...[
                      const SizedBox(height: 14),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'First-time setup',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.brown,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Create the first Admin account for this frontend demo. This is not production-secure without a backend.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminSetupPage(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.admin_panel_settings_outlined,
                          ),
                          label: const Text(
                            'OWNER SETUP — CREATE FIRST ADMIN',
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Staff Login button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StaffLoginPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.badge_outlined),
                        label: const Text(
                          'STAFF LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.brown,
                          minimumSize: const Size(double.infinity, 52),
                          side: const BorderSide(
                            color: AppColors.brown,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LandingPage(),
                          ),
                        ),
                        child: const Text('← Back to customer app'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
