import 'package:flutter/material.dart';
import 'package:qrbank_app/widgets/action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  bool _balanceVisible = true;

  final List<_Transaction> _transactions = const [
    _Transaction(
      index: 1,
      title: 'Supermercado Dia',
      subtitle: 'Groceries',
      amount: 'R\$ -189,50',
      date: '14 Mai',
      isCredit: false,
      iconColor: Color(0xFFFFF3E0),
      iconFgColor: Color(0xFFFF9800),
      icon: Icons.shopping_cart_outlined,
    ),
    _Transaction(
      index: 2,
      title: 'Transferência para Maria Silva',
      subtitle: 'Senta',
      amount: 'R\$ -450,00',
      date: '13 Mai',
      isCredit: false,
      iconColor: Color(0xFFFCE4EC),
      iconFgColor: Color(0xFFE91E63),
      icon: Icons.swap_horiz_rounded,
    ),
    _Transaction(
      index: 3,
      title: 'Recebido de Tech Corp',
      subtitle: 'Salario',
      amount: 'R\$ +5.200,00',
      date: '12 Mai',
      isCredit: true,
      iconColor: Color(0xFFE8F5E9),
      iconFgColor: Color(0xFF4CAF50),
      icon: Icons.work_outline_rounded,
    ),
    _Transaction(
      index: 4,
      title: 'Posto de Combustível',
      subtitle: 'Gas',
      amount: 'R\$ -210,30',
      date: '11 Mai',
      isCredit: false,
      iconColor: Color(0xFFFFEBEE),
      iconFgColor: Color(0xFFF44336),
      icon: Icons.local_gas_station_outlined,
    ),
  ];

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
            text: const TextSpan(
              style: TextStyle(color: Color(0xFF1A1A2E)),
              children: [
                TextSpan(
                  text: 'Olá,\n',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                TextSpan(
                  text: 'Obed Jorge!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
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
              CircleAvatar(
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
                  color: Colors.white.withOpacity(0.1),
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
                  color: Colors.white.withOpacity(0.08),
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
                    _balanceVisible ? 'R\$ 12.458,70' : 'R\$ ••••••',
                    key: ValueKey(_balanceVisible),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cartão Virtual: **** 5678',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {},
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
              onTap: () {},
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
                      color: const Color(0xFF7B5FC4).withOpacity(0.35),
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
                  Navigator.pushNamed(context, "/transactions");
                },
                child: Row(
                  children: const [
                    Text(
                      'Ver tudo',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B5FC4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: Color(0xFF7B5FC4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 60,
                endIndent: 16,
                color: Color(0xFFF0EBF8),
              ),
              itemBuilder: (_, i) => _TransactionTile(tx: _transactions[i]),
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
                onTap: () =>{

                   setState(() => _currentTab = i),
                    if(i == 0) Navigator.pushReplacementNamed(context, "/home"),
                    if(i == 1) Navigator.pushNamed(context, "/transactions"),
                    if(i == 2) Navigator.pushNamed(context, "/help"),
                    if(i == 3) Navigator.pushNamed(context, "/accounts"),
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


class _Transaction {
  final int index;
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final bool isCredit;
  final Color iconColor;
  final Color iconFgColor;
  final IconData icon;

  const _Transaction({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.iconColor,
    required this.iconFgColor,
    required this.icon,
  });
}

class _TransactionTile extends StatelessWidget {
  final _Transaction tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Número
          SizedBox(
            width: 20,
            child: Text(
              '${tx.index}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB0A8C8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Ícone
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tx.iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx.icon, size: 20, color: tx.iconFgColor),
          ),
          const SizedBox(width: 12),

          // Título + subtítulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  tx.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB0A8C8),
                  ),
                ),
              ],
            ),
          ),

          // Valor + data
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx.amount,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: tx.isCredit
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tx.date,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFB0A8C8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}