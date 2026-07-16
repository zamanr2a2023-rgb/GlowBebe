import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineActiveStepScreen extends StatelessWidget {
  const RoutineActiveStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final title = (args?['title'] as String?) ?? 'TREAT';
    final subtitle =
        (args?['subtitle'] as String?) ?? 'Apply serum and wait';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Active Step'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            GlowSerifTitle(subtitle, size: 26, align: TextAlign.center),
            const Spacer(),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 8,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '04:57',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 48,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'remaining',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GlowSoftCard(
              color: AppColors.surfacePeach,
              child: Text(
                'Massage gently upward until absorbed. Avoid the eye area.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GlowPrimaryButton(
              label: 'MARK COMPLETE',
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.routineComplete),
            ),
            const SizedBox(height: 12),
            GlowOutlinedButton(
              label: 'SKIP STEP',
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.routineComplete),
            ),
          ],
        ),
      ),
    );
  }
}
