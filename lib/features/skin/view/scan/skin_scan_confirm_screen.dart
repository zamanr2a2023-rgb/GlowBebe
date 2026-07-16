import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinScanConfirmScreen extends StatelessWidget {
  const SkinScanConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Confirm Photo'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                Text(
                  'Looking good?',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Make sure your face is clear, centered, and evenly lit.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GlowImagePlaceholder(
                    height: 380,
                    borderRadius: 20,
                    child: Container(
                      color: AppColors.surfaceSoft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face,
                            size: 80,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Captured photo',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                    label: 'CONFIRM & ANALYZE',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.skinScanAnalyzing,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlowOutlinedButton(
                    label: 'RETAKE',
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      RouteNames.skinScanCamera,
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
