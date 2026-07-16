import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const _orders = [
    ('#GB-2841', 'Delivered', 'Jul 12, 2026', '\$136', AppAssets.productBakuchiol),
    ('#GB-2790', 'In Transit', 'Jul 4, 2026', '\$88', AppAssets.productExtra1),
    ('#GB-2712', 'Delivered', 'Jun 21, 2026', '\$52', AppAssets.productExtra2),
    ('#GB-2655', 'Delivered', 'Jun 2, 2026', '\$120', AppAssets.productExtra3),
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
                padding: const EdgeInsets.fromLTRB(8, 4, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'GLOW EDITORIAL',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.2,
                              color: AppColors.primary,
                            ),
                          ),
                          const GlowSerifTitle('My Orders', size: 26),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final o = _orders[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlowSoftCard(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              o.$5,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  o.$1,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${o.$2} · ${o.$3}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  o.$4,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              RouteNames.orderStatus,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'TRACK',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _orders.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
