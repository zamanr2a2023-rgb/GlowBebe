import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinEvolutionScreen extends StatefulWidget {
  const SkinEvolutionScreen({super.key});

  @override
  State<SkinEvolutionScreen> createState() => _SkinEvolutionScreenState();
}

class _SkinEvolutionScreenState extends State<SkinEvolutionScreen> {
  double _slider = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 64,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.iconMuted,
            weight: 200,
          ),
        ),
        title: Text(
          'Skin Progress',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              size: 22,
              color: AppColors.iconMuted,
              weight: 200,
            ),
          ),
        ],
        backgroundColor: AppColors.background.withValues(alpha: 0.92),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfacePeach,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI ANALYSIS COMPLETE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            '15%',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 52,
              fontWeight: FontWeight.w600,
              height: 1.05,
              color: AppColors.primary,
            ),
          ),
          Text(
            'Improvement',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              height: 1.15,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Your skin's texture and hydration levels have shown "
            'significant progress over the last 30 days. We\'ve detected '
            'a visible reduction in redness and improved barrier function.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Before / After compare slider
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final split = (w * _slider).clamp(24.0, w - 24);
                  return GestureDetector(
                    onHorizontalDragUpdate: (d) {
                      setState(() {
                        _slider =
                            (_slider + d.delta.dx / w).clamp(0.08, 0.92);
                      });
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          AppAssets.lookSoftGlam,
                          fit: BoxFit.cover,
                        ),
                        ClipRect(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: _slider,
                            child: SizedBox(
                              width: w,
                              height: constraints.maxHeight,
                              child: Image.asset(
                                AppAssets.lookNatural,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: split - 1,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        Positioned(
                          left: split - 18,
                          top: constraints.maxHeight / 2 - 18,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.drag_handle,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          bottom: 14,
                          child: Text(
                            'DAY 1',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 14,
                          bottom: 14,
                          child: Text(
                            'DAY 30',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _MetricCard(label: 'HYDRATION', value: '+22%', progress: 0.78),
          const SizedBox(height: 12),
          const _MetricCard(label: 'TEXTURE', value: '+12%', progress: 0.58),
          const SizedBox(height: 12),
          const _MetricCard(label: 'ELASTICITY', value: '+8%', progress: 0.42),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return GlowSoftCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
