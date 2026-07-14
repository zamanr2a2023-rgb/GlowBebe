import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/features/try_on/model/try_on_models.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ShadeMatchedShopScreen extends StatelessWidget {
  const ShadeMatchedShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const TryOnAppBar(title: 'GLOW ANALYSIS'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppAssets.productBakuchiol, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Perfect Winter Palette',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Curated for your Cool Winter profile',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Shade Matched Products',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...TryOnMockData.shopProducts.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ProductCard(product: p, compact: true, onAdd: () {}),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfacePeach.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    AppAssets.lookSoftGlam,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Luminous Secret',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Formulas selected by Elena Rossi for cool undertones.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textSecondary,
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
