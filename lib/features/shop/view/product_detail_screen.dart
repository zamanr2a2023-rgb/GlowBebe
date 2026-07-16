import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const _ingredients = [
    ('Bakuchiol', Icons.spa_outlined),
    ('Vitamin C', Icons.wb_sunny_outlined),
    ('Peptides', Icons.science_outlined),
    ('Hyaluronic', Icons.water_drop_outlined),
  ];

  static const _reviews = [
    ('Maya Chen', '4.9', 'Skin looks glassier after one week. Love the texture.'),
    ('Aisha Noor', '4.7', 'Gentle enough for sensitive skin. Subtle glow.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      AppAssets.productBakuchiol,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const GlowImagePlaceholder(height: 320, borderRadius: 0),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        'SKINCARE · SERUM',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const GlowSerifTitle('Luminous Bakuchiol Serum', size: 28),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$48',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, size: 16, color: Color(0xFFC4A484)),
                          Text(
                            ' 4.8 (128)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'A plant-powered retinol alternative that smooths fine lines while locking in moisture for a soft-focus glow.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          height: 1.55,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const GlowSerifTitle('Key Ingredients', size: 20),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _ingredients
                            .map(
                              (ing) => Column(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.surfacePeach,
                                      border: Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.15),
                                      ),
                                    ),
                                    child: Icon(
                                      ing.$2,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ing.$1,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          const Expanded(
                            child: GlowSerifTitle('Reviews', size: 20),
                          ),
                          Text(
                            'See all',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._reviews.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlowSoftCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      r.$1,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Color(0xFFC4A484),
                                    ),
                                    Text(
                                      ' ${r.$2}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  r.$3,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    height: 1.45,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
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
