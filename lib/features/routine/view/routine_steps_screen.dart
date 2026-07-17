import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineStepsScreen extends StatelessWidget {
  const RoutineStepsScreen({super.key});

  static const _steps = <_RoutineStepData>[
    _RoutineStepData(
      meta: 'STEP 01 — CLEANSE',
      title: 'Gentle Renewal Cleanser',
      description:
          'Massage onto damp skin for 60 seconds. Rinse with lukewarm '
          'water to maintain your natural barrier.',
      tags: ['60 Seconds', 'Lukewarm Water'],
      image: AppAssets.productExtra1,
    ),
    _RoutineStepData(
      meta: 'STEP 02 — TREAT',
      title: 'Radiance Boost Serum',
      description:
          'Apply 3-4 drops to clean, dry skin. Pat gently until absorbed '
          'to brighten and protect against oxidation.',
      tags: ['3-4 Drops', 'Antioxidant'],
      image: AppAssets.productBakuchiol,
    ),
    _RoutineStepData(
      meta: 'STEP 03 — PROTECT',
      title: 'Daily Defense SPF 50+',
      description:
          'Apply generously as the final step. Protects against UV damage '
          'while providing all-day hydration.',
      tags: ['Every Morning', 'Reapply Midday'],
      image: AppAssets.productExtra2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'LUMINA',
        brandStyle: true,
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
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          const _RoutineHeading(),
          const SizedBox(height: 32),
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0) const SizedBox(height: 24),
            _RoutineStepCard(
              data: _steps[i],
              onTap: () => Navigator.pushNamed(
                context,
                RouteNames.routineActiveStep,
                arguments: {
                  'title': _steps[i].meta,
                  'subtitle': _steps[i].title,
                },
              ),
            ),
          ],
          const SizedBox(height: 40),
          const _ExpertTipCard(),
          const SizedBox(height: 40),
          const _RoutineSummaryCard(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 8, 40, 16),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                RouteNames.routineActiveStep,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 0.3),
                shape: const StadiumBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'START ROUTINE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.arrow_forward_ios, size: 13),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoutineStepData {
  const _RoutineStepData({
    required this.meta,
    required this.title,
    required this.description,
    required this.tags,
    required this.image,
  });

  final String meta;
  final String title;
  final String description;
  final List<String> tags;
  final String image;
}

class _RoutineHeading extends StatelessWidget {
  const _RoutineHeading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MORNING ROUTINE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      letterSpacing: 1.6,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Morning Gentle Renewal',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '01 / 03',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: const LinearProgressIndicator(
            value: 0,
            minHeight: 4,
            backgroundColor: Color(0xFFF0EDED),
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _RoutineStepCard extends StatelessWidget {
  const _RoutineStepCard({required this.data, required this.onTap});

  final _RoutineStepData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD2C4BE).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 300 / 160,
                  child: Image.asset(data.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.meta,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        letterSpacing: 0.8,
                        color: AppColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.info_outline,
                    size: 19,
                    color: Color(0xFFD2C4BE),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                data.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final tag in data.tags)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E2D9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFF695C55),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpertTipCard extends StatelessWidget {
  const _ExpertTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC5AF).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFC5AF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                size: 19,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                'EXPERT TIP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  letterSpacing: 0.8,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Always wait about 2 minutes between the Vitamin C serum and '
            'your SPF to ensure maximum absorption and no "pilling" of '
            'products.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              height: 1.6,
              color: const Color(0xFF7A4F3E),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineSummaryCard extends StatelessWidget {
  const _RoutineSummaryCard();

  static const _rows = <(String, String)>[
    ('Estimated Time', '8 Mins'),
    ('Primary Focus', 'Barrier & Protection'),
    ('Products Used', '3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEAE7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROUTINE OVERVIEW',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              letterSpacing: 0.8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < _rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _rows[i].$1,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  _rows[i].$2,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
