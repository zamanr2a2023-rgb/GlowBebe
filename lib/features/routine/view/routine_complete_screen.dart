import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineCompleteScreen extends StatelessWidget {
  const RoutineCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.surfacePeach,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 28),
              GlowSerifTitle(
                'Routine complete',
                size: 30,
                align: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Beautiful work. Your consistency is already shaping tomorrow\'s glow score.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  height: 1.55,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              GlowSoftCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('Steps', '4'),
                    _stat('Time', '7m'),
                    _stat('Streak', '12d'),
                  ],
                ),
              ),
              const Spacer(),
              GlowPrimaryButton(
                label: 'BACK TO HOME',
                onPressed: () {
                  final nav = Navigator.of(context);
                  if (nav.canPop()) {
                    nav.popUntil((route) =>
                        route.isFirst ||
                        route.settings.name == RouteNames.mainShell ||
                        route.settings.name == RouteNames.home);
                  } else {
                    nav.pushReplacementNamed(RouteNames.home);
                  }
                },
              ),
              const SizedBox(height: 12),
              GlowOutlinedButton(
                label: 'VIEW FORECAST',
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.beautyForecast),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
