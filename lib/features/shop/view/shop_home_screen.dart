import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  int _category = 0;
  static const _categories = ['All', 'Skincare', 'Makeup'];

  static const _products = [
    ('Luminous Serum', '\$48', AppAssets.productBakuchiol),
    ('Velvet Blush', '\$32', AppAssets.productExtra1),
    ('Glow Essence', '\$56', AppAssets.productExtra2),
    ('Soft Contour', '\$41', AppAssets.productExtra3),
  ];

  static const _scans = [
    ('Bakuchiol Night Oil', '95% Match · 2 days ago'),
    ('Rosehip Cleanser', '88% Match · 1 week ago'),
    ('Niacinamide Mist', '91% Match · 2 weeks ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GLOSS & GOSSAMER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.4,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const GlowBrandMark(title: 'GlowBebe', size: 26),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.barcodeScanner,
                      ),
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: AppColors.iconMuted,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteNames.cart),
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.iconMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, widget.embedded ? 100 : 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.productList),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 220,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            AppAssets.heroAr,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const GlowImagePlaceholder(height: 220),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    'NEW ARRIVALS',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Summer Glow Edit',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Fresh formulas for luminous skin',
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
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      return GlowChip(
                        label: _categories[i],
                        selected: _category == i,
                        onTap: () => setState(() => _category = i),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: GlowSerifTitle('Curated for Your Profile', size: 22),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.skinQuestionnaire,
                      ),
                      child: Text(
                        'Retake Skin Analysis',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Combination · Cool undertone',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _products.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (context, i) {
                      final p = _products[i];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.productDetail,
                        ),
                        child: SizedBox(
                          width: 148,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  p.$3,
                                  height: 148,
                                  width: 148,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const GlowImagePlaceholder(
                                    height: 148,
                                    borderRadius: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                p.$1,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                p.$2,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GlowOutlinedButton(
                  label: 'View All Recommendations',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.recommendations,
                  ),
                  height: 48,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(
                      child: GlowSerifTitle('Scan History', size: 22),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.barcodeScanner,
                      ),
                      child: Text(
                        'Scan New',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._scans.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlowSoftCard(
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.glowAnalysis,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              AppAssets.productBakuchiol,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.$1,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  s.$2,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textTertiary,
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
    );
  }
}
