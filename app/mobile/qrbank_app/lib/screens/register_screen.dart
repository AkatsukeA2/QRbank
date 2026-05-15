import 'package:flutter/material.dart';
import 'package:qrbank_app/screens/splash_screen%20.dart';
import 'package:qrbank_app/widgets/requared_lable.dart';
import 'package:qrbank_app/widgets/top_text_center.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: const QrBankLogo(size: 145),
                ),
              ),
              
              const TopTextCenter(title: 'Faça seu Cadastro'),
              const SizedBox(height: 40),

              RequaredLable(text: 'Digite seu nome'),

              const SizedBox(height: 8),

              TextField(
                keyboardType: TextInputType.name,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Seu nome',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8A8E8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_pin,
                    color: Color(0xFFB8A8E8),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              RequaredLable(text: 'Digite seu email'),

              TextField(
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Seu email',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8A8E8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFFB8A8E8),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              RequaredLable(text: 'Digite seu Nº telefone'),

              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Seu telefone',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8A8E8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Color(0xFFB8A8E8),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
                  ),
                ),
              ),

              SizedBox(height: 8),

              const RequaredLable(text: 'Imforme sua data de nascimento'),
              TextField(
                keyboardType: TextInputType.datetime,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'AAAA/MM/DD',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8A8E8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.calendar_month,
                    color: Color(0xFFB8A8E8),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              const RequaredLable(text: 'Escollha uma senha'),
              TextField(
                obscureText: _obscurePassword,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Sua senha',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8A8E8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFFB8A8E8),
                    size: 20,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF7B5FC4),
                      size: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
                  ),
                ),
              ),

              SizedBox(height: 8),

              const RequaredLable(text: 'Confirme uma senha'),
              TextField(
                obscureText: _obscurePassword,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Sua senha',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8A8E8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFFB8A8E8),
                    size: 20,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF7B5FC4),
                      size: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
                  ),
                ),
              ),

              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: lógica de login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B5FC4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submeter',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}