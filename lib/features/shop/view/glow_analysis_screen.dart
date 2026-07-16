import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class GlowAnalysisScreen extends StatelessWidget {
  const GlowAnalysisScreen({super.key});

  static const _actives = [
    'Bakuchiol',
    'Niacinamide',
    'Squalane',
    'Ceramide NP',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Glow Analysis'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AppAssets.productBakuchiol,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        '95% Match',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Excellent fit for your Combination skin',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const GlowSerifTitle('Bio-Actives', size: 20),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _actives
                      .map((t) => GlowChip(label: t, selected: true))
                      .toList(),
                ),
                const SizedBox(height: 24),
                GlowSoftCard(
                  color: const Color(0xFFFFF3F0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFB45309),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gentle caution',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Contains fragrant botanicals. Patch-test if you have fragrance sensitivity.',
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
                const SizedBox(height: 16),
                GlowSoftCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why it matches',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Supports barrier repair and oil balance without heavy occlusives — aligned with your cool undertone and combination profile.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
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
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: GlowPrimaryButton(
                label: 'Checkout',
                onPressed: () => Navigator.pushNamed(context, RouteNames.cart),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
