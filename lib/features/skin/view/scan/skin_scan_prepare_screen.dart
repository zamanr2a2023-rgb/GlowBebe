import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinScanPrepareScreen extends StatelessWidget {
  const SkinScanPrepareScreen({super.key});

  static const _tips = [
    ('Find soft natural light', 'Avoid harsh overhead or colored lighting.'),
    ('Remove makeup if possible', 'Bare skin gives the most accurate read.'),
    ('Hold your phone at eye level', 'Keep your face centered in the oval.'),
    ('Stay still for a few seconds', 'We’ll capture front and slight angles.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Get Ready'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                GlowSerifTitle('Prepare for your scan', size: 26),
                const SizedBox(height: 8),
                Text(
                  'A few quick tips for the best AI analysis.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                ...List.generate(_tips.length, (i) {
                  final tip = _tips[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlowSoftCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip.$1,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tip.$2,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    height: 1.45,
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
                }),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: GlowPrimaryButton(
                label: "I'M READY",
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.skinScanCamera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
