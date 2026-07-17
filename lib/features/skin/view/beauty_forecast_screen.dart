import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class BeautyForecastScreen extends StatelessWidget {
  const BeautyForecastScreen({super.key});

  static const _stats = <(String, String)>[
    ('30 Days', '+12%'),
    ('60 Days', '+22%'),
    ('90 Days', '+35%'),
  ];

  void _onNavTap(BuildContext context, int index) {
    Navigator.pushReplacementNamed(
      context,
      RouteNames.mainShell,
      arguments: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 64,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
            color: AppColors.iconMuted,
          ),
        ),
        title: Text(
          'BEAUTY FORECAST',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.notifications),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.iconMuted,
            ),
          ),
        ],
        backgroundColor: AppColors.background.withValues(alpha: 0.92),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          GlowSoftCard(
            color: const Color(0xFFFAF3EE),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'SKIN HEALTH\nPREDICTION',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          height: 1.5,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '90-DAY HORIZON',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Future Gains',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _ForecastCurvePainter(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final (label, bold) in const [
                      ('Today', false),
                      ('30d', false),
                      ('60d', false),
                      ('90d', true),
                    ])
                      Text(
                        label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight:
                              bold ? FontWeight.w700 : FontWeight.w400,
                          color: bold
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < _stats.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDE8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _stats[i].$1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _stats[i].$2,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 18,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 10),
              Text(
                'AI Forecast Insight',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.surfacePeach.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '"By maintaining your current Vitamin C protocol, we project '
              'a 35% reduction in localized redness over the next 3 months. '
              'Your barrier resilience is trending 15% higher than the '
              'seasonal average for your skin profile."',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    width: 64,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GlowBottomNav(
        currentIndex: 0,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

class _ForecastCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Upward accelerating curve: starts low-left, ends high-right.
    final start = Offset(0, size.height * 0.88);
    final end = Offset(size.width, size.height * 0.06);
    final control = Offset(size.width * 0.62, size.height * 0.95);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    canvas.drawPath(path, line);

    // Dots at 30d / 60d / 90d along the curve.
    for (final t in const [0.33, 0.66, 1.0]) {
      final oneMinusT = 1 - t;
      final x = oneMinusT * oneMinusT * start.dx +
          2 * oneMinusT * t * control.dx +
          t * t * end.dx;
      final y = oneMinusT * oneMinusT * start.dy +
          2 * oneMinusT * t * control.dy +
          t * t * end.dy;
      canvas.drawCircle(
        Offset(x, y),
        t == 1.0 ? 6 : 4.5,
        Paint()..color = AppColors.primary,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
