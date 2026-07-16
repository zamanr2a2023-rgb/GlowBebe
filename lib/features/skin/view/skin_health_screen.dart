import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinHealthScreen extends StatelessWidget {
  const SkinHealthScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: !embedded,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, embedded ? 100 : 32),
          children: [
            GlowSerifTitle('Skin Health', size: 28, letterSpacing: 0.8),
            const SizedBox(height: 6),
            Text(
              'Your personalized skin wellness hub',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GlowSoftCard(
              child: Row(
                children: [
                  const GlowScoreRing(
                    score: 85,
                    size: 110,
                    label: 'GLOW',
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Skin Score',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Excellent condition with room to refine texture and pores.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.45,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlowOutlinedButton(
              label: 'AI SKIN ANALYSIS',
              icon: Icons.face_retouching_natural,
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.skinScanIntro),
            ),
            const SizedBox(height: 12),
            GlowOutlinedButton(
              label: 'AI SKIN CONSULTATION',
              icon: Icons.chat_bubble_outline,
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.consultStart),
            ),
            const SizedBox(height: 28),
            const GlowSectionHeader(title: 'Skin Metrics'),
            const SizedBox(height: 12),
            GlowSoftCard(
              child: Column(
                children: const [
                  GlowMetricBar(label: 'Hydration', value: 82),
                  SizedBox(height: 16),
                  GlowMetricBar(label: 'Texture', value: 74),
                  SizedBox(height: 16),
                  GlowMetricBar(label: 'Acne', value: 91),
                  SizedBox(height: 16),
                  GlowMetricBar(label: 'Wrinkles', value: 88),
                  SizedBox(height: 16),
                  GlowMetricBar(label: 'Dark Spots', value: 70),
                  SizedBox(height: 16),
                  GlowMetricBar(label: 'Redness', value: 79),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const GlowSectionHeader(title: 'Today\'s Protocols'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ProtocolStatusCard(
                    title: 'Morning',
                    status: 'COMPLETED',
                    icon: Icons.wb_sunny_outlined,
                    accent: true,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.todaysRoutine,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProtocolStatusCard(
                    title: 'Night',
                    status: 'UP NEXT',
                    icon: Icons.nightlight_round,
                    accent: false,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.routineOverview,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProtocolStatusCard extends StatelessWidget {
  const _ProtocolStatusCard({
    required this.title,
    required this.status,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String status;
  final IconData icon;
  final bool accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlowSoftCard(
      onTap: onTap,
      color: accent ? AppColors.surfacePeach : AppColors.surface,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            status,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
