// ============================================================
// SPLASH SCREEN
// ============================================================
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qrbank_app/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const QrBankLogo(size: 80),
                const SizedBox(height: 20),
                const Text(
                  'QrBank',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B6FD4),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 60),
                const _LoadingIndicator(),
                const SizedBox(height: 12),
                const Text(
                  'Carregando...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB8A8E8),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Loading spinner ----

class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator();

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotateController,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CustomPaint(painter: _DotCirclePainter()),
      ),
    );
  }
}

class _DotCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFFB8A8E8);
    const dotCount = 10;
    final radius = size.width / 2;
    final dotRadius = size.width * 0.06;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi;
      final opacity = i / dotCount;
      final paint = Paint()..color = color.withOpacity(0.2 + opacity * 0.8);
      final x = radius + (radius - dotRadius * 2) * math.cos(angle);
      final y = radius + (radius - dotRadius * 2) * math.sin(angle);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---- QrBank Logo ----

class QrBankLogo extends StatelessWidget {
  final double size;
  const QrBankLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _QrBankLogoPainter()),
    );
  }
}

class _QrBankLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B6FD4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Q circle
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.35, h * 0.45), radius: w * 0.25),
      0,
      2 * math.pi,
      false,
      paint,
    );

    // Q tail
    canvas.drawLine(
      Offset(w * 0.52, h * 0.62),
      Offset(w * 0.62, h * 0.72),
      Paint()
        ..color = const Color(0xFF8B6FD4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.05
        ..strokeCap = StrokeCap.round,
    );

    // QR pattern (right side)
    final fill = Paint()
      ..color = const Color(0xFF8B6FD4)
      ..style = PaintingStyle.fill;

    final qrLeft = w * 0.52;
    final qrTop = h * 0.18;
    final cellSize = w * 0.085;

    for (final corner in [
      Offset(qrLeft, qrTop),
      Offset(qrLeft + cellSize * 2.2, qrTop),
      Offset(qrLeft, qrTop + cellSize * 2.2),
    ]) {
      _drawQrCorner(canvas, fill, corner, cellSize * 1.4);
    }

    for (final pos in [
      Offset(qrLeft + cellSize * 1.1, qrTop + cellSize * 1.1),
      Offset(qrLeft + cellSize * 2.2, qrTop + cellSize * 1.1),
      Offset(qrLeft + cellSize * 1.1, qrTop + cellSize * 2.2),
      Offset(qrLeft + cellSize * 2.5, qrTop + cellSize * 2.5),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pos.dx, pos.dy, cellSize * 0.8, cellSize * 0.8),
          Radius.circular(cellSize * 0.15),
        ),
        fill,
      );
    }
  }

  void _drawQrCorner(Canvas canvas, Paint fill, Offset topLeft, double size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(topLeft.dx, topLeft.dy, size, size),
        Radius.circular(size * 0.2),
      ),
      fill,
    );
    canvas.drawRect(
      Rect.fromLTWH(topLeft.dx + size * 0.18, topLeft.dy + size * 0.18,
          size * 0.64, size * 0.64),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(topLeft.dx + size * 0.36, topLeft.dy + size * 0.36,
            size * 0.28, size * 0.28),
        Radius.circular(size * 0.06),
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
