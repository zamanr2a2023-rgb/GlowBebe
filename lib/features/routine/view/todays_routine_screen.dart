import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class TodaysRoutineScreen extends StatelessWidget {
  const TodaysRoutineScreen({super.key});

  static const _morning = [
    ('Gentle Cleanser', 'Step 1: Prep', AppAssets.productExtra1, true),
    ('Vitamin C Serum', 'Step 2: Treat', AppAssets.productBakuchiol, false),
    ('SPF 50+ Fluid', 'Step 3: Protect', AppAssets.productExtra2, false),
  ];

  static const _night = [
    ('Double Cleanse', 'Step 1: Prep', AppAssets.productExtra3, false),
    ('Retinol 0.5%', 'Step 2: Treat', AppAssets.productBakuchiol, false),
    ('Night Recovery Cream', 'Step 3: Seal', AppAssets.productExtra1, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: "Today's Routine",
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.notifications),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.iconMuted,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'YOUR DAILY SKIN FORECAST',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Healthy skin is a marathon, not a sprint',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 28),
          _ProtocolSection(
            icon: Icons.wb_sunny_outlined,
            title: 'Morning Protocol',
            time: '8:00 AM',
            steps: _morning,
          ),
          const SizedBox(height: 28),
          _ProtocolSection(
            icon: Icons.nightlight_round,
            title: 'Night Protocol',
            time: '9:30 PM',
            steps: _night,
          ),
          const SizedBox(height: 28),
          GlowPrimaryButton(
            label: 'VIEW ALL',
            height: 52,
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.routineOverview),
          ),
        ],
      ),
    );
  }
}

class _ProtocolSection extends StatelessWidget {
  const _ProtocolSection({
    required this.icon,
    required this.title,
    required this.time,
    required this.steps,
  });

  final IconData icon;
  final String title;
  final String time;
  final List<(String, String, String, bool)> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              time,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...steps.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.routineActiveStep,
                  arguments: {'title': s.$1},
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          s.$3,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.$2,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.$1,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: s.$4 ? AppColors.primary : Colors.transparent,
                          border: Border.all(
                            color: s.$4
                                ? AppColors.primary
                                : const Color(0xFFD2C4BE),
                            width: 1.5,
                          ),
                        ),
                        child: s.$4
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
