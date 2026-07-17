import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinHealthScreen extends StatelessWidget {
  const SkinHealthScreen({super.key, this.embedded = false});

  final bool embedded;

  static const _metrics = <(String, int)>[
    ('Hydration', 65),
    ('Texture', 82),
    ('Acne', 92),
    ('Wrinkles', 88),
    ('Dark Spots', 78),
    ('Redness', 74),
  ];

  static const _scienceTags = ['Retinol', 'Vegan', 'SPF 50+'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: !embedded,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, embedded ? 100 : 32),
          children: [
            _SkinHealthHeader(
              showBack: !embedded,
              onBack: () => Navigator.maybePop(context),
              onNotify: () =>
                  Navigator.pushNamed(context, RouteNames.notifications),
            ),
            const SizedBox(height: 20),
            const _GlowScoreSection(),
            const SizedBox(height: 16),
            GlowPrimaryButton(
              label: 'AI SKIN ANALYSIS',
              height: 52,
              icon: Icons.auto_awesome,
              iconLeading: true,
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
            Text(
              'Skin Metrics',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            GlowSoftCard(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
              child: Column(
                children: [
                  for (var i = 0; i < _metrics.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _SkinMetricRow(
                      label: _metrics[i].$1,
                      value: _metrics[i].$2,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            GlowPrimaryButton(
              label: 'DETAILS',
              height: 52,
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.skinEvolution),
            ),
            const SizedBox(height: 10),
            Text(
              'View comprehensive analysis including pore size and UV damage depth.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.4,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Daily Protocol',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            const _DailyProtocolSection(),
            const SizedBox(height: 20),
            GlowPrimaryButton(
              label: 'DETAILS',
              height: 52,
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.routineOverview),
            ),
            const SizedBox(height: 28),
            Text(
              'Science of Smooth',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Our AI models analyze over 50 points on your face to determine clinical-grade skin health metrics. Regular tracking helps us adapt your regimen as your skin environment changes.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _scienceTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E1D7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF4E4540),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  AppAssets.scienceOfSmooth,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, 0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkinHealthHeader extends StatelessWidget {
  const _SkinHealthHeader({
    required this.showBack,
    required this.onBack,
    required this.onNotify,
  });

  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onNotify;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              color: AppColors.iconMuted,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            )
          else
            const SizedBox(width: 40),
          Expanded(
            child: Text(
              'Skin Health',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: onNotify,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: const Color(0xFFD2C4BE).withValues(alpha: 0.4),
              ),
            ),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.iconMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowScoreSection extends StatelessWidget {
  const _GlowScoreSection();

  @override
  Widget build(BuildContext context) {
    return GlowSoftCard(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        children: [
          Text(
            'AI Glow Score',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const GlowScoreRing(
            score: 85,
            size: 176,
            label: 'EXCELLENT',
            ringStrokeWidth: 8,
          ),
          const SizedBox(height: 24),
          Text(
            '^ +5 improvement in last 30 days',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4A7C59),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your skin improved by 12% this month',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkinMetricRow extends StatelessWidget {
  const _SkinMetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: value / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceSoft,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$value',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '/100',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _DailyProtocolSection extends StatelessWidget {
  const _DailyProtocolSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProtocolSummaryCard(
          icon: Icons.wb_sunny_outlined,
          title: 'Morning Protocol',
          time: '8:00 AM',
          status: 'COMPLETED',
          statusColor: const Color(0xFF4A7C59),
          statusTrailingIcon: Icons.check,
          onTap: () =>
              Navigator.pushNamed(context, RouteNames.routineOverview),
        ),
        const SizedBox(height: 12),
        _ProtocolSummaryCard(
          icon: Icons.nightlight_round,
          title: 'Night Protocol',
          time: '10:00 PM',
          status: 'UP NEXT',
          statusLeadingIcon: Icons.schedule_outlined,
          onTap: () =>
              Navigator.pushNamed(context, RouteNames.routineOverview),
        ),
      ],
    );
  }
}

class _ProtocolSummaryCard extends StatelessWidget {
  const _ProtocolSummaryCard({
    required this.icon,
    required this.title,
    required this.time,
    required this.status,
    required this.onTap,
    this.statusColor = AppColors.primary,
    this.statusLeadingIcon,
    this.statusTrailingIcon,
  });

  final IconData icon;
  final String title;
  final String time;
  final String status;
  final VoidCallback onTap;
  final Color statusColor;
  final IconData? statusLeadingIcon;
  final IconData? statusTrailingIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (statusLeadingIcon != null) ...[
                    Icon(statusLeadingIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    status,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: statusColor,
                    ),
                  ),
                  if (statusTrailingIcon != null) ...[
                    const SizedBox(width: 4),
                    Icon(statusTrailingIcon, size: 14, color: statusColor),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
