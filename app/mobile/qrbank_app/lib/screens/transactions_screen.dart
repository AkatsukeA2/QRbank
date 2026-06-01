import 'package:flutter/material.dart';
import 'package:qrbank_app/model/transaction.dart';
import 'package:qrbank_app/model/tx_item.dart';
import 'package:qrbank_app/services/transaction_service.dart';
import 'package:qrbank_app/services/user_service.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionsScreen> {
  int _filterIndex = 0;
  bool isLoading = false;
  final List<String> _filters = ['Todos', 'Entradas', 'Saídas'];
  List<Transaction> _transactions = [];
  List<TxGroup> _allGroups = []; // <-- dinâmico, não final

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_transactions.isEmpty) {
      _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    setState(() => isLoading = true);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    try {
      final transactions =
          await TransactionService().getTransactionsByUserId(args['id']);

      // Agrupa por data
      final Map<String, List<Transaction>> grouped = {};
      for (final tx in transactions) {
        final dateKey = '${tx.createdAt.day.toString().padLeft(2, '0')} / '
            '${tx.createdAt.month.toString().padLeft(2, '0')} / '
            '${tx.createdAt.year}';
        grouped.putIfAbsent(dateKey, () => []).add(tx);
      }

      setState(() {
        _transactions = transactions;
        _allGroups = grouped.entries
            .map((e) => TxGroup(label: e.key, transactions: e.value))
            .toList();
      });
    } catch (e) {
      setState(() {
        _transactions = [];
        _allGroups = [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<TxGroup> get _filtered {
    if (_filterIndex == 0) return _allGroups;
    return _allGroups
        .map((g) {
          final txs = g.transactions.where((tx) {
            if (_filterIndex == 1) return tx.type == 'CREDIT';
            return tx.type != 'CREDIT';
          }).toList();
          if (txs.isEmpty) return null;
          return TxGroup(label: g.label, transactions: txs);
        })
        .whereType<TxGroup>()
        .toList();
  }

  // Totais direto das transações — amount vem como número da API
  double get _totalEntradas => _transactions
      .where((tx) => tx.type == 'CREDIT')
      .fold(0, (sum, tx) => sum + (double.tryParse(tx.amount) ?? 0));

  double get _totalSaidas => _transactions
      .where((tx) => tx.type != 'CREDIT')
      .fold(0, (sum, tx) => sum + (double.tryParse(tx.amount) ?? 0));

  @override
  Widget build(BuildContext context) {
    final groups = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7B5FC4)),
            )
          : SafeArea(
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
                                    TxTile(tx: group.transactions[ti]),
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
              color: color.withValues(alpha: 0.15),
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

