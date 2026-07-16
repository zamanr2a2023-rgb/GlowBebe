import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinScanResultsScreen extends StatelessWidget {
  const SkinScanResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'Scan Results',
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.skinRegimen),
            icon: const Icon(Icons.checklist_rtl, color: AppColors.iconMuted),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Center(
            child: GlowScoreRing(
              score: 85,
              size: 140,
              label: 'EXCELLENT',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Glow Score',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                GlowImagePlaceholder(
                  height: 220,
                  borderRadius: 20,
                  child: Container(
                    color: AppColors.surfaceSoft,
                    child: Center(
                      child: Icon(
                        Icons.face,
                        size: 72,
                        color: AppColors.primary.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'AI mask overlay · 10%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const GlowSectionHeader(title: 'Metrics'),
          const SizedBox(height: 12),
          GlowSoftCard(
            child: Column(
              children: const [
                GlowMetricBar(label: 'Hydration', value: 82),
                SizedBox(height: 14),
                GlowMetricBar(label: 'Texture', value: 74),
                SizedBox(height: 14),
                GlowMetricBar(label: 'Acne', value: 91),
                SizedBox(height: 14),
                GlowMetricBar(label: 'Wrinkles', value: 88),
                SizedBox(height: 14),
                GlowMetricBar(label: 'Dark Spots', value: 70),
                SizedBox(height: 14),
                GlowMetricBar(label: 'Redness', value: 79),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlowSoftCard(
            color: AppColors.surfacePeach,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Summary',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your skin barrier looks strong with excellent acne control. '
                  'Focus on refining texture and fading mild dark spots. '
                  'A gentle AHA 2–3 nights weekly plus daily SPF should accelerate results.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          GlowPrimaryButton(
            label: 'VIEW REGIMEN',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.skinRegimen),
          ),
          const SizedBox(height: 12),
          GlowOutlinedButton(
            label: 'TRACK EVOLUTION',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.skinEvolution),
          ),
        ],
      ),
    );
  }
}
