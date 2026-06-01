import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qrbank_app/model/transaction.dart';
import 'package:qrbank_app/services/transaction_service.dart';

class ExtratoScreen extends StatefulWidget {
  const ExtratoScreen({super.key});

  @override
  State<ExtratoScreen> createState() => _ExtratoScreenState();
}

class _ExtratoScreenState extends State<ExtratoScreen> {
  int _filterIndex = 0;
  bool _isLoading = false;
  final List<String> _filters = ['Todos', 'Entradas', 'Saídas'];

  List<Transaction> _transactions = [];
  List<_TransactionGroup> _allGroups = [];

  String _userId = '';
  String _userName = 'Usuário';

  // Meses para o picker
  late List<String> _months;
  int _selectedMonth = 0;

  @override
  void initState() {
    super.initState();
    // Gera últimos 6 meses
    final now = DateTime.now();
    _months = List.generate(6, (i) {
      final d = DateTime(now.year, now.month - i);
      const mNames = [
        '',
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro'
      ];
      return '${mNames[d.month]} ${d.year}';
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _userId.isEmpty) {
      _userId = args['id'] ?? '';
      _userName = args['name'] ?? 'Usuário';
      _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final transactions =
          await TransactionService().getTransactionsByUserId(_userId);

      // Agrupa por data
      final Map<String, List<Transaction>> grouped = {};
      for (final tx in transactions) {
        final dateKey = '${tx.createdAt.day.toString().padLeft(2, '0')}/'
            '${tx.createdAt.month.toString().padLeft(2, '0')}/'
            '${tx.createdAt.year}';
        grouped.putIfAbsent(dateKey, () => []).add(tx);
      }

      setState(() {
        _transactions = transactions;
        _allGroups = grouped.entries
            .map((e) => _TransactionGroup(label: e.key, transactions: e.value))
            .toList();
      });
    } catch (e) {
      setState(() {
        _transactions = [];
        _allGroups = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<_TransactionGroup> get _filteredGroups {
    if (_filterIndex == 0) return _allGroups;
    return _allGroups
        .map((g) {
          final txs = g.transactions.where((tx) {
            if (_filterIndex == 1) return tx.type == 'CREDIT';
            return tx.type != 'CREDIT';
          }).toList();
          if (txs.isEmpty) return null;
          return _TransactionGroup(label: g.label, transactions: txs);
        })
        .whereType<_TransactionGroup>()
        .toList();
  }

  double get _totalEntradas => _transactions
      .where((tx) => tx.type == 'CREDIT')
      .fold(0, (sum, tx) => sum + (double.tryParse(tx.amount) ?? 0));

  double get _totalSaidas => _transactions
      .where((tx) => tx.type != 'CREDIT')
      .fold(0, (sum, tx) => sum + (double.tryParse(tx.amount) ?? 0));

  // ── Geração do PDF ──────────────────────────────────────
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Cabeçalho
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('QRBank',
                      style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.deepPurple)),
                  pw.Text('Extrato Detalhado',
                      style: const pw.TextStyle(
                          fontSize: 14, color: PdfColors.grey600)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(_userName,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    'Gerado em ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style:
                        const pw.TextStyle(fontSize: 11, color: PdfColors.grey),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.deepPurple200),
          pw.SizedBox(height: 8),

          // Resumo
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Entradas',
                          style: pw.TextStyle(
                              color: PdfColors.green800,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        'Kz ${_totalEntradas.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.green800,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.red50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Saídas',
                          style: pw.TextStyle(
                              color: PdfColors.red800,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        'Kz ${_totalSaidas.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.red800,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // Tabela de transações
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
            },
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
                children: [
                  _pdfCell('Descrição', isHeader: true),
                  _pdfCell('Data', isHeader: true),
                  _pdfCell('Tipo', isHeader: true),
                  _pdfCell('Valor', isHeader: true),
                ],
              ),
              // Linhas
              ..._transactions.map((tx) => pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: _transactions.indexOf(tx) % 2 == 0
                          ? PdfColors.white
                          : PdfColors.grey100,
                    ),
                    children: [
                      _pdfCell(tx.title ?? 'Transação'),
                      _pdfCell(
                        '${tx.createdAt.day.toString().padLeft(2, '0')}/'
                        '${tx.createdAt.month.toString().padLeft(2, '0')}/'
                        '${tx.createdAt.year}',
                      ),
                      _pdfCell(tx.type),
                      _pdfCell(
                        '${tx.type == 'CREDIT' ? '+' : '-'} Kz ${tx.amount}',
                        color: tx.type == 'CREDIT'
                            ? PdfColors.green800
                            : PdfColors.red800,
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfCell(String text, {bool isHeader = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : (color ?? PdfColors.black),
        ),
      ),
    );
  }

  void _exportPdf() async {
    setState(() => _isLoading = true);
    try {
      final bytes = await _generatePdf();
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: 'extrato_qrbank.pdf',
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  )),
              trailing: selected
                  ? const Icon(Icons.check_rounded, color: Color(0xFF7B5FC4))
                  : null,
              onTap: () {
                setState(() => _selectedMonth = i);
                Navigator.pop(context);
                // TODO: recarregar transações do mês selecionado
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
                        TextButton.icon(
                          onPressed: _showMonthPicker,
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

                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Text('Extrato Detalhado',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7B5FC4))),
                  ),

                  // Seletor de mês
                  GestureDetector(
                    onTap: _showMonthPicker,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_months[_selectedMonth],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A2E))),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: Color(0xFF7B5FC4)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chips de filtro
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
                              child: Text(_filters[i],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? Colors.white
                                        : const Color(0xFF9990B0),
                                  )),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Lista
                  Expanded(
                    child: groups.isEmpty
                        ? const Center(
                            child: Text('Nenhuma transação encontrada.',
                                style: TextStyle(
                                    color: Color(0xFFB0A8C8), fontSize: 14)))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            itemCount: groups.length,
                            itemBuilder: (_, gi) {
                              final group = groups[gi];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    child: Text(group.label,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF5B3DBE))),
                                  ),
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
                                      separatorBuilder: (_, __) =>
                                          const Divider(
                                              height: 1,
                                              indent: 60,
                                              endIndent: 12,
                                              color: Color(0xFFF0EBF8)),
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

