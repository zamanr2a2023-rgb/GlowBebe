import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/features/try_on/model/try_on_models.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class PlacementAdviceScreen extends StatelessWidget {
  const PlacementAdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: TryOnAppBar(
        title: 'GLOW ANALYSIS',
        brandStyle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE5E2E1),
                border: Border.all(color: const Color(0xFFD2C4BE)),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.lookSoftGlam),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
        children: [
          Text(
            'EXPERT PLACEMENT',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: const Color(0xFF805443),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Precision Canvas\nGuidelines',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 40 / 32,
              color: const Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Our AI has analyzed your facial structure. Follow these tailored placement guides to harmonize your features and achieve a luminous, high-editorial finish.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              height: 28 / 18,
              color: const Color(0xFF4E4540),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF805443),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'DOWNLOAD FULL GUIDE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 350,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppAssets.lookNatural, fit: BoxFit.cover),
                  Container(color: const Color(0xFF805443).withValues(alpha: 0.05)),
                  CustomPaint(painter: _GuideLinesPainter()),
                  const Positioned(
                    right: 48,
                    top: 80,
                    child: _FloatingLabel(
                      icon: Icons.auto_awesome,
                      label: 'LIFT ZONE',
                    ),
                  ),
                  const Positioned(
                    left: 24,
                    bottom: 110,
                    child: _FloatingLabel(
                      icon: Icons.timeline,
                      label: 'SCULPT LINE',
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 140,
                    child: Text(
                      'DEFINE ARCH',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black45),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 190,
                    child: Text(
                      'SCULPT CHEEK\nCONTOUR',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        height: 1.3,
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black45),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 28,
                    bottom: 130,
                    child: Text(
                      'LIFT BLUSH',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black45),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          ...TryOnMockData.placementAdvice.map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F2F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5E2D9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            card.icon,
                            size: 18,
                            color: const Color(0xFF695C55),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          card.title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C1B1B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      card.body,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 1.5,
                        color: const Color(0xFF4E4540),
                      ),
                    ),
                    if (card.linkLabel != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        card.linkLabel!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF805443),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF805443),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.cameraMirror),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF805443),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Try-On',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingLabel extends StatelessWidget {
  const _FloatingLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF805443).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF805443)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: const Color(0xFF1C1B1B),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final cx = size.width * 0.52;
    final cy = size.height * 0.48;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: size.width * 0.52,
        height: size.height * 0.62,
      ),
      paint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx - 36, cy + 8),
        width: 74,
        height: 44,
      ),
      0.2,
      2.2,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx + 38, cy + 6),
        width: 74,
        height: 44,
      ),
      1.0,
      2.2,
      false,
      paint,
    );

    // cheek blush lift cues
    final fill = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx + 48, cy + 18), 28, fill);
    canvas.drawCircle(Offset(cx - 44, cy + 22), 24, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
