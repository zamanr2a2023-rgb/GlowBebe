import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineStepsScreen extends StatelessWidget {
  const RoutineStepsScreen({super.key});

  static const _steps = [
    ('01', 'CLEANSE', 'Gentle foaming cleanser', '60 seconds'),
    ('02', 'TREAT', 'Hydrating serum', 'Pat & wait 60s'),
    ('03', 'MOISTURIZE', 'Barrier cream', 'Massage in'),
    ('04', 'PROTECT', 'Mineral SPF 50', 'Apply evenly'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Routine Steps'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                Text(
                  'Follow each step in order for best absorption.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ..._steps.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlowSoftCard(
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.routineActiveStep,
                        arguments: {
                          'title': s.$2,
                          'subtitle': s.$3,
                        },
                      ),
                      child: Row(
                        children: [
                          Text(
                            s.$1,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary.withValues(alpha: 0.35),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.$2,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.4,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  s.$3,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  s.$4,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.play_circle_outline,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: GlowPrimaryButton(
                label: 'BEGIN STEP 1',
                onPressed: () => Navigator.pushNamed(
                  context,
                  RouteNames.routineActiveStep,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
