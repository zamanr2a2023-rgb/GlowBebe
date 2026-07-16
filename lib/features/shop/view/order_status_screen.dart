import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  static const _steps = [
    'Confirmed',
    'Packed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    const currentStep = 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Order Status'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfacePeach,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const GlowSerifTitle('Thank You', size: 32),
                const SizedBox(height: 8),
                Text(
                  'Order #GB-2841 is on its way',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          GlowSoftCard(
            child: Column(
              children: List.generate(_steps.length, (i) {
                final done = i <= currentStep;
                final isLast = i == _steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: done
                                ? AppColors.primary
                                : AppColors.surfaceSoft,
                            border: Border.all(
                              color: done
                                  ? AppColors.primary
                                  : AppColors.borderSoft,
                            ),
                          ),
                          child: done
                              ? const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 28,
                            color: i < currentStep
                                ? AppColors.primary
                                : AppColors.surfaceSoft,
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _steps[i],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight:
                              done ? FontWeight.w700 : FontWeight.w500,
                          color: done
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 180,
              color: AppColors.surfaceSoft,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: _MapGridPainter()),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 36,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Live map placeholder',
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
          ),
          const SizedBox(height: 24),
          GlowPrimaryButton(
            label: 'Buy Again',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.productList),
          ),
          const SizedBox(height: 12),
          GlowOutlinedButton(
            label: 'View Order History',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.orderHistory),
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