                  // Botão exportar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _transactions.isEmpty ? null : _exportPdf,
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('Exportar Extrato (PDF)',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B3DBE),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFB0A8C8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          elevation: 0,
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

// Modelos internos
class _TransactionGroup {
  final String label;
  final List<Transaction> transactions;
  const _TransactionGroup({required this.label, required this.transactions});
}

// Tile interno usando Transaction
class _TxTile extends StatelessWidget {
  final Transaction tx;
  const _TxTile({required this.tx});

  _TileStyle _resolveStyle() {
    switch (tx.type) {
      case 'CREDIT':
        return _TileStyle(
          subtitle: 'Recebido',
          iconColor: const Color(0xFFE8F5E9),
          iconFgColor: const Color(0xFF4CAF50),
          icon: Icons.arrow_downward_rounded,
          isCredit: true,
        );
      case 'DEBIT':
        return _TileStyle(
          subtitle: 'Pago',
          iconColor: const Color(0xFFFFEBEE),
          iconFgColor: const Color(0xFFF44336),
          icon: Icons.swap_horiz_rounded,
          isCredit: false,
        );
      case 'WITHDRAW':
        return _TileStyle(
          subtitle: 'Levantado',
          iconColor: const Color(0xFFFFEBEE),
          iconFgColor: const Color(0xFFE53935),
          icon: Icons.money_off_csred_rounded,
          isCredit: false,
        );
      default:
        return _TileStyle(
          subtitle: tx.type,
          iconColor: const Color(0xFFEDE8F8),
          iconFgColor: const Color(0xFF7B5FC4),
          icon: Icons.receipt_outlined,
          isCredit: false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: style.iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(style.icon, size: 20, color: style.iconFgColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title ?? 'Transação',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    '${style.subtitle}  •  '
                    '${tx.createdAt.day.toString().padLeft(2, '0')}/'
                    '${tx.createdAt.month.toString().padLeft(2, '0')}/'
                    '${tx.createdAt.year}',
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xFFB0A8C8)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${style.isCredit ? '+' : '-'} Kz ${tx.amount}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: style.isCredit
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 2),
                const Text('Ver Detalhes',
                    style: TextStyle(fontSize: 10, color: Color(0xFFB0A8C8))),
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

class _TileStyle {
  final String subtitle;
  final Color iconColor;
  final Color iconFgColor;
  final IconData icon;
  final bool isCredit;
  _TileStyle({
    required this.subtitle,
    required this.iconColor,
    required this.iconFgColor,
    required this.icon,
    required this.isCredit,
  });
}
