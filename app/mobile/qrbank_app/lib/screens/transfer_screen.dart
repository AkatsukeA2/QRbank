import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrbank_app/services/transaction_service.dart';
import 'package:qrbank_app/widgets/loading_overlay.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  int _methodIndex = 0; // 0 = IBAN, 1 = QR Code
  String _userId = '';
  String _receiverId = ''; // preenchido pelo QR ou IBAN

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _userId = args['id'] ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  // ── Escanear QR ─────────────────────────────────────────
  void _scanQR() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Aponte para o QR Code',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    final raw = barcode.rawValue;
                    if (raw != null) {
                      Navigator.pop(context);
                      _processQRData(raw);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Processar dados do QR ────────────────────────────────
  void _processQRData(String raw) {
    try {
      // QR gerado no app: {receiver: userId}
      final clean = raw.replaceAll('{', '').replaceAll('}', '');
      final parts = clean.split(':');
      if (parts.length == 2) {
        final receiverId = parts[1].trim();
        setState(() {
          _receiverId = receiverId;
          _ibanController.text = 'QR: $receiverId';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receptor identificado: $receiverId'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR Code inválido.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ── Confirmar transferência ──────────────────────────────
  void _confirmar() {
    if (!_formKey.currentState!.validate()) return;

    final amount = _amountController.text.trim();
    final receiver =
        _methodIndex == 0 ? _ibanController.text.trim() : _receiverId;

    if (receiver.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o receptor.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    // Mostra diálogo de confirmação
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmar Transferência',
            style: TextStyle(
                color: Color(0xFF3D2B7A), fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _confirmRow('Valor', 'Kz $amount'),
            const SizedBox(height: 8),
            _confirmRow(
                'Para',
                receiver.length > 20
                    ? '${receiver.substring(0, 20)}...'
                    : receiver),
            const SizedBox(height: 8),
            _confirmRow(
                'Método', _methodIndex == 0 ? 'IBAN / Conta' : 'QR Code'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Color(0xFF9990B0))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processarTransferencia(amount, receiver);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B5FC4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _confirmRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF9990B0))),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3D2B7A))),
      ],
    );
  }

  // ── Processar transferência ──────────────────────────────
  Future<void> _processarTransferencia(String amount, String receiverId) async {
    setState(() => _isLoading = true);
    try {
      final result = await TransactionService().transfer(
        senderId: _userId,
        receiverId: receiverId,
        amount: amount,
      );

      if (result) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transferência falhou. Tente novamente.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro de conexão. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF4CAF50), size: 36),
            ),
            const SizedBox(height: 16),
            const Text('Transferência Realizada!',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3D2B7A))),
            const SizedBox(height: 8),
            Text('Kz ${_amountController.text} transferido com sucesso.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF9990B0))),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // volta para home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B5FC4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Concluir'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      message: 'Processando transferência...',
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Center(
                  child: Text('Transferências',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7B5FC4))),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campo Valor
                        _buildLabel('Valor (Kz)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[\d,\.]')),
                          ],
                          style: const TextStyle(
                              fontSize: 15, color: Color(0xFF3D2B7A)),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Informe o valor'
                              : null,
                          decoration: _inputDecoration(
                              hint: '0,00',
                              icon: Icons.monetization_on_outlined),
                        ),
                        const SizedBox(height: 28),

                        // Seletor de método
                        _buildLabel('Método de Pagamento'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _MethodCard(
                                icon: Icons.account_balance_outlined,
                                label: 'IBAN / Conta',
                                selected: _methodIndex == 0,
                                onTap: () => setState(() => _methodIndex = 0),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MethodCard(
                                icon: Icons.qr_code_scanner_rounded,
                                label: 'QR Code',
                                selected: _methodIndex == 1,
                                onTap: () => setState(() => _methodIndex = 1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Campo dinâmico por método
                        if (_methodIndex == 0) ...[
                          _buildLabel('IBAN ou Nº de Conta'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _ibanController,
                            style: const TextStyle(
                                fontSize: 15, color: Color(0xFF3D2B7A)),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Informe o IBAN ou conta'
                                : null,
                            decoration: _inputDecoration(
                                hint: 'AO06 0006 0000 0000 0000 1',
                                icon: Icons.badge_outlined),
                          ),
                        ] else ...[
                          // Botão escanear QR
                          GestureDetector(
                            onTap: _scanQR,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _receiverId.isNotEmpty
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFDDD6F3),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _receiverId.isNotEmpty
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.qr_code_scanner_rounded,
                                    size: 48,
                                    color: _receiverId.isNotEmpty
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFF7B5FC4),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _receiverId.isNotEmpty
                                        ? 'QR lido com sucesso!\nToque para ler outro'
                                        : 'Toque para escanear\no QR Code do receptor',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _receiverId.isNotEmpty
                                          ? const Color(0xFF4CAF50)
                                          : const Color(0xFF9990B0),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _confirmar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B5FC4),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              elevation: 0,
                            ),
                            child: const Text('Continuar',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3)),
                          ),
                        ),
                      ],
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

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3D2B7A)));
  }

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB8A8E8), fontSize: 14),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFFB8A8E8)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDD6F3), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
      ),
    );
  }
}

// ── Card de método ───────────────────────────────────────────
class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEDE8F8) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF7B5FC4) : const Color(0xFFDDD6F3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 28,
                color: selected
                    ? const Color(0xFF7B5FC4)
                    : const Color(0xFFB0A8C8)),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? const Color(0xFF7B5FC4)
                        : const Color(0xFFB0A8C8))),
          ],
        ),
      ),
    );
  }
}
