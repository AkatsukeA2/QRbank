import 'package:flutter/material.dart';

class TransacoesScreen extends StatefulWidget {
  const TransacoesScreen({super.key});

  @override
  State<TransacoesScreen> createState() => _TransacoesScreenState();
}

class _TransacoesScreenState extends State<TransacoesScreen> {
  int _filterIndex = 0;
  final List<String> _filters = ['Todos', 'Entradas', 'Saídas'];

  final List<_TxGroup> _allGroups = [
    _TxGroup(label: 'Hoje, 12 Mai', transactions: [
      _TxItem(
        icon: Icons.shopping_cart_outlined,
        iconBg: Color(0xFFFFF3E0),
        iconFg: Color(0xFFFF9800),
        title: 'Supermercado Dia',
        subtitle: 'Groceries',
        amount: 'R\$ -189,50',
        isCredit: false,
        date: '14:32',
      ),
      _TxItem(
        icon: Icons.diamond_outlined,
        iconBg: Color(0xFFEDE8F8),
        iconFg: Color(0xFF7B5FC4),
        title: 'Recebimento Pix',
        subtitle: 'João Pedro',
        amount: 'R\$ +320,00',
        isCredit: true,
        date: '09:10',
      ),
    ]),
    _TxGroup(label: 'Ontem, 11 Mai', transactions: [
      _TxItem(
        icon: Icons.swap_horiz_rounded,
        iconBg: Color(0xFFFCE4EC),
        iconFg: Color(0xFFE91E63),
        title: 'Transferência para Maria Silva',
        subtitle: 'Pix',
        amount: 'R\$ -450,00',
        isCredit: false,
        date: '18:05',
      ),
      _TxItem(
        icon: Icons.local_gas_station_outlined,
        iconBg: Color(0xFFFFEBEE),
        iconFg: Color(0xFFF44336),
        title: 'Posto de Combustível',
        subtitle: 'Gas',
        amount: 'R\$ -210,30',
        isCredit: false,
        date: '13:47',
      ),
      _TxItem(
        icon: Icons.work_outline_rounded,
        iconBg: Color(0xFFE8F5E9),
        iconFg: Color(0xFF4CAF50),
        title: 'Recebido de Tech Corp',
        subtitle: 'Salário',
        amount: 'R\$ +5.200,00',
        isCredit: true,
        date: '08:00',
      ),
    ]),
    _TxGroup(label: '10 Mai', transactions: [
      _TxItem(
        icon: Icons.barcode_reader,
        iconBg: Color(0xFFE3F2FD),
        iconFg: Color(0xFF1E88E5),
        title: 'Pagamento de Boleto Luz',
        subtitle: 'Conta de Energia',
        amount: 'R\$ -180,00',
        isCredit: false,
        date: '11:20',
      ),
      _TxItem(
        icon: Icons.restaurant_outlined,
        iconBg: Color(0xFFFFF8E1),
        iconFg: Color(0xFFFFC107),
        title: 'iFood',
        subtitle: 'Alimentação',
        amount: 'R\$ -62,90',
        isCredit: false,
        date: '20:15',
      ),
    ]),
    _TxGroup(label: '09 Mai', transactions: [
      _TxItem(
        icon: Icons.diamond_outlined,
        iconBg: Color(0xFFEDE8F8),
        iconFg: Color(0xFF7B5FC4),
        title: 'Recebimento Pix de Ana Lima',
        subtitle: 'Pix',
        amount: 'R\$ +300,00',
        isCredit: true,
        date: '16:55',
      ),
      _TxItem(
        icon: Icons.local_pharmacy_outlined,
        iconBg: Color(0xFFE8F5E9),
        iconFg: Color(0xFF43A047),
        title: 'Farmácia Popular',
        subtitle: 'Saúde',
        amount: 'R\$ -38,50',
        isCredit: false,
        date: '10:30',
      ),
      _TxItem(
        icon: Icons.directions_bus_outlined,
        iconBg: Color(0xFFE3F2FD),
        iconFg: Color(0xFF1976D2),
        title: 'Transporte Público',
        subtitle: 'Mobilidade',
        amount: 'R\$ -9,60',
        isCredit: false,
        date: '07:48',
      ),
    ]),
    _TxGroup(label: '08 Mai', transactions: [
      _TxItem(
        icon: Icons.movie_outlined,
        iconBg: Color(0xFFF3E5F5),
        iconFg: Color(0xFF8E24AA),
        title: 'Netflix',
        subtitle: 'Entretenimento',
        amount: 'R\$ -39,90',
        isCredit: false,
        date: '03:00',
      ),
      _TxItem(
        icon: Icons.swap_horiz_rounded,
        iconBg: Color(0xFFFCE4EC),
        iconFg: Color(0xFFE91E63),
        title: 'TED para Carlos Mendes',
        subtitle: 'Transferência',
        amount: 'R\$ -500,00',
        isCredit: false,
        date: '14:22',
      ),
    ]),
    _TxGroup(label: '07 Mai', transactions: [
      _TxItem(
        icon: Icons.shopping_bag_outlined,
        iconBg: Color(0xFFFFF3E0),
        iconFg: Color(0xFFEF6C00),
        title: 'Americanas',
        subtitle: 'Compras',
        amount: 'R\$ -129,00',
        isCredit: false,
        date: '15:10',
      ),
      _TxItem(
        icon: Icons.work_outline_rounded,
        iconBg: Color(0xFFE8F5E9),
        iconFg: Color(0xFF4CAF50),
        title: 'Freelance Design',
        subtitle: 'Receita',
        amount: 'R\$ +800,00',
        isCredit: true,
        date: '09:05',
      ),
    ]),
  ];

