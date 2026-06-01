import 'package:flutter/material.dart';
import 'package:qrbank_app/services/auth_service.dart';
import 'package:qrbank_app/services/user_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _userName = 'Usuário';
  String _userEmail = '';
  String _userId = '';
  bool _isLoading = false;
  bool _emailEditing = false;

  late TextEditingController _emailController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _userId.isEmpty) {
      setState(() {
        _userName = args['name'] ?? 'Usuário';
        _userEmail = args['email'] ?? '';
        _userId = args['id'] ?? '';
        _emailController.text = _userEmail;
        _nameController.text = _userName;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ── Logout ──────────────────────────────────────────────
  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().logout();
      await UserService().clearCurrentUser();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false, // remove todas as rotas anteriores
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao sair. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── Salvar alterações ────────────────────────────────────
  Future<void> _saveChanges() async {
    final newEmail = _emailController.text.trim();
    final newName = _nameController.text.trim();

    if (newEmail.isEmpty || newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await UserService().updateUser(
        userId: _userId,
        name: newName,
        email: newEmail,
      );
      setState(() {
        _userName = newName;
        _userEmail = newEmail;
        _emailEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alterações salvas com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── Excluir conta ────────────────────────────────────────
  Future<void> _deleteAccount() async {
    setState(() => _isLoading = true);
    try {
      await UserService().deleteUser(_userId);
      await UserService().clearCurrentUser();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao excluir conta. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sair',
            style: TextStyle(
                color: Color(0xFF3D2B7A), fontWeight: FontWeight.w700)),
        content: const Text('Tem certeza que deseja sair?',
            style: TextStyle(color: Color(0xFF9990B0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Color(0xFF9990B0))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text('Sair',
                style: TextStyle(
                    color: Color(0xFF7B5FC4), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Excluir Conta',
            style: TextStyle(
                color: Color(0xFF3D2B7A), fontWeight: FontWeight.w700)),
        content: const Text(
            'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.',
            style: TextStyle(color: Color(0xFF9990B0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Color(0xFF9990B0))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text('Excluir',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7B5FC4)))
          : SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.chevron_left_rounded,
                              color: Color(0xFF7B5FC4), size: 22),
                          label: const Text('Voltar',
                              style: TextStyle(
                                  color: Color(0xFF7B5FC4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        TextButton(
                          onPressed: _showLogoutDialog, // <-- funcional
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Sair',
                              style: TextStyle(
                                  color: Color(0xFF7B5FC4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          const Text('Definições de Conta',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7B5FC4))),
                          const SizedBox(height: 24),

                          // Avatar
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFEDE8F8),
                                  border: Border.all(
                                      color: const Color(0xFFD0C4F0), width: 2),
                                ),
                                child: const Icon(Icons.person_rounded,
                                    size: 52, color: Color(0xFF9B72E8)),
                              ),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7B5FC4),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded,
                                    size: 14, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Text(_userName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E))),
                          const SizedBox(height: 4),
                          Text(_userEmail,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF7B5FC4))),
                          const SizedBox(height: 28),

                          _buildMenuList(),
                          const SizedBox(height: 24),

                          // Campo Nome
                          _buildFieldLabel('Nome Completo'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF3D2B7A)),
                            decoration: _fieldDecoration(),
                          ),
                          const SizedBox(height: 16),

                          // Campo E-mail
                          _buildFieldLabel('E-mail Principal'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            enabled: _emailEditing,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF3D2B7A)),
                            decoration: _fieldDecoration(
                              suffix: GestureDetector(
                                onTap: () => setState(
                                    () => _emailEditing = !_emailEditing),
                                child: Icon(Icons.edit_outlined,
                                    size: 18,
                                    color: _emailEditing
                                        ? const Color(0xFF7B5FC4)
                                        : const Color(0xFFB8A8E8)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  setState(() => _emailEditing = true),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(top: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Alterar E-mail',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF7B5FC4),
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFF7B5FC4))),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Botão Salvar
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _saveChanges, // <-- funcional
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B5FC4),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                elevation: 0,
                              ),
                              child: const Text('Salvar Alterações',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: _showDeleteDialog,
                            child: const Text('Excluir Conta',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.red,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF3D2B7A),
              fontWeight: FontWeight.w500),
          children: [
            TextSpan(text: label),
            const TextSpan(
                text: '*', style: TextStyle(color: Color(0xFF7B5FC4))),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({Widget? suffix}) {
    return InputDecoration(
      suffixIcon: suffix,
      hintStyle: const TextStyle(color: Color(0xFFB8A8E8)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
      ),
    );
  }

  Widget _buildMenuList() {
    final items = [
      (Icons.person_outline_rounded, 'Informações Pessoais'),
      (Icons.lock_outline_rounded, 'Segurança e Senha'),
      (Icons.notifications_outlined, 'Notificações'),
      (Icons.credit_card_outlined, 'Métodos de Pagamento Salvos'),
      (Icons.language_rounded, 'Preferências de Idioma'),
    ];

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(
            height: 1, indent: 52, endIndent: 16, color: Color(0xFFF0EBF8)),
        itemBuilder: (_, i) {
          final (icon, label) = items[i];
          return ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xFFEDE8F8),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: const Color(0xFF7B5FC4)),
            ),
            title: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A2E))),
            trailing: const Icon(Icons.chevron_right_rounded,
                size: 20, color: Color(0xFFB0A8C8)),
          );
        },
      ),
    );
  }
}
