import 'package:flutter/material.dart';
import 'package:qrbank_app/screens/splash_screen%20.dart';
import 'package:qrbank_app/widgets/requared_lable.dart';
import 'package:qrbank_app/widgets/top_text_center.dart';

class GuadianRegisterScreen extends StatefulWidget {
  const GuadianRegisterScreen({super.key});

  @override
  State<GuadianRegisterScreen> createState() => _GuadianRegisterScreenState();
}

class _GuadianRegisterScreenState extends State<GuadianRegisterScreen> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const QrBankLogo(size: 145),
                ),
              ),
              const TopTextCenter(title: 'Dados do Guardião'),
              const SizedBox(height: 40),
              RequaredLable(text: 'Digite o nome'),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.name,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Nome do guardião',
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
              RequaredLable(text: 'Digite o email'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Email do guardião',
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
              RequaredLable(text: 'Digite o Nº telefone'),
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Telefone do guardião',
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

              const RequaredLable(text: 'Imforme a data de nascimento'),
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

              const RequaredLable(text: 'Imforme o grau de parentesco'),
              TextField(
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Grau de patentesco',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8A8E8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.people,
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
    ;
  }
}