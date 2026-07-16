import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinScanIntroScreen extends StatelessWidget {
  const SkinScanIntroScreen({super.key});

  static const _features = [
    (Icons.face_retouching_natural, 'AI face mapping', '478 landmarks analyzed'),
    (Icons.analytics_outlined, 'Deep metrics', 'Hydration, pores, tone & more'),
    (Icons.auto_awesome, 'Personalized plan', 'Regimen matched to your skin'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Skin Scan'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GlowImagePlaceholder(
                    height: 240,
                    borderRadius: 20,
                    icon: Icons.camera_front_outlined,
                    label: 'Scan preview',
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.surfacePeach,
                            AppColors.surfaceSoft,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face_retouching_natural,
                            size: 72,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'AI Skin Analysis',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                GlowSerifTitle('Reveal your true glow', size: 26),
                const SizedBox(height: 10),
                Text(
                  'A guided 30-second scan that captures lighting-safe images and builds your skin health profile.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                ..._features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePeach,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(f.$1, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.$2,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                f.$3,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: GlowPrimaryButton(
                label: 'START SKIN SCAN',
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.skinScanPrepare),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
