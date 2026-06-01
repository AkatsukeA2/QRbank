import 'package:flutter/material.dart';
import 'package:qrbank_app/model/user.dart';
import 'package:qrbank_app/screens/splash_screen%20.dart';
import 'package:qrbank_app/services/auth_service.dart';
import 'package:qrbank_app/services/user_service.dart';
import 'package:qrbank_app/widgets/loading_overlay.dart';
import 'package:qrbank_app/widgets/top_text.dart';
import 'package:qrbank_app/widgets/top_text_center.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading:_isLoading,
      message: 'Entrando...',
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FA),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
            horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                // Top bar — só "Criar Conta" (sem botão Voltar)
                const TopText(text: 'Criar Conta', route: '/register', paddingRight: 0),
               Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const QrBankLogo(size: 145),
                  ),
                ),
                // Título
                const TopTextCenter(title:'Faça seu Login'),
                const SizedBox(height: 40),
      
                // Label E-mail
                const Text(
                  'E-mail ou Usuário',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3D2B7A),
                  ),
                ),
                const SizedBox(height: 8),
      
                // Campo E-mail
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF3D2B7A)),
                  decoration: InputDecoration(
                    hintText: 'Seu e-mail ou nome de usuário',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB8A8E8),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.mail_outline_rounded,
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
                const SizedBox(height: 24),
      
                // Label Senha
                const Text(
                  'Senha',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3D2B7A),
                  ),
                ),
                const SizedBox(height: 8),
      
                // Campo Senha
                TextField(
                  controller: _passwordController,
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
      
                // Esqueci minha senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: recuperação de senha
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Esqueci minha senha?',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B5FC4),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF7B5FC4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
      
                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Por favor, preencha todos os campos.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      setState(() => _isLoading = true);

                      try {
                        final result = await AuthService()
                            .login(email, password); // <-- await

                        if (result?['tokenType'] == 'Bearer') {
                          final user = await UserService()
                              .getUserByEmail(email); // <-- await
                          if (user != null) UserService().setCurrentUser(user);

                          Navigator.of(context).pushReplacementNamed(
                            '/home',
                            arguments: {
                              'email': email,
                              'name':
                                  UserService().currentUser!.firstName +' '+UserService().currentUser!.lastName,
                              'id': UserService().currentUser?.id,
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('E-mail ou senha inválidos.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ocorreu um erro. Tente novamente.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } finally {
                        setState(() => _isLoading =
                            false); // <-- agora desativa no momento certo
                      }
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
                      'Entrar',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
      
                // Divisor "ou entre com"
               /* Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        endIndent: 12,
                      ),
                    ),
                    const Text(
                      'ou entre com',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9990B0),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        indent: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
      
                // Botões sociais (Google + Facebook)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(
                      onTap: () {
                        // TODO: login com Google
                      },
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7B5FC4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _SocialButton(
                      onTap: () {
                        // TODO: login com Facebook
                      },
                      child: const Icon(
                        Icons.facebook_rounded,
                        size: 24,
                        color: Color(0xFF7B5FC4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              */
                // Não tem conta?
                Center(
                  child: RichText(
                    text: TextSpan(
                      style:
                          const TextStyle(fontSize: 14, color: Color(0xFF9990B0)),
                      children: [
                        const TextSpan(text: 'Não tem uma conta? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              
                              Navigator.of(context).pushReplacementNamed(
                                '/register',
                                // MaterialPageRoute(builder: (_) => const LoginScreen()), --- IGNORE ---
                              );
                            },
                            child: const Text(
                              'Cadastre-se',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7B5FC4),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF7B5FC4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}

