import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultStartScreen extends StatelessWidget {
  const ConsultStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'AI Consultation'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surfacePeach,
                          AppColors.surfaceSoft,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          size: 56,
                          color: AppColors.primary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Lumière Skin Coach',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                GlowSerifTitle('Talk through your concerns', size: 26),
                const SizedBox(height: 10),
                Text(
                  'Get personalized guidance on acne, texture, aging, and product routines — powered by your latest scan.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                _Feature(
                  icon: Icons.chat_bubble_outline,
                  title: 'Conversational coach',
                  body: 'Ask anything about your skin in plain language.',
                ),
                _Feature(
                  icon: Icons.history,
                  title: 'Session history',
                  body: 'Revisit past advice anytime.',
                ),
                _Feature(
                  icon: Icons.recommend_outlined,
                  title: 'Actionable next steps',
                  body: 'Walk away with a clear regimen tweak.',
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: [
                  GlowPrimaryButton(
                    label: 'START CONSULTATION',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.consultConcerns,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlowOutlinedButton(
                    label: 'VIEW HISTORY',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.consultHistory,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  body,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
