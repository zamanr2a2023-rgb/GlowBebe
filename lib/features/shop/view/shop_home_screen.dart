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

  static const _categories = ['All Shop', 'Skincare', 'Makeup'];

  static const _recs = [
    ('Velvet Elixir Oil', '\$84.00', '98% Match', AppAssets.productBakuchiol),
    ('Ceramide Cloud', '\$72.00', '94% Match', AppAssets.productExtra2),
  ];

  static const _scans = [
    (
      'Silk Foam Cleanser',
      'Yesterday',
      0.85,
      '85%',
      'Ingredient\nAlert',
      false,
      AppAssets.productExtra1,
    ),
    (
      'Azure Essence Serum',
      'Oct 24',
      0.42,
      '42%',
      'Irritant\nFound',
      true,
      AppAssets.productExtra2,
    ),
    (
      'Barrier Recovery\nBalme',
      'Oct\n22',
      0.96,
      '96%',
      'Perfect\nMatch',
      false,
      AppAssets.productBakuchiol,
    ),
    (
      'Daily Shield SPF 50',
      'Oct 18',
      0.78,
      '78%',
      'Standard\nFit',
      false,
      AppAssets.productExtra3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ShopHeader(embedded: widget.embedded)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              widget.embedded ? 110 : 32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _HeroBanner(
                  onShop: () =>
                      Navigator.pushNamed(context, RouteNames.productList),
                ),
                const SizedBox(height: 14),
                Text(
                  'Browse Categories',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 32 / 24,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final selected = _category == i;
                      return GestureDetector(
                        onTap: () => setState(() => _category = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : const Color(0xFFD2C4BE),
                            ),
                          ),
                          child: Text(
                            _categories[i],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.7,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                _AiCuratedSection(
                  products: _recs,
                  onRetake: () => Navigator.pushNamed(
                    context,
                    RouteNames.skinQuestionnaire,
                  ),
                  onProduct: () =>
                      Navigator.pushNamed(context, RouteNames.productDetail),
                ),
                const SizedBox(height: 14),
                const _DiscountBanner(),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteNames.orderHistory),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.black.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'My Order',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Scan History',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 32 / 24,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                ..._scans.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ScanHistoryTile(
                      title: s.$1,
                      date: s.$2,
                      progress: s.$3,
                      percent: s.$4,
                      status: s.$5,
                      caution: s.$6,
                      image: s.$7,
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.glowAnalysis),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GlowPrimaryButton(
                  label: 'Start Scan',
                  icon: Icons.qr_code_scanner,
                  height: 68,
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.barcodeScanner),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.embedded});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(bottom: BorderSide(color: Color(0xFFD2C4BE))),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.productList),
              icon: const Icon(
                Icons.search,
                size: 22,
                color: AppColors.iconMuted,
              ),
            ),
            Expanded(
              child: Text(
                'GLOSS & GOSSAMER',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.8,
                  color: AppColors.primary,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.cart),
              icon: const Icon(
                Icons.shopping_bag_outlined,
                size: 22,
                color: AppColors.iconMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onShop});

  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 451,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.productExtra2,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const GlowImagePlaceholder(height: 451, borderRadius: 12),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.background.withValues(alpha: 0.72),
                    AppColors.background.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NEW ARRIVALS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.8,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The Winter Collection',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Protect and illuminate your skin during the coldest months with our AI-curated botanical blends.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      height: 28 / 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 234,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: onShop,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'EXPLORE COLLECTION',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                        ),
                      ),
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

class _AiCuratedSection extends StatelessWidget {
  const _AiCuratedSection({
    required this.products,
    required this.onRetake,
    required this.onProduct,
  });

  final List<(String, String, String, String)> products;
  final VoidCallback onRetake;
  final VoidCallback onProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E1D7).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF7E1D7).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.iconMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 13, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'AI PRECISION MATCH',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    letterSpacing: 0.6,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Curated for Your Profile',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 34 / 28,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Based on your recent skin analysis for "High Hydration Needs", we\'ve selected these formulas to repair your moisture barrier.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 24 / 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetake,
            child: Row(
              children: [
                Text(
                  'Retake Skin Analysis',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final p = products[i];
                return GestureDetector(
                  onTap: onProduct,
                  child: Container(
                    width: 220,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              p.$4,
                              height: 170,
                              width: 220,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const GlowImagePlaceholder(
                                    height: 170,
                                    borderRadius: 0,
                                  ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  p.$3,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.$1,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.7,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.$2,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add to Bag',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountBanner extends StatelessWidget {
  const _DiscountBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD2C4BE).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add 1 more item to unlock 15% OFF your entire order.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    height: 22 / 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(
                    value: 0.75,
                    minHeight: 6,
                    backgroundColor: Color(0x33D2C4BE),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ALMOST THERE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    letterSpacing: 0.55,
                    color: AppColors.textSecondary,
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

class _ScanHistoryTile extends StatelessWidget {
  const _ScanHistoryTile({
    required this.title,
    required this.date,
    required this.progress,
    required this.percent,
    required this.status,
    required this.caution,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String date;
  final double progress;
  final String percent;
  final String status;
  final bool caution;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = caution ? const Color(0xFFBA1A1A) : AppColors.iconMuted;

    return Material(
      color: const Color(0xFFF0EDED),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  image,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          date,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 96,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFD2C4BE),
                              color: accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          percent,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          caution
                              ? Icons.warning_amber_rounded
                              : Icons.verified_outlined,
                          size: 14,
                          color: accent,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            status,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: accent,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
