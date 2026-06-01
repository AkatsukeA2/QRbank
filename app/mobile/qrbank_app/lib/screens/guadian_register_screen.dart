import 'package:flutter/material.dart';
import 'package:qrbank_app/screens/splash_screen%20.dart';
import 'package:qrbank_app/services/auth_service.dart';
import 'package:qrbank_app/services/guardian-service.dart';
import 'package:qrbank_app/services/user_service.dart';
import 'package:qrbank_app/widgets/requared_lable.dart';
import 'package:qrbank_app/widgets/top_text_center.dart';

class GuadianRegisterScreen extends StatefulWidget {
  const GuadianRegisterScreen({super.key});

  @override
  State<GuadianRegisterScreen> createState() => _GuadianRegisterScreenState();
}

class _GuadianRegisterScreenState extends State<GuadianRegisterScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  static const currentYear = 2026;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();


int _calcularIdade(String dataNascimento) {
    try {
      final partes = dataNascimento.split('/');
      final nascimento = DateTime(
        int.parse(partes[0]), // ano
        int.parse(partes[1]), // mês
        int.parse(partes[2]), // dia
      );
      final hoje = DateTime.now();
      int idade = hoje.year - nascimento.year;
      if (hoje.month < nascimento.month ||
          (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
        idade--;
      }
      return idade;
    } catch (_) {
      return -1; // data inválida
    }
  }
  void _submeterComGuardian(String guardianName, String guardianPhone) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final name = _nameController.text;
    final email = _emailController.text;
    final phone= _phoneController.text;
    final relation= _relationController.text;
    final age= _ageController.text;

     if (email.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        relation.isEmpty ||
        age.isEmpty
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    final idade = _calcularIdade(age);
    if (idade == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data de nascimento inválida. Use AAAA/MM/DD.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

     if (idade < 18) {
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O guardian deve ser maior de idade '),
          backgroundColor: Colors.redAccent,
        ),
        
      );
      return;
    }

    setState(() {
        _isLoading = true;
    });
    // Cadastra o usuário menor
    GuardianService().registeGuardian(
      name,
      email,
      phone,
      relation,
    ).then((result) {
        if (result == null) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao cadastrar o guardião. Tente novamente.'),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        };
        AuthService().register(args['email'], args['password'], args['name'], args['birthDate'], args['phone']).then((result) {
          if (result == null) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao cadastrar o usuário. Tente novamente.'),
                backgroundColor: Colors.redAccent,
              ),
            );
            return;
          };
        });
        Navigator.of(context).pushReplacementNamed(
          '/home',
          arguments: {
            'email': args['email'],
            'name': args['name'],
             'id': UserService().currentUser?.id,

          },
        );
    });
  }

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
                controller: _nameController,
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
                controller: _emailController,
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
                controller: _phoneController,
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
                controller: _ageController,
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
                controller: _relationController,
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
                    _submeterComGuardian(_nameController.text, _phoneController.text);
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
