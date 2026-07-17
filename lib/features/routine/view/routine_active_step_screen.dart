import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineActiveStepScreen extends StatelessWidget {
  const RoutineActiveStepScreen({super.key});

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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const _StepProgress(),
          const _AbsorptionHero(),
          const SizedBox(height: 48),
          Text(
            'STEP 2: RITUAL',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Radiance Boost Serum',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our proprietary blend of Vitamin C, Hyaluronic Acid, and '
            'Ferulic Acid works synergistically to brighten, firm, and '
            'protect.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          const _InstructionCard(
            icon: Icons.water_drop_outlined,
            title: 'Quantity',
            body: 'Dispense 3-4 drops onto your fingertips. Do not touch '
                'the dropper to your skin to maintain purity.',
          ),
          const SizedBox(height: 16),
          const _InstructionCard(
            icon: Icons.gesture,
            title: 'Motion',
            body: 'Press firmly but gently into the skin. Use upward '
                'strokes across the cheeks, forehead, and neck.',
          ),
          const SizedBox(height: 32),
          const _SkinScoreCard(),
          const SizedBox(height: 32),
          const _IngredientsCard(),
          const SizedBox(height: 32),
          GlowPrimaryButton(
            label: 'NEXT STEP: HYDRATE',
            height: 60,
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.routineComplete),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.routineComplete),
              child: Text(
                'Skip this step',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.6,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC5AF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '1. Cleansed',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const _StepDivider(),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                      spreadRadius: -3,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '2',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '2. Active',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const _StepDivider(),
          Opacity(
            opacity: 0.4,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EDED),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF807570)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '3',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '3. Hydrate',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textPrimary,
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

class _StepDivider extends StatelessWidget {
  const _StepDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFFD2C4BE),
    );
  }
}

class _AbsorptionHero extends StatelessWidget {
  const _AbsorptionHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 350 / 437.5,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.productBakuchiol, fit: BoxFit.cover),
            Container(
              color: AppColors.background.withValues(alpha: 0.6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 176,
                    height: 176,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 2,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFD2C4BE),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        const CircularProgressIndicator(
                          value: 0.82,
                          strokeWidth: 4,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '04:57',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'MINUTES LEFT',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  letterSpacing: 1.2,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Absorption Phase',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Allow the botanicals to penetrate deep into your dermal '
                    'layers. This pause ensures maximum efficacy before the '
                    'next step.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textSecondary,
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

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD2C4BE).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkinScoreCard extends StatelessWidget {
  const _SkinScoreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7E1D7), Color(0xFFFFC5AF), Color(0xFFF5E2D9)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 22,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Skin Luminosity',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Updated from your last scan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '84',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 44,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '/100',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientsCard extends StatelessWidget {
  const _IngredientsCard();

  static const _pills = <(String, Color, Color)>[
    ('Vitamin C 15%', Color(0xFFF7E1D7), Color(0xFF73635B)),
    ('Hyaluronic Acid', Color(0xFFFFC5AF), Color(0xFF7A4F3E)),
    ('Ferulic Acid', Color(0xFFF5E2D9), Color(0xFF72635C)),
    ('Vegan', Color(0xFFEAE7E7), Color(0xFF4E4540)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E2E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFD2C4BE)),
              ),
            ),
            child: Text(
              'ACTIVE INGREDIENTS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (label, bg, fg) in _pills)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: fg,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"The morning radiance boost is more than just serum; '
            "it's a foundation for all-day protection.\"",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppAssets.profileAvatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. Elena Rousse',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.7,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Lead Dermatologist',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
