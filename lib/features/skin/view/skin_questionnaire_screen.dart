import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clinical skin onboarding — converted from `doc/goal.md` (5 screens).
class SkinQuestionnaireScreen extends StatefulWidget {
  const SkinQuestionnaireScreen({
    super.key,
    this.fromRegister = false,
  });

  /// After first-time register + OTP, finish navigates to main shell.
  final bool fromRegister;

  @override
  State<SkinQuestionnaireScreen> createState() =>
      _SkinQuestionnaireScreenState();
}

class _SkinQuestionnaireScreenState extends State<SkinQuestionnaireScreen> {
  final _pageController = PageController();
  final _searchCtrl = TextEditingController();
  int _step = 0;

  // Step 0 — Concerns + Tone
  final _concerns = <String>{'Hydration'};
  double _skinTone = 0.35;
  String _undertone = 'Cool';

  // Step 1 — Beauty Goals
  final _goals = <String>{'Clear Skin'};

  // Step 2 — Skin Profile
  String? _skinType = 'Combination';

  // Step 3 — Ingredient Avoidance
  final _allergens = <String>{'Fragrance', 'Alcohol'};

  // Step 4 — Routine Preferences
  String _timePref = 'Both';
  String _complexity = 'Advanced';
  final _planChips = <String>{'SPF', 'Niacinamide', 'Ceramides', 'Peptides'};

  static const _concernOptions = <_ConcernItem>[
    _ConcernItem(
      'Hydration',
      'Restore moisture balance and plump dryness.',
      Icons.water_drop_outlined,
    ),
    _ConcernItem(
      'Texture',
      'Smooth rough patches and refine overall feel.',
      Icons.texture,
    ),
    _ConcernItem(
      'Acne',
      'Calm breakouts and prevent recurring congestion.',
      Icons.bubble_chart_outlined,
    ),
    _ConcernItem(
      'Wrinkles',
      'Softens fine lines and supports firmness.',
      Icons.timeline,
    ),
    _ConcernItem(
      'Dark Spots',
      'Fade discoloration for a more even tone.',
      Icons.brightness_6_outlined,
    ),
    _ConcernItem(
      'Redness',
      'Soothe sensitivity and visible flushing.',
      Icons.favorite_border,
    ),
  ];

  static const _goalOptions = <_GoalItem>[
    _GoalItem(
      'Clear Skin',
      'Achieve an even, blemish-free complexion with specialized care.',
      Icons.auto_awesome,
    ),
    _GoalItem(
      'Anti-aging',
      'Target fine lines and promote elasticity for a youthful appearance.',
      Icons.spa_outlined,
    ),
    _GoalItem(
      'Glow',
      'Boost radiance and revive dull skin for a natural, healthy shine.',
      Icons.wb_sunny_outlined,
    ),
    _GoalItem(
      'Acne Control',
      'Combat breakouts and soothe inflammation with clinical precision.',
      Icons.healing_outlined,
    ),
    _GoalItem(
      'Makeup Matching',
      'Find the perfect foundation shade and formula for your skin.',
      Icons.face_retouching_natural,
    ),
  ];

  static const _skinTypes = <_SkinTypeItem>[
    _SkinTypeItem(
      'Oily',
      'Visible shine throughout the day, enlarged pores, and prone to occasional congestion.',
      Icons.opacity,
    ),
    _SkinTypeItem(
      'Dry',
      'Persistent tightness, rough patches, or flaky areas. Your skin absorbs moisture rapidly.',
      Icons.water_drop,
    ),
    _SkinTypeItem(
      'Combination',
      'An oily T-zone (forehead, nose, chin) paired with dry or normal cheeks.',
      Icons.blur_on,
    ),
    _SkinTypeItem(
      'Sensitive',
      'Reacts easily to products, prone to redness, itching, or burning sensations.',
      Icons.health_and_safety_outlined,
    ),
  ];

  static const _allergenOptions = <_AllergenItem>[
    _AllergenItem(
      'Fragrance',
      'Synthetic scents that can trigger irritation or headaches.',
      Icons.air,
    ),
    _AllergenItem(
      'Alcohol',
      'Drying alcohols that may compromise the skin barrier.',
      Icons.science_outlined,
    ),
    _AllergenItem(
      'Sulfates',
      'Harsh surfactants that strip natural oils.',
      Icons.cleaning_services_outlined,
    ),
    _AllergenItem(
      'Essential Oils',
      'Plant oils that can sensitize reactive skin.',
      Icons.local_florist_outlined,
    ),
    _AllergenItem(
      'Parabens',
      'Preservatives some prefer to exclude from formulas.',
      Icons.biotech_outlined,
    ),
  ];

