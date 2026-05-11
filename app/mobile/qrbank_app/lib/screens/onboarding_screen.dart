// ============================================================
// ONBOARDING SCREEN
// ============================================================
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qrbank_app/screens/login_screen.dart';
import 'package:qrbank_app/widgets/top_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _contentController;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: 'Pague com um Scan',
      description:
          'Faça pagamentos de forma rápida e segura escaneando o QR Code do estabelecimento.',
    ),
    _OnboardingData(
      title: 'Transferências Instantâneas',
      description:
          'Envie e receba dinheiro na hora, a qualquer momento, com total segurança.',
    ),
    _OnboardingData(
      title: 'Controle Total',
      description:
          'Acompanhe seu saldo, extrato e todas as movimentações em um só lugar.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _contentFade =
        CurvedAnimation(parent: _contentController, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _contentController, curve: Curves.easeOut));

    _contentController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _contentController.reverse().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        setState(() => _currentPage++);
        _contentController.forward();
      });
    } else {
      // TODO: navegar para login ou home
     Navigator.of(context).pushReplacementNamed(
        '/login',
        // MaterialPageRoute(builder: (_) => const LoginScreen()), --- IGNORE ---
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          children: [
            // Botão Pular
            const TopText(text: 'Pular', route: '/login', paddingRight: 24),

            // Ilustração
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _OnboardingIllustration(index: index),
                ),
              ),
            ),

            // Texto + botão
            Expanded(
              flex: 4,
              child: FadeTransition(
                opacity: _contentFade,
                child: SlideTransition(
                  position: _contentSlide,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          _pages[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3D2B7A),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[_currentPage].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF9990B0),
                            height: 1.6,
                          ),
                        ),
                        const Spacer(),
                        // Indicadores de página
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (i) => _PageDot(isActive: i == _currentPage),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Botão Próximo / Começar
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B5FC4),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _currentPage < _pages.length - 1
                                  ? 'Próximo'
                                  : 'Começar',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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

class _PageDot extends StatelessWidget {
  final bool isActive;
  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF7B5FC4) : const Color(0xFFD0C4F0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  const _OnboardingData({required this.title, required this.description});
}

// ============================================================
// ILUSTRAÇÕES
// ============================================================

class _OnboardingIllustration extends StatelessWidget {
  final int index;
  const _OnboardingIllustration({required this.index});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _IllustrationPainter(index: index),
      size: Size.infinite,
    );
  }
}


