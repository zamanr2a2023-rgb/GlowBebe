import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _search = TextEditingController();
  int _filter = 0;
  double _price = 0.48;
  String _sort = 'Featured';

  static const _filters = ['All Skin', 'Serum', 'Lip', 'Eye Care', 'Clean'];
  static const _sortOptions = ['Featured', 'Price ↑', 'Price ↓', 'Top Rated'];

  static const _products = [
    (
      'Velvet Veil Hydrating',
      '\$96.00',
      '\$72.00',
      '4.9 (128)',
      'BESTSELLER',
      AppAssets.productBakuchiol,
    ),
    (
      'Velvet Veil Hydrating',
      '\$84.00',
      '\$64.00',
      '4.8 (96)',
      'NEW',
      AppAssets.productExtra1,
    ),
    (
      'Velvet Veil Hydrating',
      '\$78.00',
      '\$58.00',
      '4.7 (84)',
      'CLEAN',
      AppAssets.productExtra2,
    ),
    (
      'Velvet Veil Hydrating',
      '\$92.00',
      '\$69.00',
      '4.9 (210)',
      'EDITOR',
      AppAssets.productExtra3,
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RouteNames.cart),
        backgroundColor: AppColors.primary,
        elevation: 6,
        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          TextField(
            controller: _search,
            style: GoogleFonts.plusJakartaSans(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Search skincare & makeup...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: const Color(0xFF6B7280),
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF807570)),
              filled: true,
              fillColor: AppColors.surfaceSoft,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF807570)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF807570)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final selected = _filter == i;
                return GestureDetector(
                  onTap: () => setState(() => _filter = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surfacePeach,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _filters[i],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF73635B),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD2C4BE)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Price Range',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$0 – \$150',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFD2C4BE),
                    thumbColor: AppColors.primary,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 9,
                    ),
                  ),
                  child: Slider(
                    value: _price,
                    onChanged: (v) => setState(() => _price = v),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Sort by',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFD2C4BE)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sort,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF6B7280),
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                            items: _sortOptions
                                .map(
                                  (o) => DropdownMenuItem(
                                    value: o,
                                    child: Text(o),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _sort = v);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.52,
            ),
            itemBuilder: (context, i) {
              final p = _products[i];
              return _ProductTile(
                title: p.$1,
                oldPrice: p.$2,
                price: p.$3,
                rating: p.$4,
                badge: p.$5,
                image: p.$6,
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.productDetail),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.title,
    required this.oldPrice,
    required this.price,
    required this.rating,
    required this.badge,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String oldPrice;
  final String price;
  final String rating;
  final String badge;
  final String image;
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
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColoredBox(
                      color: const Color(0xFFEAE7E7),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const GlowImagePlaceholder(
                          height: double.infinity,
                          borderRadius: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                      badge,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, size: 13, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                rating,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                oldPrice,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
