import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class BeautyForecastScreen extends StatelessWidget {
  const BeautyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Beauty Forecast'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          GlowSerifTitle('Future Gains', size: 28),
          const SizedBox(height: 8),
          Text(
            'Projected skin improvement if you stay consistent with your regimen.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          GlowSoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Glow Score Trajectory',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '85',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '→ 97 in 90 days',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4A7C59),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _ForecastChartPainter(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Now', '30d', '60d', '90d']
                      .map(
                        (e) => Text(
                          e,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlowSoftCard(
            color: AppColors.surfacePeach,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'AI Forecast Insight',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Based on your current adherence and skin response, we expect '
                  'noticeable pore refinement by day 30 and a brighter, more '
                  'even tone by day 90. Consistency with SPF and night retinoid '
                  'is the strongest predictor of your projected gains.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const GlowMetricBar(label: 'Hydration gain', value: 78, trailing: '+12'),
          const SizedBox(height: 16),
          const GlowMetricBar(label: 'Texture gain', value: 65, trailing: '+9'),
          const SizedBox(height: 16),
          const GlowMetricBar(label: 'Even tone gain', value: 70, trailing: '+11'),
        ],
      ),
    );
  }
}

class _ForecastChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.borderSoft
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final points = [0.55, 0.48, 0.38, 0.28];
    final path = Path();
    final fillPath = Path();
    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.2),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size);

    for (var i = 0; i < points.length; i++) {
      final x = size.width * (i / (points.length - 1));
      final y = size.height * points[i];
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()..color = AppColors.primary,
      );
      canvas.drawCircle(
        Offset(x, y),
        2.5,
        Paint()..color = Colors.white,
      );
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
