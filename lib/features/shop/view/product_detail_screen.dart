import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const _ingredients = [
    ('24K Gold', Icons.diamond_outlined),
    ('Bakuchiol', Icons.spa_outlined),
    ('Peptides', Icons.science_outlined),
    ('Ceramide', Icons.water_drop_outlined),
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
            onPressed: () => Navigator.pushNamed(context, RouteNames.cart),
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.iconMuted,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 420,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: AppColors.surfaceSoft,
                        child: Image.asset(
                          AppAssets.productBakuchiol,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const GlowImagePlaceholder(
                            height: 420,
                            borderRadius: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            '20% OFF',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '4.9 (124 reviews)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.7,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 28,
                        child: Text(
                          'STOCK 50',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADVANCED REPAIR',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.8,
                          color: AppColors.iconMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '24K Gold Reparative Elixir',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$78.00',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              height: 40 / 32,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '\$98.00',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'DESCRIPTION',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'A decadent infusion of pure 24K gold flakes and rare botanical extracts. This elixir targets cellular restoration, delivering intense luminosity while strengthening the skin\'s natural moisture barrier for a resilient, youthful glow.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          height: 26 / 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Expired Sept 2023',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'KEY INGREDIENTS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _ingredients
                            .map(
                              (ing) => Column(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFF0EDED),
                                      border: Border.all(
                                        color: const Color(0xFFD2C4BE),
                                      ),
                                    ),
                                    child: Icon(
                                      ing.$2,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ing.$1,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 36),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 32),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFD2C4BE)),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CUSTOMER REVIEWS',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSoft,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFD2C4BE)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (_) => const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(
                                        Icons.star,
                                        size: 15,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Loved by 124 reviewers',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
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
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.cart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
