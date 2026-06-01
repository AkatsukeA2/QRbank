import 'package:flutter/material.dart';
import 'package:qrbank_app/screens/splash_screen%20.dart';
import 'package:qrbank_app/services/auth_service.dart';
import 'package:qrbank_app/services/user_service.dart';
import 'package:qrbank_app/widgets/requared_lable.dart';
import 'package:qrbank_app/widgets/top_text_center.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool isLoading = false;
  static const currentYear = 2026;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

   @override
  void dispose() {
    _emailController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    _ageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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

      void _submeter() {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password1 = _password1Controller.text.trim();
    final password2 = _password2Controller.text.trim();
    final birthDateStr = _ageController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        password1.isEmpty ||
        password2.isEmpty ||
        birthDateStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    if (password1 != password2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final idade = _calcularIdade(birthDateStr);
    if (idade == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data de nascimento inválida. Use AAAA/MM/DD.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final birthDate = DateTime.parse(birthDateStr.replaceAll('/', '-'));

    if (idade < 18) {
      Navigator.of(context).pushNamed(
        '/register/guardians',
        arguments: {
          'email': email,
          'password': password1,
          'name': name,
          'birthDate': birthDate,
          'phone': phone,
        },
      );
      return;
    }

    _cadastrar(email, password1, name, birthDate, phone);
  }

 void _cadastrar(String email, String password, String name,
      DateTime birthDate, String phone) async {
    setState(() => isLoading = true);
    try {
      final result =
          await AuthService().register(email, password, name, birthDate, phone);

      if (result?['tokenType'] == 'Bearer') {
        final user = await UserService().getUserByEmail(email);
        if (user != null) await UserService().setCurrentUser(user);

        // Envia email de saudação
        await UserService().sendWelcomeEmail(email: email, name: name);

        Navigator.of(context).pushReplacementNamed('/home', arguments: {
          'email': email,
          'name': name,
          'id': user?.id ?? '',
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar. Tente novamente.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  } 

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
                controller: _nameController,
                keyboardType: TextInputType.name,
                style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                decoration: InputDecoration(
                  hintText: 'Exemplo: Obed Jorge',
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
                controller: _emailController,
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
                controller: _phoneController,
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
                controller: _ageController,
                keyboardType: TextInputType.text,
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
                controller: _password1Controller,
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
                controller: _password2Controller,
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
                    /* TODO: lógica de registro
                    if (_password1Controller != _password2Controller) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('As senhas não coensidem'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }
                    final email = _emailController.text.trim();
                    final name = _nameController.text.trim();
                    final phone = _phoneController.text.trim();
                    final password = _password2Controller.text.trim();
                    final age =_ageController;
                    // calcular idade

                    final age2 = age as DateTime;
                    currentYear - age2.year < 18? print("é maior de idade"):  Navigator.of(context).pushReplacementNamed('/register/guardians');


                    AuthService().register(email, password, name, age as DateTime, phone ).then((result) {
                      if (result?['tokenType'] == 'Bearer') {
                        // Login bem-sucedido, navegar para a tela principal
                        UserService().getUserByEmail(email).then((user) {
                          if (user != null) {
                            UserService().setCurrentUser(user);
                          }
                        });
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        // Login falhou, mostrar mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('E-mail ou senha inválidos.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    });
                      */
                    _submeter();
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