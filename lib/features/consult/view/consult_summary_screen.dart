import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultSummaryScreen extends StatelessWidget {
  const ConsultSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Consult Summary'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          GlowSerifTitle('Session wrap-up', size: 26),
          const SizedBox(height: 8),
          Text(
            'Jul 16 · Dark spots focus',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          GlowSoftCard(
            color: AppColors.surfacePeach,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key takeaways',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Prioritize morning vitamin C + SPF, keep niacinamide nightly, '
                  'and introduce gentle exfoliation only 2 nights per week. '
                  'Expect visible tone improvement in 4–6 weeks with consistency.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const GlowSectionHeader(title: 'Recommended actions'),
          const SizedBox(height: 12),
          ..._actions.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlowSoftCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        a,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GlowPrimaryButton(
            label: 'UPDATE REGIMEN',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.skinRegimen),
          ),
          const SizedBox(height: 12),
          GlowOutlinedButton(
            label: 'DONE',
            onPressed: () {
              Navigator.popUntil(context, (r) => r.isFirst);
            },
          ),
        ],
      ),
    );
  }

  static const _actions = [
    'Add vitamin C serum under SPF',
    'Keep niacinamide in night treat step',
    'Limit acids to 2 nights / week',
    'Re-scan in 14 days to track tone',
  ];
}