  List<_TxGroup> get _filtered {
    if (_filterIndex == 0) return _allGroups;
    return _allGroups
        .map((g) {
          final txs = g.transactions.where((tx) {
            if (_filterIndex == 1) return tx.isCredit;
            return !tx.isCredit;
          }).toList();
          if (txs.isEmpty) return null;
          return _TxGroup(label: g.label, transactions: txs);
        })
        .whereType<_TxGroup>()
        .toList();
  }

  // Totais do filtro atual
  double get _totalEntradas => _allGroups
      .expand((g) => g.transactions)
      .where((tx) => tx.isCredit)
      .fold(0, (sum, tx) {
    final v =
        double.tryParse(tx.amount.replaceAll('R\$ +', '').replaceAll('.', '').replaceAll(',', '.')) ?? 0;
    return sum + v;
  });

  double get _totalSaidas => _allGroups
      .expand((g) => g.transactions)
      .where((tx) => !tx.isCredit)
      .fold(0, (sum, tx) {
    final v =
        double.tryParse(tx.amount.replaceAll('R\$ -', '').replaceAll('.', '').replaceAll(',', '.')) ?? 0;
    return sum + v;
  });

  @override
  Widget build(BuildContext context) {
    final groups = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────
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
                  const Text(
                    'Maio 2026',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // ── Título ────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(top: 14, bottom: 16),
              child: Text(
                'Todas as Transações',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7B5FC4),
                ),
              ),
            ),

            // ── Resumo entradas/saídas ────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Entradas',
                      amount:
                          'R\$ ${_totalEntradas.toStringAsFixed(2).replaceAll('.', ',')}',
                      color: const Color(0xFF2E7D32),
                      bgColor: const Color(0xFFE8F5E9),
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Saídas',
                      amount:
                          'R\$ ${_totalSaidas.toStringAsFixed(2).replaceAll('.', ',')}',
                      color: const Color(0xFFE53935),
                      bgColor: const Color(0xFFFFEBEE),
                      icon: Icons.arrow_upward_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Chips de filtro ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final active = i == _filterIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filterIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 9),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFF7B5FC4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: active
                                ? const Color(0xFF7B5FC4)
                                : const Color(0xFFDDD6F3),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          _filters[i],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: active
                                ? Colors.white
                                : const Color(0xFF9990B0),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),

            // ── Lista ─────────────────────────────────────
            Expanded(
              child: groups.isEmpty
                  ? const Center(
                      child: Text('Nenhuma transação encontrada.',
                          style: TextStyle(
                              color: Color(0xFFB0A8C8), fontSize: 14)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: groups.length,
                      itemBuilder: (_, gi) {
                        final group = groups[gi];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header data
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              margin:
                                  const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE8F8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                group.label,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5B3DBE),
                                ),
                              ),
                            ),

                            // Transações
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount: group.transactions.length,
                                separatorBuilder: (_, __) => const Divider(
                                  height: 1,
                                  indent: 60,
                                  endIndent: 12,
                                  color: Color(0xFFF0EBF8),
                                ),
                                itemBuilder: (_, ti) =>
                                    _TxTile(tx: group.transactions[ti]),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary Card ─────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(amount,
                  style: TextStyle(
                      fontSize: 13,
                      color: color,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Modelos ───────────────────────────────────────────────────

class _TxGroup {
  final String label;
  final List<_TxItem> transactions;
  const _TxGroup({required this.label, required this.transactions});
}

class _TxItem {
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final String date;

  const _TxItem({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.date,
  });
}

// ── Tile ──────────────────────────────────────────────────────

class _TxTile extends StatelessWidget {
  final _TxItem tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Ícone
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tx.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(tx.icon, size: 20, color: tx.iconFg),
            ),
            const SizedBox(width: 12),

            // Texto
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
                  const SizedBox(height: 3),
                  Text(
                    '${tx.subtitle}  •  ${tx.date}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFB0A8C8)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Valor
            Text(
              tx.amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: tx.isCredit
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: Color(0xFFB0A8C8)),
          ],
        ),
      ),
    );
  }
}