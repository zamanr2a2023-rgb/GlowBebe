import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _search = TextEditingController();

  static const _orders = [
    (
      'Luminous Gentle Foam Cleanser',
      'Order #GB-2841',
      'Placed Jul 12, 2026',
      '\$48.00',
      'DELIVERED',
      true,
      AppAssets.productExtra1,
    ),
    (
      'Luminous Day Cream',
      'Order #GB-2790',
      'Placed Jul 4, 2026',
      '\$88.00',
      'IN TRANSIT',
      false,
      AppAssets.productExtra2,
    ),
    (
      '24K Gold Reparative Elixir',
      'Order #GB-2712',
      'Placed Jun 21, 2026',
      '\$78.00',
      'DELIVERED',
      true,
      AppAssets.productBakuchiol,
    ),
    (
      'Rose Velvet Lipstick',
      'Order #GB-2655',
      'Placed Jun 2, 2026',
      '\$32.00',
      'DELIVERED',
      true,
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
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          Text(
            'My Orders',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 34 / 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage and track your skincare favorites.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 24 / 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 20, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.tune, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'FILTER',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const Color(0xFFD2C4BE).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          size: 18,
                          color: Color(0xFF807570),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _search,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: const Color(0xFFD2C4BE),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          ..._orders.map(
            (o) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _OrderCard(
                title: o.$1,
                orderId: o.$2,
                date: o.$3,
                total: o.$4,
                status: o.$5,
                delivered: o.$6,
                image: o.$7,
                onTrack: () =>
                    Navigator.pushNamed(context, RouteNames.orderStatus),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.title,
    required this.orderId,
    required this.date,
    required this.total,
    required this.status,
    required this.delivered,
    required this.image,
    required this.onTrack,
  });

  final String title;
  final String orderId;
  final String date;
  final String total;
  final String status;
  final bool delivered;
  final String image;
  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    final badgeBg = delivered
        ? const Color(0xFFFFC5AF).withValues(alpha: 0.3)
        : const Color(0xFFF5E2D9).withValues(alpha: 0.4);
    final badgeColor =
        delivered ? const Color(0xFF7A4F3E) : const Color(0xFF72635C);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD2C4BE).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 128,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    height: 30 / 22,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    letterSpacing: 0.5,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            orderId,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            total,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 42,
            child: OutlinedButton(
              onPressed: onTrack,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 36),
              ),
              child: Text(
                delivered ? 'BUY AGAIN' : 'TRACK ORDER',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
