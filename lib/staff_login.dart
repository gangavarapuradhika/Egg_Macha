import 'package:flutter/material.dart';
import 'landing.dart';
import 'models.dart';
import 'widgets.dart';
import 'staff_dashboard.dart';

class StaffLoginPage extends StatefulWidget {
  const StaffLoginPage({super.key});
  @override
  State<StaffLoginPage> createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<StaffLoginPage> {
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
    if (email.text.trim().toLowerCase() == 'eggmachastaff@gmail.com' &&
        password.text == 'staff@123') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const StaffDashboard()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid demo staff credentials.')));
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
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                          color: AppColors.paper,
                          borderRadius: BorderRadius.circular(28)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Brand(),
                            const SizedBox(height: 30),
                            const Text('STAFF LOGIN',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.brown)),
                            const SizedBox(height: 8),
                            const Text(
                                'Access your shift tasks, orders and daily checklist.',
                                style: TextStyle(color: AppColors.muted)),
                            const SizedBox(height: 24),
                            TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: 'Staff email',
                                    prefixIcon: Icon(Icons.badge_outlined),
                                    border: OutlineInputBorder())),
                            const SizedBox(height: 14),
                            TextField(
                                controller: password,
                                obscureText: hide,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                        onPressed: () =>
                                            setState(() => hide = !hide),
                                        icon: Icon(hide
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    border: const OutlineInputBorder())),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                    label: 'LOGIN AS STAFF',
                                    icon: Icons.login,
                                    onTap: login)),
                            const SizedBox(height: 12),
                            const Center(
                                child: Text(
                                    'Demo: eggmachastaff@gmail.com / staff@123',
                                    textAlign: TextAlign.center)),
                            Center(
                                child: TextButton(
                                    onPressed: () =>
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const LandingPage()),
                                            (_) => false),
                                    child: const Text('← Back to home'))),
                          ]),
                    )))),
      );
}
