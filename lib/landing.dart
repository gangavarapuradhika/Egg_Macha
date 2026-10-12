import 'package:flutter/material.dart';
import 'admin_login.dart';
import 'models.dart';
import 'user_login.dart';
import 'widgets.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/community.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.deepBrown.withValues(alpha: 0.72),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<Widget>(
                              builder: (BuildContext context) {
                                return const AdminLoginPage();
                              },
                            ),
                          );
                        },
                        child: const Brand(light: true),
                      ),
                      const SizedBox(height: 70),
                      const Text(
                        'EGGS.\nBUT NOT\nORDINARY.',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          height: 0.94,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Hyderabad’s Egg Spot\nMade fresh. Served Macha style.',
                        style: TextStyle(
                          color: Color(0xFFFFE7C4),
                          fontSize: 20,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 240,
                        height: 54,
                        child: PrimaryButton(
                          label: 'USER LOGIN',
                          icon: Icons.person_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<Widget>(
                                builder: (BuildContext context) {
                                  return const UserLoginPage();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'FRESHLY MADE. FULL OF FLAVOUR.',
                        style: TextStyle(
                          color: Color(0xFFFFE7C4),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
