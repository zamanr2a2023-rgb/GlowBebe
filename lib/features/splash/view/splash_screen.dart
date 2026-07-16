import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

/// Splash matching Figma:
/// clean round logo · title · tagline · progress 0% → 100% left-to-right
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    // Smooth fill from first (0) to last (1)
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.onboarding);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Column(
              children: [
                // Perfect round logo only — no outer glow ring
                ClipOval(
                  child: Image.asset(
                    AppAssets.elegantLogo,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'GlowBéBé Beauty',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    height: 34 / 28,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'GLOW, BÉBÉ, GLOW!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.4,
                    color: AppColors.textSecondary.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 4),
            Padding(
              padding: const EdgeInsets.fromLTRB(64, 0, 64, 56),
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) {
                  final value = _progress.value.clamp(0.0, 1.0);
                  final pct = (value * 100).round().clamp(0, 100);
                  return Column(
                    children: [
                      SizedBox(
                        height: 2,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _ProgressLinePainter(value: value),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Opacity(
                        opacity: 0.55,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'CALIBRATING NEURAL SENSOR',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.6,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Text(
                              '$pct%',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
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

/// Thin track; fill grows left → right from 0% to 100%.
class _ProgressLinePainter extends CustomPainter {
  _ProgressLinePainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;

    final track = Paint()
      ..color = const Color(0xFFD2C4BE).withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, y), Offset(size.width, y), track);

    final endX = size.width * value;
    if (endX > 0.5) {
      canvas.drawLine(Offset(0, y), Offset(endX, y), fill);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressLinePainter oldDelegate) =>
      oldDelegate.value != value;
}
