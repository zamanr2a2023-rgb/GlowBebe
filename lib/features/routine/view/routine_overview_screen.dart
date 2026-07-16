import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineOverviewScreen extends StatelessWidget {
  const RoutineOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Routine Overview'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          GlowSerifTitle('Your weekly care map', size: 24),
          const SizedBox(height: 8),
          Text(
            'Morning and night protocols tailored to your scan results.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _OverviewCard(
            title: 'Morning',
            subtitle: '4 steps · ~8 minutes',
            icon: Icons.wb_sunny_outlined,
            progress: 0.75,
            onTap: () => Navigator.pushNamed(context, RouteNames.routineSteps),
          ),
          const SizedBox(height: 12),
          _OverviewCard(
            title: 'Night',
            subtitle: '5 steps · ~12 minutes',
            icon: Icons.nightlight_round,
            progress: 0.0,
            onTap: () => Navigator.pushNamed(context, RouteNames.routineSteps),
          ),
          const SizedBox(height: 24),
          GlowSoftCard(
            color: AppColors.surfacePeach,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coach tip',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete morning SPF before leaving home — UV is the #1 factor that slows your forecast gains.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          GlowPrimaryButton(
            label: 'START STEPS',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.routineSteps),
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.progress,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlowSoftCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.iconMuted),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
