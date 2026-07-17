import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinEvolutionScreen extends StatefulWidget {
  const SkinEvolutionScreen({super.key});

  @override
  State<SkinEvolutionScreen> createState() => _SkinEvolutionScreenState();
}

class _SkinEvolutionScreenState extends State<SkinEvolutionScreen> {
  double _slider = 0.5;
  int _periodIndex = 0;

  static const _periods = ['Current', '30 Days', '90 Days'];

  static const _metrics = <(String, String, IconData)>[
    ('Pore Visibility', '-14%', Icons.texture_outlined),
    ('Hydration Level', '+22%', Icons.water_drop_outlined),
    ('Redness Reduction', '-8%', Icons.auto_awesome_outlined),
  ];

  static const _historyEntries = <(String, String, String)>[
    ('September', 'Month 1: Baseline', AppAssets.aiSkin),
    ('October', 'Month 2: Routine Fix', AppAssets.realtimeFace),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'Skin Evolution',
        titleColor: AppColors.textPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.notifications),
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
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          const _LatestGlowScoreSection(),
          const SizedBox(height: 20),
          _PeriodSelector(
            periods: _periods,
            selectedIndex: _periodIndex,
            onSelected: (index) => setState(() => _periodIndex = index),
          ),
          const SizedBox(height: 20),
          _BeforeAfterCompare(slider: _slider, onSliderChanged: (value) {
            setState(() => _slider = value);
          }),
          const SizedBox(height: 20),
          for (var i = 0; i < _metrics.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _EvolutionMetricCard(
              label: _metrics[i].$1,
              value: _metrics[i].$2,
              icon: _metrics[i].$3,
            ),
          ],
          const SizedBox(height: 28),
          Text(
            'Progress History',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textWarm,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < _historyEntries.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: _ProgressHistoryTile(
                    month: _historyEntries[i].$1,
                    subtitle: _historyEntries[i].$2,
                    imageAsset: _historyEntries[i].$3,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _BeautyForecastCard(
            onViewDetails: () =>
                Navigator.pushNamed(context, RouteNames.beautyForecast),
          ),
        ],
      ),
    );
  }
}

class _LatestGlowScoreSection extends StatelessWidget {
  const _LatestGlowScoreSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'LATEST GLOW SCORE',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '85',
              style: GoogleFonts.playfairDisplay(
                fontSize: 48,
                fontWeight: FontWeight.w600,
                height: 1,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '/100',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                height: 1,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.surfacePeach,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.show_chart_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '15% improvement since month 1',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < periods.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedIndex == i
                      ? AppColors.primary
                      : AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(
                  periods[i],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == i
                        ? Colors.white
                        : AppColors.textWarm,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _BeforeAfterCompare extends StatelessWidget {
  const _BeforeAfterCompare({
    required this.slider,
    required this.onSliderChanged,
  });

  final double slider;
  final ValueChanged<double> onSliderChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1.12,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final split = (width * slider).clamp(28.0, width - 28);

            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                onSliderChanged(
                  (slider + details.delta.dx / width).clamp(0.08, 0.92),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAssets.lookNatural,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.2),
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: slider,
                      child: SizedBox(
                        width: width,
                        height: constraints.maxHeight,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0x33B0563F),
                            BlendMode.srcATop,
                          ),
                          child: Image.asset(
                            AppAssets.lookNatural,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.2),
                          ),
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
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                  Positioned(
                    left: split - 20,
                    top: constraints.maxHeight / 2 - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.unfold_more_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: _CompareBadge(label: 'BEFORE'),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _CompareBadge(label: 'AFTER'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CompareBadge extends StatelessWidget {
  const _CompareBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFEA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _EvolutionMetricCard extends StatelessWidget {
  const _EvolutionMetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlowSoftCard(
      color: AppColors.surfaceSoft,
      padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textWarm,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF5E2D9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ProgressHistoryTile extends StatelessWidget {
  const _ProgressHistoryTile({
    required this.month,
    required this.subtitle,
    required this.imageAsset,
  });

  final String month;
  final String subtitle;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          month,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textWarm,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textWarm.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

class _BeautyForecastCard extends StatelessWidget {
  const _BeautyForecastCard({required this.onViewDetails});

  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                'Beauty Forecast',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Based on your current product absorption and cellular turnover, '
            'your skin is on track for peak health.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: onViewDetails,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surfacePeach,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'View Details',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '92',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'Glow Score',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Expected by Day 60',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
