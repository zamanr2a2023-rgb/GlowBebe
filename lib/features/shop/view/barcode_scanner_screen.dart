import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.productBakuchiol,
            fit: BoxFit.cover,
            color: Colors.white.withValues(alpha: 0.25),
            colorBlendMode: BlendMode.saturation,
            errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black),
          ),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.55),
              BlendMode.darken,
            ),
            child: const SizedBox.expand(),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      _GlassCircleButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.maybePop(context),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'AURA SCANNER',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _GlassCircleButton(
                        icon: Icons.flash_on_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 280,
                  height: 200,
                  child: CustomPaint(
                    painter: _ScanFramePainter(),
                    child: Center(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFFFFC5AF),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFC5AF)
                                  .withValues(alpha: 0.8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        'Align barcode within the frame',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Hold steady for an instant Aura Match',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 230,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            RouteNames.glowAnalysis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shape: const StadiumBorder(),
                          ),
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          label: Text(
                            'SCAN PRODUCT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 224,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _GlassCircleButton(
                              size: 40,
                              icon: Icons.image_outlined,
                              onTap: () {},
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: const LinearProgressIndicator(
                                    value: 0.36,
                                    minHeight: 4,
                                    backgroundColor: Color(0x33FFFFFF),
                                    color: Color(0xFFFFC5AF),
                                  ),
                                ),
                              ),
                            ),
                            _GlassCircleButton(
                              size: 40,
                              icon: Icons.keyboard_outlined,
                              onTap: () => Navigator.pushNamed(
                                context,
                                RouteNames.glowAnalysis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RouteNames.glowAnalysis,
                        ),
                        child: Text(
                          'Enter code manually',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: const Color(0xFFFFC5AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({
    required this.icon,
    required this.onTap,
    this.size = 48,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: size * 0.38, color: Colors.white),
        ),
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC5AF)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const corner = 32.0;
    // top-left
    canvas.drawLine(const Offset(0, corner), Offset.zero, paint);
    canvas.drawLine(Offset.zero, const Offset(corner, 0), paint);
    // top-right
    canvas.drawLine(Offset(size.width - corner, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, corner), paint);
    // bottom-left
    canvas.drawLine(
      Offset(0, size.height - corner),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(corner, size.height),
      paint,
    );
    // bottom-right
    canvas.drawLine(
      Offset(size.width - corner, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - corner),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
