import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineCompleteScreen extends StatelessWidget {
  const RoutineCompleteScreen({super.key});

  void _backToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.mainShell,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'LUMINA',
        brandStyle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.notifications),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.iconMuted,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [
          const _CompletionHero(),
          const SizedBox(height: 40),
          Text(
            'MORNING ROUTINE',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're All Set!",
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your skin is primed and protected for the day ahead. '
            'Consistency is the secret to radiance.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          GlowPrimaryButton(
            label: 'BACK TO DASHBOARD',
            height: 52,
            onPressed: () => _backToDashboard(context),
          ),
          const SizedBox(height: 40),
          const _AdherenceCalendar(),
          const SizedBox(height: 24),
          const _NextRoutineCard(),
          const SizedBox(height: 24),
          const _SkinInsightCard(),
        ],
      ),
    );
  }
}

class _CompletionHero extends StatelessWidget {
  const _CompletionHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: AspectRatio(
        aspectRatio: 350 / 437.5,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.lookNatural,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.3),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Concentric focus rings from Figma.
            Align(
              alignment: const Alignment(-0.5, -0.35),
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '+1 DAY STREAK',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                          color: Colors.white,
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
    );
  }
}

class _AdherenceCalendar extends StatelessWidget {
  const _AdherenceCalendar();

  // label, date, completed, hasIndicator
  static const _days = <(String, String, bool, bool)>[
    ('MON', '10', false, false),
    ('TUE', '11', false, false),
    ('WED', '12', true, false),
    ('THU', '13', true, false),
    ('FRI', '14', true, true),
    ('SAT', '15', false, false),
    ('SUN', '16', false, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDED),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weekly Adherence',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                'February 2024',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final (label, date, done, indicator) in _days)
                Column(
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: done
                                ? const Color(0xFFFFC5AF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: done
                                ? Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.2),
                                    width: 2,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            date,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: done
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: done
                                  ? const Color(0xFF7A4F3E)
                                  : AppColors.textSecondary
                                      .withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        if (indicator)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextRoutineCard extends StatelessWidget {
  const _NextRoutineCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E2D9),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.nightlight_outlined,
            size: 20,
            color: Color(0xFF695C55),
          ),
          const SizedBox(height: 8),
          Text(
            'Next Routine',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              color: const Color(0xFF695C55),
            ),
          ),
          Text(
            'Night Care Cycle',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: const Color(0xFF72635C),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '20:30',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 46,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    color: const Color(0xFF695C55),
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF695C55)),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: Color(0xFF695C55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkinInsightCard extends StatelessWidget {
  const _SkinInsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFD2C4BE)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B5B53), Color(0xFF805443)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '"Based on your 14-day adherence, your skin\'s moisture '
            'barrier has improved by 22%."',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              height: 1.35,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '— LUMINA AI INSIGHT',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
