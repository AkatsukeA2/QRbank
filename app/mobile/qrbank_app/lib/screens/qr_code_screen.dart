import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen>
    with SingleTickerProviderStateMixin {
  bool _qrGenerated = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  // Valor opcional para gerar QR específico
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _gerar() {
    setState(() => _qrGenerated = true);
    _animController.forward(from: 0);
  }

  void _copiarChave() {
    Clipboard.setData(const ClipboardData(text: 'joao.pedro@qrbank.com'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chave Pix copiada!'),
        backgroundColor: const Color(0xFF7B5FC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
              child: Row(
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
                  const SizedBox(width: 12),
                  const Text(
                    'QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // ── Conteúdo ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Título secção ─────────────────────
                    const Text(
                      'Gerar Meu QR',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Card info do perfil ────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFEDE8F8), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE8F8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.person_rounded,
                                    size: 28, color: Color(0xFF9B72E8)),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7B5FC4),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(Icons.qr_code_rounded,
                                        size: 11, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Meu Código QR',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF7B5FC4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Crie um código para\nreceber pagamentos',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9990B0),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Campo valor opcional ───────────────
                    const Text(
                      'Valor (opcional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3D2B7A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d,\.]')),
                      ],
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF3D2B7A)),
                      decoration: InputDecoration(
                        hintText: 'R\$ 0,00',
                        hintStyle: const TextStyle(
                            color: Color(0xFFB8A8E8), fontSize: 14),
                        prefixIcon: const Icon(Icons.monetization_on_outlined,
                            size: 20, color: Color(0xFFB8A8E8)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFDDD6F3), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF7B5FC4), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Preview do QR ─────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _qrGenerated
                          ? FadeTransition(
                              key: const ValueKey('qr'),
                              opacity: _fadeAnim,
                              child: ScaleTransition(
                                scale: _scaleAnim,
                                child: _QrPreviewCard(onCopy: _copiarChave),
                              ),
                            )
                          : _QrPlaceholder(key: const ValueKey('placeholder')),
                    ),
                    const SizedBox(height: 20),

                    // ── Chave Pix ─────────────────────────
                    if (_qrGenerated) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE8F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.key_rounded,
                                size: 18, color: Color(0xFF7B5FC4)),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'joao.pedro@qrbank.com',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF5B3DBE),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _copiarChave,
                              child: const Icon(Icons.copy_rounded,
                                  size: 18, color: Color(0xFF7B5FC4)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),

            // ── Botão ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _gerar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B3DBE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _qrGenerated
                        ? 'Gerar Novo Código QR'
                        : 'Gerar Código QR para Receber',
                    style: const TextStyle(
                      fontSize: 16,
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

// ── QR Placeholder (antes de gerar) ──────────────────────────

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.qr_code_2_rounded, size: 56, color: Color(0xFFB8A8E8)),
          SizedBox(height: 8),
          Text(
            'Seu QR aparecerá aqui',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFB8A8E8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── QR Preview Card (após gerar) ─────────────────────────────

class _QrPreviewCard extends StatelessWidget {
  final VoidCallback onCopy;
  const _QrPreviewCard({required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // QR code desenhado com CustomPainter
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B5FC4).withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _QrPainter(),
              size: const Size(140, 140),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'João Pedro',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3D2B7A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'QrBank • Pix',
            style: TextStyle(fontSize: 13, color: Color(0xFF9990B0)),
          ),
          const SizedBox(height: 14),
          // Botão compartilhar
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_rounded,
                size: 16, color: Color(0xFF7B5FC4)),
            label: const Text('Compartilhar',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7B5FC4),
                    fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF7B5FC4), width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

// ── QR Painter ────────────────────────────────────────────────

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final cell = w / 10;

    // Três cantos de posicionamento
    for (final offset in [
      Offset(0, 0),
      Offset(w - cell * 3, 0),
      Offset(0, w - cell * 3),
    ]) {
      _corner(canvas, fill, offset, cell * 3);
    }

    // Padrão de dados (grid simulado)
    final rng = math.Random(42);
    for (int row = 0; row < 10; row++) {
      for (int col = 0; col < 10; col++) {
        // Pular cantos de posicionamento
        if (row < 4 && col < 4) continue;
        if (row < 4 && col >= 7) continue;
        if (row >= 7 && col < 4) continue;

        if (rng.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(col * cell + 1, row * cell + 1, cell - 2, cell - 2),
            fill,
          );
        }
      }
    }
  }

  void _corner(Canvas canvas, Paint fill, Offset pos, double size) {
    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Quadrado externo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(pos.dx, pos.dy, size, size),
        Radius.circular(size * 0.18),
      ),
      fill,
    );
    // Branco interno
    final gap = size * 0.2;
    canvas.drawRect(
      Rect.fromLTWH(pos.dx + gap, pos.dy + gap, size - gap * 2, size - gap * 2),
      white,
    );
    // Quadrado central
    final inner = gap * 1.8;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            pos.dx + inner, pos.dy + inner, size - inner * 2, size - inner * 2),
        Radius.circular(size * 0.08),
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
