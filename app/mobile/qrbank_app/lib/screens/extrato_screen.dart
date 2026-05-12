import 'package:flutter/material.dart';

class ExtratoScreen extends StatefulWidget {
  const ExtratoScreen({super.key});

  @override
  State<ExtratoScreen> createState() => _ExtratoScreenState();
}

class _ExtratoScreenState extends State<ExtratoScreen> {
  int _filterIndex = 0; // 0=Todos 1=Entradas 2=Saídas
  final List<String> _filters = ['Todos', 'Entradas', 'Saídas'];

  // Meses disponíveis para selecionar
  final List<String> _months = [
    'Outubro 2024',
    'Setembro 2024',
    'Agosto 2024',
    'Julho 2024',
  ];
  int _selectedMonth = 0;

  // Dados mockados agrupados por data
  final List<_TransactionGroup> _allGroups = [
    _TransactionGroup(
      label: 'Hoje, 24 Out',
      transactions: [
        _TxItem(
          icon: Icons.diamond_outlined,
          title: 'Recebimento Pix de João Silva',
          time: '14:30',
          extra: 'ID: 12345',
          amount: '+ R\$ 50,00',
          isCredit: true,
        ),
        _TxItem(
          icon: Icons.qr_code_2_rounded,
          title: 'Recebimento Pix de João Silva',
          time: '14:30',
          amount: '- R\$ 15,30',
          isCredit: false,
        ),
        _TxItem(
          icon: Icons.swap_horiz_rounded,
          title: 'Recebimento Pix Silva',
          time: '14:30',
          extra: 'Categoria Alimentação',
          amount: '- R\$ 15,30',
          isCredit: false,
        ),
      ],
    ),
    _TransactionGroup(
      label: 'Ontem, 23 Out',
      transactions: [
        _TxItem(
          icon: Icons.barcode_reader,
          title: 'Pagamento de Boleto Luz',
          time: '14:30',
          amount: '+ R\$ 50,00',
          isCredit: true,
        ),
        _TxItem(
          icon: Icons.arrow_forward_rounded,
          title: 'TED para Maria Santos',
          time: '14:30',
          amount: '- R\$ 15,30',
          isCredit: false,
        ),
        _TxItem(
          icon: Icons.swap_horiz_rounded,
          title: 'Transferência para Carlos',
          time: '09:15',
          amount: '- R\$ 200,00',
          isCredit: false,
        ),
      ],
    ),
    _TransactionGroup(
      label: '22 Out',
      transactions: [
        _TxItem(
          icon: Icons.diamond_outlined,
          title: 'Recebimento Pix de Ana Lima',
          time: '11:00',
          amount: '+ R\$ 300,00',
          isCredit: true,
        ),
        _TxItem(
          icon: Icons.qr_code_2_rounded,
          title: 'Pagamento QR Mercado',
          time: '18:45',
          amount: '- R\$ 89,90',
          isCredit: false,
        ),
      ],
    ),
  ];

  List<_TransactionGroup> get _filteredGroups {
    if (_filterIndex == 0) return _allGroups;

    return _allGroups
        .map((group) {
          final filtered = group.transactions.where((tx) {
            if (_filterIndex == 1) return tx.isCredit;
            if (_filterIndex == 2) return !tx.isCredit;
            return true;
          }).toList();
          if (filtered.isEmpty) return null;
          return _TransactionGroup(
              label: group.label, transactions: filtered);
        })
        .whereType<_TransactionGroup>()
        .toList();
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD0C4F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Selecionar período',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3D2B7A))),
          const SizedBox(height: 8),
          ...List.generate(_months.length, (i) {
            final selected = i == _selectedMonth;
            return ListTile(
              title: Text(_months[i],
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF7B5FC4)
                        : const Color(0xFF1A1A2E),
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w400,
                  )),
              trailing: selected
                  ? const Icon(Icons.check_rounded,
                      color: Color(0xFF7B5FC4))
                  : null,
              onTap: () {
                setState(() => _selectedMonth = i);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _filteredGroups;

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
                    onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
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
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.tune_rounded,
                        color: Color(0xFF7B5FC4), size: 18),
                    label: const Text('Filtro',
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
                ],
              ),
            ),

            // ── Título ────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 12),
              child: Text(
                'Extrato Detalhado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7B5FC4),
                ),
              ),
            ),

            // ── Seletor de mês ────────────────────────────
            GestureDetector(
              onTap: _showMonthPicker,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _months[_selectedMonth],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 20, color: Color(0xFF7B5FC4)),
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
                      child: Text(
                        'Nenhuma transação encontrada.',
                        style: TextStyle(
                            color: Color(0xFFB0A8C8), fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      itemCount: groups.length,
                      itemBuilder: (_, gi) {
                        final group = groups[gi];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header do grupo
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

                            // Transações do grupo
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
                                itemBuilder: (_, ti) => _TxTile(
                                    tx: group.transactions[ti]),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
            ),

            // ── Botão Exportar ────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: exportar PDF
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B3DBE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Exportar Extrato (PDF)',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Modelos ──────────────────────────────────────────────────

class _TransactionGroup {
  final String label;
  final List<_TxItem> transactions;
  const _TransactionGroup(
      {required this.label, required this.transactions});
}

class _TxItem {
  final IconData icon;
  final String title;
  final String time;
  final String? extra;
  final String amount;
  final bool isCredit;

  const _TxItem({
    required this.icon,
    required this.title,
    required this.time,
    this.extra,
    required this.amount,
    required this.isCredit,
  });
}

// ── Tile de transação ────────────────────────────────────────

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
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(tx.icon, size: 20, color: const Color(0xFF7B5FC4)),
            ),
            const SizedBox(width: 12),

            // Título + hora + extra
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tx.extra != null
                        ? '${tx.time}  •  ${tx.extra}'
                        : tx.time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0A8C8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Valor + "Ver Detalhes"
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
                const Text(
                  'Ver Detalhes',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFB0A8C8),
                  ),
                ),
              ],
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