import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrbank_app/model/transaction.dart';
import 'package:qrbank_app/services/account_service.dart';
import 'package:qrbank_app/services/transaction_service.dart';
import 'package:qrbank_app/services/user_service.dart';
import 'package:qrbank_app/widgets/action_button.dart';
import 'package:qrbank_app/widgets/transaction_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  bool _balanceVisible = true;
  String _userName = 'Usuário';
  String _userEmail = '';
  String _userId = '';
  bool isLoading = false;
  String _balance = 'R\$ 0,00'; // <-- adicione

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadBalance() async {
    setState(() => isLoading = true);
    try {
      final account =
          await AccountService().getAccountByEmail(_userEmail); // <-- await
      setState(() => _balance = account?.balance.toString() ?? 'R\$ 0,00');
    } catch (e) {
      setState(() => _balance = 'R\$ --');
    } finally {
      setState(() => isLoading = false); // <-- agora executa no momento certo
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final email = args['email'] ?? '';
      final name = args['name'] ?? 'Usuário';
      final id = args['id'] ?? '';

      // Só recarrega se o email mudou
      if (email != _userEmail) {
        setState(() {
          _userName = name;
          _userEmail = email;
          _userId = id;
        });
        _loadBalance();
        _loadTransactions();  // <-- aqui, depois de ter o email
      }
    }
  }


  void _genarateAndShowQR() {
    final qrdata = {
      'receiver': _userId,
    };
    final qrString = qrdata.toString(); // Simplesmente converte o mapa para string

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Seu QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3D2B7A),
              ),
            ),
            const SizedBox(height: 24),
            QrImageView(
              data: qrString, 
              version: QrVersions.auto,
              size: 220,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF7B5FC4), // roxo do seu app
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF3D2B7A),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userEmail,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9990B0),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  

  // Troque a lista estática por dinâmica
List<Transaction> _transactions = [];

// Adicione o método de carregamento
Future<void> _loadTransactions() async {
  try {
    final transactions = await TransactionService()
        .getTransactionsByUserId(_userId);
    setState(() => _transactions = transactions);
  } catch (e) {
    setState(() => _transactions = []);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildBalanceCard(),
                    _buildQuickActions(),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Header ──────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Saudação
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF1A1A2E)),
              children: [
                const TextSpan(
                  text: 'Olá,\n',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                TextSpan(
                  text: _userName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),

          // Ícones direita
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFEDE8F8), width: 1.5),
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        size: 20, color: Color(0xFF3D2B7A)),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('1',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/accounts"),
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: const Color(0xFFD0C4F0),
                  child: ClipOval(
                    child: Container(
                      width: 42,
                      height: 42,
                      color: const Color(0xFFB8A8E8),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Balance Card ─────────────────────────────────────────
  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9B72E8), Color(0xFFB99AF0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Círculo decorativo
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saldo Disponível',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _balanceVisible = !_balanceVisible),
                      child: Icon(
                        _balanceVisible
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _balanceVisible?
                          _balance  
                     : 'R\$ ••••••',
                    key: ValueKey(_balanceVisible),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/accounts"),
                  child: const Text(
                    'Acessar Conta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Quick Actions ────────────────────────────────────────
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ações Rápidas',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionButton(
                  icon: Icons.arrow_forward_rounded, label: 'Transferência'
                  , route: "/transfer"),
              ActionButton(
                  icon: Icons.receipt_long_outlined, label: 'Extrato', route: "/extract"),
              ActionButton(
                  icon: Icons.barcode_reader, label: 'Pagar', route: "/pay"),
              ActionButton(
                  icon: Icons.monetization_on, label: 'Depositar', route: "/deposit"),
            ],
          ),
          const SizedBox(height: 8),
          // Botão Escanear QR centralizado
          Center(
            child: GestureDetector(
              onTap: () {
                _genarateAndShowQR();
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF26C6DA), Color(0xFF7B5FC4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B5FC4).withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.qr_code_2_rounded,
                        color: Colors.white, size: 28),
                    SizedBox(height: 2),
                    Text(
                      'Gerar QR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Activity ──────────────────────────────────────
  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Atividades Recentes',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/transactions',
                    arguments: {
                      // <-- passa os arguments
                      'id': _userId,
                      'email': _userEmail,
                      'name': _userName,
                    },
                  );
                },
                child: Row(
                  children: const [
                    Text('Ver tudo',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF7B5FC4),
                            fontWeight: FontWeight.w500)),
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: Color(0xFF7B5FC4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Loading
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: Color(0xFF7B5FC4)),
            )

          // Lista vazia
          else if (_transactions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Nenhuma transação recente.',
                  style: TextStyle(color: Color(0xFFB0A8C8), fontSize: 14),
                ),
              ),
            )

          // Lista com dados — máximo 5
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length > 5 ? 5 : _transactions.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 16,
                  color: Color(0xFFF0EBF8),
                ),
                itemBuilder: (_, i) => TransactionTile(tx: _transactions[i]),
              ),
            ),
        ],
      ),
    );
  }
  // ── Bottom Nav ───────────────────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      {'icon': Icons.home_rounded, 'label': 'Início', 'route': '/home'},
      {'icon': Icons.swap_horiz_rounded, 'label': 'Transações', 'route': '/transactions'},
      {'icon': Icons.help_outline_rounded, 'label': 'Ajuda', 'route': '/help'},
      {'icon': Icons.person_outline_rounded, 'label': 'Conta', 'route': '/accounts'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0EBF8), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = i == _currentTab;
              return GestureDetector(
               onTap: () {
                  setState(() => _currentTab = i);
                  final args = {
                    'email': _userEmail,
                    'name': _userName,
                    'id': _userId,
                  };
                  if (i == 0) {
                    Navigator.pushNamed(context, '/home', arguments: args);
                  } else if (i == 1) {
                    Navigator.pushNamed(context, '/transactions',
                        arguments: args); // <-- args
                  } else if (i == 2) {
                    Navigator.pushNamed(context, '/help', arguments: args);
                  } else if (i == 3) {
                    Navigator.pushNamed(context, '/accounts', arguments: args);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[i]['icon'] as IconData,
                        size: 24,
                        color: isActive
                            ? const Color(0xFF7B5FC4)
                            : const Color(0xFFB0A8C8),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        
                        items[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? const Color(0xFF7B5FC4)
                              : const Color(0xFFB0A8C8),
                        ),
                      ),
                      if (isActive)
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          width: 18,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B5FC4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Widgets auxiliares ───────────────────────────────────────




