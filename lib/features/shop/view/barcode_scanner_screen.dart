import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1513),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Scan Product',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.flash_on_outlined,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          ..._corners(),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              color: AppColors.primary.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Align barcode within the frame',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.glowAnalysis,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'ENTER MANUALLY',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.glowAnalysis,
                    ),
                    child: Text(
                      'Demo: open glow analysis',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.surfacePeach,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _corners() {
    const size = 28.0;
    const thickness = 3.0;
    final color = AppColors.primary;
    Widget corner(Alignment a) {
      return Align(
        alignment: a,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              color: color,
              thickness: thickness,
              alignment: a,
            ),
          ),
        ),
      );
    }

    return [
      corner(Alignment.topLeft),
      corner(Alignment.topRight),
      corner(Alignment.bottomLeft),
      corner(Alignment.bottomRight),
    ];
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({
    required this.color,
    required this.thickness,
    required this.alignment,
  });

  final Color color;
  final double thickness;
  final Alignment alignment;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    if (alignment == Alignment.topLeft) {
      path.moveTo(0, size.height * 0.55);
      path.lineTo(0, 0);
      path.lineTo(size.width * 0.55, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width * 0.45, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height * 0.55);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, size.height * 0.45);
      path.lineTo(0, size.height);
      path.lineTo(size.width * 0.55, size.height);
    } else {
      path.moveTo(size.width * 0.45, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height * 0.45);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