class _IllustrationPainter extends CustomPainter {
  final int index;
  _IllustrationPainter({required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF8B6FD4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()
      ..color = const Color(0xFF8B6FD4)
      ..style = PaintingStyle.fill;

    switch (index) {
      case 0:
        _drawShopScan(canvas, size, line, fill);
        break;
      case 1:
        _drawTransfer(canvas, size, line, fill);
        break;
      default:
        _drawDashboard(canvas, size, line, fill);
    }
  }

  void _drawShopScan(Canvas canvas, Size size, Paint line, Paint fill) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 300;

    // Loja
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 80 * s, cy - 60 * s, 140 * s, 110 * s),
        Radius.circular(8 * s),
      ),
      line,
    );

    // Toldo
    final awningPath = Path()
      ..moveTo(cx - 90 * s, cy - 30 * s)
      ..lineTo(cx, cy - 90 * s)
      ..lineTo(cx + 90 * s, cy - 30 * s);
    canvas.drawPath(awningPath, line);

    for (int i = 1; i < 5; i++) {
      final x = cx - 80 * s + (140 * s / 5) * i;
      canvas.drawLine(
        Offset(x, cy - 85 * s),
        Offset(x, cy - 32 * s),
        line,
      );
    }

    // QR na loja
    _drawMiniQr(canvas, fill, Offset(cx - 50 * s, cy - 45 * s), 55 * s);

    // Celular
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 20 * s, cy - 20 * s, 55 * s, 80 * s),
        Radius.circular(10 * s),
      ),
      line,
    );

    _drawMiniQr(canvas, fill, Offset(cx + 28 * s, cy - 5 * s), 38 * s);

    // Mão segurando o celular
    canvas.drawArc(
      Rect.fromLTWH(cx + 10 * s, cy + 45 * s, 20 * s, 28 * s),
      math.pi * 0.5,
      math.pi,
      false,
      line,
    );
    canvas.drawArc(
      Rect.fromLTWH(cx + 18 * s, cy + 52 * s, 16 * s, 22 * s),
      math.pi * 0.5,
      math.pi,
      false,
      line,
    );
  }

  void _drawMiniQr(Canvas canvas, Paint fill, Offset topLeft, double size) {
    final c = size / 5;

    for (final corner in [
      topLeft,
      Offset(topLeft.dx + c * 3, topLeft.dy),
      Offset(topLeft.dx, topLeft.dy + c * 3),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(corner.dx, corner.dy, c * 1.8, c * 1.8),
            Radius.circular(c * 0.2)),
        fill,
      );
      canvas.drawRect(
        Rect.fromLTWH(
            corner.dx + c * 0.25, corner.dy + c * 0.25, c * 1.3, c * 1.3),
        Paint()..color = const Color(0xFFF5F5FA),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                corner.dx + c * 0.5, corner.dy + c * 0.5, c * 0.8, c * 0.8),
            Radius.circular(c * 0.1)),
        fill,
      );
    }

    for (final dot in [
      Offset(topLeft.dx + c * 2.2, topLeft.dy + c * 0.5),
      Offset(topLeft.dx + c * 2.2, topLeft.dy + c * 1.2),
      Offset(topLeft.dx + c * 3.5, topLeft.dy + c * 2.2),
      Offset(topLeft.dx + c * 2.2, topLeft.dy + c * 2.8),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(dot.dx, dot.dy, c * 0.7, c * 0.7),
            Radius.circular(c * 0.1)),
        fill,
      );
    }
  }

  void _drawTransfer(Canvas canvas, Size size, Paint line, Paint fill) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 300;

    for (int i = 0; i < 2; i++) {
      final px = (i == 0) ? cx - 90 * s : cx + 35 * s;
      final py = cy - 50 * s;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(px, py, 55 * s, 90 * s),
          Radius.circular(10 * s),
        ),
        line,
      );

      final bar = Paint()
        ..color = const Color(0xFFD0C4F0)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(px + 8 * s, py + 15 * s, 38 * s, 8 * s),
            Radius.circular(4 * s)),
        bar,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(px + 12 * s, py + 30 * s, 28 * s, 6 * s),
            Radius.circular(3 * s)),
        bar,
      );
    }

    // Seta
    canvas.drawLine(Offset(cx - 30 * s, cy), Offset(cx + 28 * s, cy), line);
    final arrowPath = Path()
      ..moveTo(cx + 35 * s, cy)
      ..lineTo(cx + 22 * s, cy - 7 * s)
      ..lineTo(cx + 22 * s, cy + 7 * s)
      ..close();
    canvas.drawPath(arrowPath, fill);

    // Raio
    final boltPath = Path()
      ..moveTo(cx + 3 * s, cy - 22 * s)
      ..lineTo(cx - 3 * s, cy - 12 * s)
      ..lineTo(cx + 1 * s, cy - 12 * s)
      ..lineTo(cx - 3 * s, cy - 2 * s)
      ..lineTo(cx + 3 * s, cy - 12 * s)
      ..lineTo(cx - 1 * s, cy - 12 * s)
      ..close();
    canvas.drawPath(boltPath, fill);
  }

  void _drawDashboard(Canvas canvas, Size size, Paint line, Paint fill) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 300;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 65 * s, cy - 90 * s, 130 * s, 180 * s),
        Radius.circular(16 * s),
      ),
      line,
    );

    // Card de saldo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 55 * s, cy - 80 * s, 110 * s, 50 * s),
        Radius.circular(10 * s),
      ),
      Paint()
        ..color = const Color(0xFFEDE8F8)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - 40 * s, cy - 68 * s, 60 * s, 8 * s),
          Radius.circular(4 * s)),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - 30 * s, cy - 53 * s, 40 * s, 6 * s),
          Radius.circular(3 * s)),
      Paint()
        ..color = const Color(0xFFB8A8E8)
        ..style = PaintingStyle.fill,
    );

    // Transações
    for (int i = 0; i < 3; i++) {
      final y = cy - 15 * s + i * 18 * s;
      canvas.drawCircle(
        Offset(cx - 45 * s, y + 5 * s),
        5 * s,
        Paint()
          ..color = const Color(0xFFD0C4F0)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(cx - 35 * s, y, 45 * s, 10 * s),
            Radius.circular(4 * s)),
        Paint()
          ..color = const Color(0xFFD0C4F0)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(cx + 18 * s, y, 25 * s, 10 * s),
            Radius.circular(4 * s)),
        Paint()
          ..color =
              i % 2 == 0 ? const Color(0xFF8B6FD4) : const Color(0xFFD0C4F0)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
