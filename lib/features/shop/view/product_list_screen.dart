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
  static const _filters = ['All', 'Serum', 'Lip', 'Eye', 'Clean'];

  static const _products = [
    ('Luminous Bakuchiol Serum', '\$48', AppAssets.productBakuchiol),
    ('Velvet Rose Blush', '\$32', AppAssets.productExtra1),
    ('Dew Drop Essence', '\$56', AppAssets.productExtra2),
    ('Soft Focus Contour', '\$41', AppAssets.productExtra3),
    ('Cloud Soft Lip Tint', '\$28', AppAssets.lookSoftGlam),
    ('Radiance Eye Cream', '\$52', AppAssets.lookNatural),
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
        title: 'Shop',
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, RouteNames.cart),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, RouteNames.barcodeScanner),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Search products…',
                prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) => GlowChip(
                label: _filters[i],
                selected: _filter == i,
                onTap: () => setState(() => _filter = i),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 88),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemCount: _products.length,
              itemBuilder: (context, i) {
                final p = _products[i];
                return GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.productDetail),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            p.$3,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const GlowImagePlaceholder(
                              height: double.infinity,
                              borderRadius: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        p.$1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.$2,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
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
