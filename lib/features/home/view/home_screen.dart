import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: !embedded,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, embedded ? 100 : 32),
          children: [
            _HomeHeader(
              onProfile: () =>
                  Navigator.pushNamed(context, RouteNames.profile),
              onNotify: () =>
                  Navigator.pushNamed(context, RouteNames.notifications),
            ),
            const SizedBox(height: 24),
            _GlowScoreCard(
              onDetails: () =>
                  Navigator.pushNamed(context, RouteNames.skinEvolution),
            ),
            const SizedBox(height: 16),
            _CoachInsightCard(
              onDetails: () =>
                  Navigator.pushNamed(context, RouteNames.skinEvolution),
            ),
            const SizedBox(height: 28),
            _ProgressSection(
              onJournal: () =>
                  Navigator.pushNamed(context, RouteNames.skinEvolution),
            ),
            const SizedBox(height: 28),
            _BeautyForecastMini(
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.beautyForecast),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Daily Protocol',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.todaysRoutine),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _DailyProtocolCard(),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Prescribed For You',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.recommendations),
                  child: Text(
                    'Shop All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _ProductRow(),
          ],
        ),
      ),
    );
  }
}

// ─── Header (Figma: avatar · Lumière AI · bell) ─────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onProfile, required this.onNotify});

  final VoidCallback onProfile;
  final VoidCallback onNotify;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onProfile,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD2C4BE).withValues(alpha: 0.5),
              ),
              image: const DecorationImage(
                image: AssetImage(AppAssets.profileAvatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Lumière AI',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: 0.3,
            ),
          ),
        ),
        IconButton(
          onPressed: onNotify,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: const Color(0xFFD2C4BE).withValues(alpha: 0.4),
            ),
          ),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.iconMuted,
          ),
        ),
      ],
    );
  }
}

// ─── AI Glow Score — centered ring (Figma) ──────────────────────────────────

class _GlowScoreCard extends StatelessWidget {
  const _GlowScoreCard({required this.onDetails});

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return GlowSoftCard(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        children: [
          Text(
            'AI GLOW SCORE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 22),
          const GlowScoreRing(
            score: 85,
            size: 176,
            label: 'EXCELLENT',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.trending_up, size: 16, color: Color(0xFF4A7C59)),
              const SizedBox(width: 6),
              Text(
                '+5 improvement in last 30 days',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4A7C59),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your skin improved by 12% this month',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onDetails,
            child: Text(
              'VIEW DETAILS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
                decorationThickness: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AI Coach Insight ───────────────────────────────────────────────────────

class _CoachInsightCard extends StatelessWidget {
  const _CoachInsightCard({required this.onDetails});

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return GlowSoftCard(
      color: AppColors.surfacePeach,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AI COACH INSIGHT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your skin is responding well to the current Vitamin C routine. Brightness levels have increased by 12% since last month.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onDetails,
            child: Text(
              'VIEW DETAILS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 30-Day Progress ────────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.onJournal});

  final VoidCallback onJournal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Figma: continuous square-ish before|after, then title below
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 2 / 1.15,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.asset(
                        AppAssets.realtimeFace,
                        fit: BoxFit.cover,
                        alignment: const Alignment(-0.35, 0.1),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        AppAssets.realtimeFace,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.35, -0.05),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 12,
                  child: Text(
                    'BEFORE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 14,
                  bottom: 12,
                  child: Text(
                    'AFTER',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '30-Day Progress',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last scan: 2 days ago',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: onJournal,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF1C1B1B), width: 1.2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(0, 46),
              ),
              child: Text(
                'View Journal',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Beauty Forecast ────────────────────────────────────────────────────────

class _BeautyForecastMini extends StatelessWidget {
  const _BeautyForecastMini({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beauty Forecast',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Projected clarity trend',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFD2C4BE).withValues(alpha: 0.7),
                    ),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Large soft chart panel (Figma)
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEEA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 128,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _MiniLineChartPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Week 1', 'Week 2', 'Week 3', 'Week 4']
                      .map(
                        (w) => Text(
                          w,
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
        ),
      ],
    );
  }
}

class _MiniLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.14),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size);

    // Upward clarity curve — control points scaled to size
    final path = Path()
      ..moveTo(0, size.height * 0.82)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.78,
        size.width * 0.28,
        size.height * 0.55,
        size.width * 0.38,
        size.height * 0.52,
      )
      ..cubicTo(
        size.width * 0.52,
        size.height * 0.48,
        size.width * 0.58,
        size.height * 0.32,
        size.width * 0.72,
        size.height * 0.28,
      )
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.24,
        size.width * 0.92,
        size.height * 0.14,
        size.width,
        size.height * 0.12,
      );

    final fillPath = Path()
      ..addPath(path, Offset.zero)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Daily Protocol ─────────────────────────────────────────────────────────

class _DailyProtocolCard extends StatelessWidget {
  const _DailyProtocolCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProtocolBlock(
          icon: Icons.wb_sunny_outlined,
          title: 'MORNING PROTOCOL',
          steps: const [
            ('Gentle Cleansing Oil', true),
            ('Vitamin C Brightening Serum', false),
          ],
          onTap: () =>
              Navigator.pushNamed(context, RouteNames.todaysRoutine),
        ),
        const SizedBox(height: 20),
        _ProtocolBlock(
          icon: Icons.nightlight_round,
          title: 'NIGHT PROTOCOL',
          steps: const [
            ('Overnight Retinol Repair', false),
          ],
          onTap: () =>
              Navigator.pushNamed(context, RouteNames.routineOverview),
        ),
      ],
    );
  }
}

class _ProtocolBlock extends StatelessWidget {
  const _ProtocolBlock({
    required this.icon,
    required this.title,
    required this.steps,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final List<(String, bool)> steps;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...steps.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: s.$2
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: s.$2
                                ? AppColors.primary
                                : const Color(0xFFD2C4BE),
                            width: 1.5,
                          ),
                        ),
                        child: s.$2
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          s.$1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Prescribed For You ─────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  const _ProductRow();

  static const _products = [
    (
      'Advanced Hydrating Complex',
      'Hyaluronic Acid + B5',
      '\$84.00',
      AppAssets.productBakuchiol,
    ),
    (
      'Radiance Glow Essence',
      'Niacinamide + Pearl',
      '\$62.00',
      AppAssets.productExtra1,
    ),
    (
      'Barrier Repair Cream',
      'Ceramides + Panthenol',
      '\$48.00',
      AppAssets.productExtra2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 328,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final p = _products[index];
          return SizedBox(
            width: 196,
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.productDetail),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full-bleed product image — fills remaining space
                    Expanded(
                      child: Image.asset(
                        p.$4,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            p.$1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                p.$3,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.favorite_border,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
