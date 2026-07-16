import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  void _onNavTap(BuildContext context, int index) {
    Navigator.pushReplacementNamed(
      context,
      RouteNames.mainShell,
      arguments: index,
    );
  }

  static const _products = [
    (
      'Illuminating Serum',
      'Vitamin C + Hyaluronic Acid',
      '\$67.20',
      '\$84.00',
      AppAssets.productBakuchiol,
      true,
    ),
    (
      'Gentle Foam Cleanser',
      'Ceramides + Panthenol',
      '\$36.00',
      null,
      AppAssets.productExtra1,
      false,
    ),
    (
      'Barrier Repair Cream',
      'Niacinamide + Squalane',
      '\$52.00',
      '\$65.00',
      AppAssets.productExtra2,
      true,
    ),
    (
      'Glow Recovery Oil',
      'Rosehip + Vitamin E',
      '\$41.60',
      '\$52.00',
      AppAssets.productExtra3,
      true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 64,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.iconMuted,
            weight: 200,
          ),
        ),
        title: Text(
          'Recommendations',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 22,
              color: AppColors.iconMuted,
              weight: 200,
            ),
          ),
        ],
        backgroundColor: AppColors.background.withValues(alpha: 0.92),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          Text(
            'Curated for Your Combination Skin',
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Based on your skin profile and AI analysis, these formulations '
            'provide targeted hydration while managing oil production.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, i) {
              final p = _products[i];
              return _ProductCard(
                title: p.$1,
                subtitle: p.$2,
                price: p.$3,
                oldPrice: p.$4,
                image: p.$5,
                showDiscount: p.$6,
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.productDetail),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: GlowBottomNav(
        currentIndex: 0,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.showDiscount,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final String? oldPrice;
  final String image;
  final bool showDiscount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
                if (showDiscount)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '20% OFF',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
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
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                price,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              if (oldPrice != null) ...[
                const SizedBox(width: 6),
                Text(
                  oldPrice!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const Spacer(),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
