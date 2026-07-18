import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  static const _steps = [
    (Icons.check, 'Ordered'),
    (Icons.local_shipping_outlined, 'Shipped'),
    (Icons.delivery_dining_outlined, 'Out for Delivery'),
    (Icons.home_outlined, 'Delivered'),
  ];

  @override
  Widget build(BuildContext context) {
    const currentStep = 1;

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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePeach,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF7A4F3E),
                    size: 26,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Order is On the Way',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 34 / 28,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ORDER #GB-2841 · ETA TODAY',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _TrackingStepper(steps: _steps, currentStep: currentStep),
          const SizedBox(height: 36),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD2C4BE)),
            ),
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: AppColors.surfaceSoft,
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  Center(
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: AppColors.primary.withValues(alpha: 0.85),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD2C4BE)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ARRIVING TODAY',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    letterSpacing: -0.4,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '1242 Silk Road, Suite 402',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.near_me_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Text(
                'Previous Orders',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.orderHistory),
                child: Text(
                  'View All',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _PreviousOrderCard(
            title: 'Velvet Elixir Oil',
            date: 'Delivered Jan 12',
            price: '\$84.00',
            image: AppAssets.productBakuchiol,
          ),
          const SizedBox(height: 16),
          const _PreviousOrderCard(
            title: 'Ceramide Cloud Cream',
            date: 'Delivered Dec 28',
            price: '\$72.00',
            image: AppAssets.productExtra2,
          ),
          const SizedBox(height: 28),
          GlowPrimaryButton(
            label: 'Buy Again',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.productList),
          ),
        ],
      ),
    );
  }
}

class _TrackingStepper extends StatelessWidget {
  const _TrackingStepper({required this.steps, required this.currentStep});

  final List<(IconData, String)> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 32,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: 16,
                    right: 16,
                    child: Container(height: 2, color: const Color(0xFFD2C4BE)),
                  ),
                  Positioned(
                    left: 16,
                    child: Container(
                      width: (w - 32) * (currentStep / (steps.length - 1)),
                      height: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(steps.length, (i) {
                      final done = i <= currentStep;
                      final current = i == currentStep;
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done
                              ? AppColors.primary
                              : const Color(0xFFE5E2E1),
                          border: Border.all(
                            color: done
                                ? AppColors.primary
                                : const Color(0xFFD2C4BE),
                          ),
                          boxShadow: current
                              ? const [
                                  BoxShadow(
                                    color: AppColors.surfacePeach,
                                    spreadRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          i < currentStep ? Icons.check : steps[i].$1,
                          size: 14,
                          color: done ? Colors.white : AppColors.textSecondary,
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(steps.length, (i) {
            final done = i <= currentStep;
            return Expanded(
              child: Text(
                steps[i].$2,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: done ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PreviousOrderCard extends StatelessWidget {
  const _PreviousOrderCard({
    required this.title,
    required this.date,
    required this.price,
    required this.image,
  });

  final String title;
  final String date;
  final String price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2C4BE)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ColoredBox(
                  color: Colors.white,
                  child: Image.asset(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.productDetail),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(
                'Reorder',
                style: GoogleFonts.plusJakartaSans(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
