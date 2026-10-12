import 'package:flutter/material.dart';
import 'admin_login.dart';
import 'staff_login.dart';
import 'customer_shell.dart';
import 'landing.dart';
import 'models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await addressStore.load();
  runApp(const EggMachaApp());
}

class EggMachaApp extends StatelessWidget {
  const EggMachaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Egg Macha',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.paper,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
        ),
        home: const LandingPage(),
        routes: {
          '/customer': (_) => const CustomerShell(),
          '/admin': (_) => const AdminLoginPage(),
          '/staff': (_) => const StaffLoginPage(),
        },
      );
}
