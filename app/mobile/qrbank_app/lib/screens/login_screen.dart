import 'package:flutter/material.dart';
import 'package:qrbank_app/widgets/top_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
          horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar — só "Criar Conta" (sem botão Voltar)
              const TopText(text: 'Criar Conta', route: '/onboarding', paddingRight: 0),

              // Título
              const Center(
                child: Text(
                  'Faça seu Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B3DBE),
                  ),
                ),
              ),
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
                            // TODO: navegar para cadastro
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
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _SocialButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFDDD6F3),
            width: 1.5,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
