import 'package:flutter/material.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinScanCameraScreen extends StatelessWidget {
  const SkinScanCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1614),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
            ),
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Text(
                'Align your face',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: CustomPaint(
                size: const Size(280, 360),
                painter: _OvalGuidePainter(),
                child: SizedBox(
                  width: 280,
                  height: 360,
                  child: Center(
                    child: Icon(
                      Icons.face_outlined,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Column(
                children: [
                  Text(
                    'Hold steady · Soft light preferred',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.skinScanConfirm,
                    ),
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4A574),
                          width: 3,
                        ),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
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
}

class _OvalGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    final paint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawOval(rect, paint);

    final dash = Paint()
      ..color = const Color(0xFFD4A574).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawOval(rect.inflate(10), dash);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
