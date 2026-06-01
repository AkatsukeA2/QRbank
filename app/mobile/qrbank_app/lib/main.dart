
import 'package:flutter/material.dart';
import 'package:qrbank_app/screens/account_screen.dart';
import 'package:qrbank_app/screens/extrato_screen.dart';
import 'package:qrbank_app/screens/guadian_register_screen.dart';
import 'package:qrbank_app/screens/help_screen.dart';
import 'package:qrbank_app/screens/home_screen.dart';
import 'package:qrbank_app/screens/login_screen.dart';
import 'package:qrbank_app/screens/onboarding_screen.dart';
import 'package:qrbank_app/screens/qr_code_screen.dart';
import 'package:qrbank_app/screens/register_screen.dart';
import 'package:qrbank_app/screens/splash_screen%20.dart';
import 'package:qrbank_app/screens/transactions_screen.dart';
import 'package:qrbank_app/screens/transfer_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QrBank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B6FD4)),
        useMaterial3: true,
      ),
      initialRoute: "/home",
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        "/login": (context) => const LoginScreen(),
        "/register/guardians": (context) => const GuadianRegisterScreen(),
        "/home": (context) => const HomeScreen(),
        "/accounts": (context) => const AccountScreen(),
        "/transfer": (context) => const TransferScreen(),
        "/extract": (context) => const ExtratoScreen(),
        "/transactions": (context) => const TransactionsScreen(),
        "/qrcode": (context) => const QrCodeScreen(),
        "/help": (context) => const HelpScreen(),    
      },
    );
  }
}