  static const _timeOptions = <_TimeOption>[
    _TimeOption('Morning', Icons.wb_twilight),
    _TimeOption('Evening', Icons.nights_stay_outlined),
    _TimeOption('Both', Icons.autorenew),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _back() {
    if (_step > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.maybePop(context);
    }
  }

  void _finish() {
    if (widget.fromRegister) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.mainShell,
        (_) => false,
      );
      return;
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.mainShell);
    }
  }

  String get _appBarTitle {
    switch (_step) {
      case 0:
        return 'CONCERNS';
      case 1:
        return 'GOALS';
      case 2:
        return 'PROFILE';
      case 3:
        return 'AVOID';
      default:
        return 'ROUTINE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _GoalAppBar(
              title: _appBarTitle,
              onBack: _back,
              onSkip: _step < 4 ? _next : _finish,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (_step + 1) / 5,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _buildConcernsTone(),
                  _buildBeautyGoals(),
                  _buildSkinProfile(),
                  _buildIngredientAvoidance(),
                  _buildRoutinePreferences(),
                ],
              ),
            ),
            _ContinueFooter(
              label: _step == 4 ? 'DONE' : 'CONTINUE',
              onPressed: _next,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Screen 5 / Step 0: Concerns + Skin Tone ─────────────────────────────

  Widget _buildConcernsTone() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        Text(
          'PERSONALIZATION',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Build your clinical profile',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Share your concerns and tone so we can tailor every recommendation with clinical precision.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'What are your concerns?',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        ..._concernOptions.map((c) {
          final selected = _concerns.contains(c.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ConcernCard(
              item: c,
              selected: selected,
              onTap: () => setState(() {
                if (selected) {
                  _concerns.remove(c.title);
                } else {
                  _concerns.add(c.title);
                }
              }),
            ),
          );
        }),
        const SizedBox(height: 20),
        Text(
          'Your skin tone & undertone',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    AppAssets.lookNatural,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Adjust your skin tone',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                ),
                child: Slider(
                  value: _skinTone,
                  onChanged: (v) => setState(() => _skinTone = v),
                  activeColor: Color.lerp(
                    const Color(0xFFF9E4D4),
                    const Color(0xFF3C201F),
                    _skinTone,
                  ),
                  inactiveColor: const Color(0xFFD2C4BE).withValues(alpha: 0.4),
                ),
              ),
              Container(
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF9E4D4), Color(0xFF3C201F)],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: ['Cool', 'Warm', 'Neutral'].map((u) {
                  final selected = _undertone == u;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: u == 'Neutral' ? 0 : 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _undertone = u),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFFFDBCE)
                                : AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : const Color(0xFFD2C4BE)
                                      .withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            u,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E2D9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'AI will refine shade matching using your tone and undertone selections.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.4,
                    color: const Color(0xFF72635C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Screen 4 / Step 1: Beauty Goals ─────────────────────────────────────

  Widget _buildBeautyGoals() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        Text(
          'What are your beauty goals?',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Select the outcomes that matter most. We will prioritize formulations around these goals.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ..._goalOptions.map((g) {
          final selected = _goals.contains(g.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GoalCard(
              item: g,
              selected: selected,
              onTap: () => setState(() {
                if (selected) {
                  _goals.remove(g.title);
                } else {
                  _goals.add(g.title);
                }
              }),
            ),
          );
        }),
      ],
    );
  }

  // ─── Screen 3 / Step 2: Skin Profile ─────────────────────────────────────

  Widget _buildSkinProfile() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        Text(
          'Tell us about your skin',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Understanding your skin type is the foundation of your personalized skincare formula. Select the category that best describes your complexion's daily behavior.",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            height: 1.55,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ..._skinTypes.map((t) {
          final selected = _skinType == t.title;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SkinTypeCard(
              item: t,
              selected: selected,
              onTap: () => setState(() => _skinType = t.title),
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.9),
                const Color(0xFF5C3D32),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CLINICAL MATCH',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: const Color(0xFFFFDBCE),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your skin type unlocks the right actives',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We calibrate concentration and texture to how your skin behaves day to day.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  height: 1.45,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Screen 2 / Step 3: Ingredient Avoidance ─────────────────────────────

  Widget _buildIngredientAvoidance() {
    final query = _searchCtrl.text.toLowerCase();
    final filtered = _allergenOptions
        .where(
          (a) =>
              a.title.toLowerCase().contains(query) ||
              a.subtitle.toLowerCase().contains(query),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        Text(
          'Ingredients to avoid',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Select substances that react with your skin or that you prefer to exclude from your clinical formulation.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            height: 1.55,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _searchCtrl,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.plusJakartaSans(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search specific ingredients (e.g.)',
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD2C4BE)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFD2C4BE).withValues(alpha: 0.6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'COMMON ALLERGENS',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...filtered.map((a) {
          final on = _allergens.contains(a.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AllergenCard(
              item: a,
              enabled: on,
              onChanged: (v) => setState(() {
                if (v) {
                  _allergens.add(a.title);
                } else {
                  _allergens.remove(a.title);
                }
              }),
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E2D9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'You can update avoided ingredients anytime from your Skin Profile.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.4,
                    color: const Color(0xFF72635C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Screen 1 / Step 4: Routine Preferences ──────────────────────────────

  Widget _buildRoutinePreferences() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        Text(
          'Tell us about your routine',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'To craft your clinical-grade skincare plan, we need to understand how much time you can dedicate to your daily transformation.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            height: 1.55,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'ROUTINE FREQUENCY',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'When do you prefer to perform your skincare rituals?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        ..._timeOptions.map((t) {
          final selected = _timePref == t.label;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() => _timePref = t.label),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFD2C4BE).withValues(alpha: 0.35),
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(t.icon, color: AppColors.primary, size: 22),
                    const SizedBox(width: 14),
                    Text(
                      t.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        Text(
          'ROUTINE COMPLEXITY',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How many steps are you willing to include in your regimen?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        _ComplexityCard(
          title: 'Simple',
          subtitle: 'Cleanse, Hydrate, Protect. (3 steps)',
          selected: _complexity == 'Simple',
          onTap: () => setState(() => _complexity = 'Simple'),
        ),
        const SizedBox(height: 10),
        _ComplexityCard(
          title: 'Advanced',
          subtitle: 'The full multi-layered treatment. (7+ steps)',
          selected: _complexity == 'Advanced',
          onTap: () => setState(() => _complexity = 'Advanced'),
        ),
        const SizedBox(height: 24),
        Text(
          'Common Elements in Your Future Plan:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['SPF', 'Niacinamide', 'Ceramides', 'Peptides'].map((chip) {
            final selected = _planChips.contains(chip);
            return GestureDetector(
              onTap: () => setState(() {
                if (selected) {
                  _planChips.remove(chip);
                } else {
                  _planChips.add(chip);
                }
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.iconMuted : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selected
                        ? AppColors.iconMuted
                        : const Color(0xFFD2C4BE).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  chip,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Shared chrome ───────────────────────────────────────────────────────────

class _GoalAppBar extends StatelessWidget {
  const _GoalAppBar({
    required this.title,
    required this.onBack,
    required this.onSkip,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              color: AppColors.iconMuted,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.iconMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueFooter extends StatelessWidget {
  const _ContinueFooter({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
          ),
        ),
      ),
      child: GlowPrimaryButton(
        label: label,
        height: 52,
        icon: Icons.arrow_forward_ios,
        onPressed: onPressed,
      ),
    );
  }
}

// ─── Cards ───────────────────────────────────────────────────────────────────

class _ConcernCard extends StatelessWidget {
  const _ConcernCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _ConcernItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Colors.white : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFFD2C4BE).withValues(alpha: 0.3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFC5AF).withValues(alpha: 0.7),
              ),
              child: Icon(item.icon, size: 22, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: selected ? AppColors.primary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _GoalItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: AppColors.primary, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
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
    );
  }
}

class _SkinTypeCard extends StatelessWidget {
  const _SkinTypeCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _SkinTypeItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? Colors.white : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFFD2C4BE).withValues(alpha: 0.35),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.surfacePeach,
              ),
              child: Icon(item.icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
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
    );
  }
}

class _AllergenCard extends StatelessWidget {
  const _AllergenCard({
    required this.item,
    required this.enabled,
    required this.onChanged,
  });

  final _AllergenItem item;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.45)
              : const Color(0xFFD2C4BE).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.surfaceSoft,
            ),
            child: Icon(item.icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ComplexityCard extends StatelessWidget {
  const _ComplexityCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? Colors.white : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFFD2C4BE).withValues(alpha: 0.35),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Models ──────────────────────────────────────────────────────────────────

class _ConcernItem {
  const _ConcernItem(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}

class _GoalItem {
  const _GoalItem(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}

class _SkinTypeItem {
  const _SkinTypeItem(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}

class _AllergenItem {
  const _AllergenItem(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}

class _TimeOption {
  const _TimeOption(this.label, this.icon);
  final String label;
  final IconData icon;
}
