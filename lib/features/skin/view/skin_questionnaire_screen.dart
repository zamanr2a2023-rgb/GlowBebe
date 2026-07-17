import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/auth/auth_navigation.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clinical skin onboarding — converted from `doc/goal.md` (5 screens).
class SkinQuestionnaireScreen extends StatefulWidget {
  const SkinQuestionnaireScreen({
    super.key,
    this.fromAuth = false,
  });

  /// After first-time login/register, finish navigates to main shell.
  final bool fromAuth;

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
  String _undertone = 'Neutral';

  // Step 1 — Beauty Goals
  final _goals = <String>{'Clear Skin'};

  // Step 2 — Skin Profile
  String? _skinType = 'Combination';

  // Step 3 — Ingredient Avoidance
  final _allergens = <String>{'Parabens'};

  // Step 4 — Routine Preferences
  String _timePref = 'Both';
  String _complexity = 'Advanced';

  static const _planElements = [
    'Retinol',
    'Hyaluronic Acid',
    'Vitamin C',
    'SPF 50+',
  ];

  static const _concernOptions = <_ConcernItem>[
    _ConcernItem(
      'Hydration',
      'Replenishing deep moisture and barrier health.',
      Icons.water_drop_outlined,
    ),
    _ConcernItem(
      'Texture',
      'Smoothing rough patches and refining pores.',
      Icons.texture,
    ),
    _ConcernItem(
      'Acne',
      'Targeting active breakouts and congestion.',
      Icons.bubble_chart_outlined,
    ),
    _ConcernItem(
      'Wrinkles',
      'Smoothing fine lines and restoring elasticity.',
      Icons.timeline,
    ),
    _ConcernItem(
      'Dark Spots',
      'Fading localized UV damage and post-acne marks.',
      Icons.blur_circular_outlined,
    ),
    _ConcernItem(
      'Redness',
      'Calming sensitivity and evening reactive skin.',
      Icons.report_outlined,
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
      Icons.medical_services_outlined,
    ),
    _GoalItem(
      'Makeup Matching',
      'Find the perfect foundation shade and formula for your skin.',
      Icons.palette_outlined,
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
      Icons.balance_outlined,
    ),
    _SkinTypeItem(
      'Sensitive',
      'Reacts easily to products, prone to redness, itching, or burning sensations.',
      Icons.spa_outlined,
    ),
  ];

  static const _allergenOptions = <_AllergenItem>[
    _AllergenItem(
      'Parabens',
      'Preservatives some prefer to exclude from formulas.',
      Icons.science_outlined,
    ),
    _AllergenItem(
      'Sulfates',
      'Harsh surfactants that strip natural oils.',
      Icons.open_in_new_outlined,
    ),
    _AllergenItem(
      'Fragrance',
      'Synthetic scents that can trigger irritation or headaches.',
      Icons.air_outlined,
    ),
    _AllergenItem(
      'Drying Alcohol',
      'Drying alcohols that may compromise the skin barrier.',
      Icons.wine_bar_outlined,
    ),
    _AllergenItem(
      'Mineral Oils',
      'Petroleum-derived oils that may clog pores or feel heavy.',
      Icons.water_drop_outlined,
    ),
  ];

  static const _timeOptions = <_TimeOption>[
    _TimeOption('Morning only', Icons.wb_twilight_outlined),
    _TimeOption('Night only', Icons.bedtime_outlined),
    _TimeOption('Both', Icons.wb_sunny_outlined),
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
    }
  }

  Future<void> _finish() async {
    await AuthNavigation.markGoalsOnboardingComplete();
    if (!mounted) return;

    if (widget.fromAuth) {
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

  String get _continueLabel {
    if (_step == 4) return 'Done';
    return 'NEXT STEP';
  }

  String get _selectedToneLabel {
    final depth = _skinTone < 0.33
        ? 'Light'
        : (_skinTone < 0.66 ? 'Medium' : 'Deep');
    return '$_undertone $depth';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _GoalFlowBackdrop(
        flat: _step == 3 || _step == 4,
        child: SafeArea(
          child: Column(
            children: [
              _GoalStepHeader(
                step: _step,
                totalSteps: 5,
                onSkip: _step < 4 ? _next : _finish,
                onBack: _step > 0 ? _back : null,
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
                label: _continueLabel,
                onPressed: _next,
                icon: _step == 4 ? Icons.check_circle_outline : Icons.arrow_forward_ios,
              ),
            ],
          ),
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
          'SKIN ANALYSIS',
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
          'Tailoring your perfect regimen.',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.25,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'To provide clinical-grade recommendations, we need to understand your unique canvas. Your selections here calibrate our AI formulation engine.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            height: 28 / 18,
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
            padding: const EdgeInsets.only(bottom: 12),
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD2C4BE).withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 308 / 256,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        AppAssets.productExtra1,
                        fit: BoxFit.cover,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.45),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected Tone:',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                  Text(
                                    _selectedToneLabel,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Adjust your skin tone',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF9E4D4),
                          Color(0xFFF2D2BD),
                          Color(0xFFE5B99A),
                          Color(0xFFC68642),
                          Color(0xFF8D5524),
                          Color(0xFF3C201F),
                        ],
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8,
                      trackShape: const RoundedRectSliderTrackShape(),
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: _skinTone,
                      onChanged: (v) => setState(() => _skinTone = v),
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: ['Neutral', 'Cool', 'Warm'].map((u) {
                  final selected = _undertone == u;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: u == 'Warm' ? 0 : 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _undertone = u),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFFFDBCE)
                                : AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(12),
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
                              fontSize: 14,
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E2D9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.psychology_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Our AI adjusts ingredient concentrations based on your melanin levels to prevent hyperpigmentation risks.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.45,
                    color: const Color(0xFF72635C),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'You can select multiple goals. Your data is processed with medical-grade privacy standards.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            height: 1.5,
            color: AppColors.textTertiary,
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
          "What's your beauty goal?",
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.25,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Select the areas you'd like to focus on. We'll curate your personalized routine based on your choices.",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            height: 28 / 18,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        ..._goalOptions.map((g) {
          final selected = _goals.contains(g.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
        const SizedBox(height: 8),
        Text(
          'You can select multiple goals. Your data is processed with medical-grade privacy standards.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            height: 1.5,
            color: AppColors.textTertiary,
          ),
        ),
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
            height: 34 / 28,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Understanding your skin type is the foundation of your personalized skincare formula. Select the category that best describes your complexion's daily behavior.",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 26 / 16,
            color: const Color(0xFF4E4540),
          ),
        ),
        const SizedBox(height: 28),
        ..._skinTypes.map((t) {
          final selected = _skinType == t.title;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _SkinTypeCard(
              item: t,
              selected: selected,
              onTap: () => setState(() => _skinType = t.title),
            ),
          );
        }),
        const _ExpertGuidanceCard(),
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
            height: 34 / 28,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select substances that react with your skin or that you prefer to exclude from your clinical formulation.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 24 / 16,
            color: const Color(0xFF4E4540),
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _searchCtrl,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 20 / 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Search specific ingredients (e.g.)',
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 20 / 16,
              color: const Color(0xFF6B7280),
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 18,
              color: Color(0xFF807570),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD2C4BE)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD2C4BE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'COMMON ALLERGENS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.primary,
            ),
          ),
        ),
        ...filtered.map((a) {
          final on = _allergens.contains(a.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E2D9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xFF72635C),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Our AI will automatically scan your product history for matches and exclude these from future recommendations.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 16 / 12,
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
            height: 34 / 28,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'To craft your clinical-grade skincare plan, we need to understand how much time you can dedicate to your daily transformation.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            height: 28 / 18,
            color: const Color(0xFF4E4540),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'ROUTINE FREQUENCY',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'When do you prefer to perform your skincare rituals?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 24 / 16,
            color: const Color(0xFF4E4540),
          ),
        ),
        const SizedBox(height: 16),
        ..._timeOptions.map((t) {
          final selected = _timePref == t.label;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _FrequencyCard(
              option: t,
              selected: selected,
              onTap: () => setState(() => _timePref = t.label),
            ),
          );
        }),
        const SizedBox(height: 12),
        Text(
          'ROUTINE COMPLEXITY',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How many steps are you willing to include in your regimen?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 24 / 16,
            color: const Color(0xFF4E4540),
          ),
        ),
        const SizedBox(height: 16),
        _ComplexityCard(
          title: 'Simple',
          subtitle: 'Cleanse, Hydrate, Protect. (3 steps)',
          stepCount: 3,
          selected: _complexity == 'Simple',
          onTap: () => setState(() => _complexity = 'Simple'),
        ),
        const SizedBox(height: 20),
        _ComplexityCard(
          title: 'Advanced',
          subtitle: 'The full multi-layered treatment. (7+ steps)',
          stepCount: 7,
          selected: _complexity == 'Advanced',
          onTap: () => setState(() => _complexity = 'Advanced'),
        ),
        const SizedBox(height: 32),
        Text(
          'Common Elements in Your Future Plan:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: const Color(0xFF4E4540),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _planElements.map((chip) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6B5B53),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                chip,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 16 / 12,
                  color: Colors.white,
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

class _GoalFlowBackdrop extends StatelessWidget {
  const _GoalFlowBackdrop({
    required this.child,
    this.flat = false,
  });

  final Widget child;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFFCF9F8)),
        if (!flat) ...[
          Positioned(
            right: -150,
            top: -150,
            child: IgnorePointer(
              child: Container(
                width: 460,
                height: 460,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFF7E1D7).withValues(alpha: 0.52),
                      const Color(0xFFF7E1D7).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -40,
            top: 80,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFC4AF).withValues(alpha: 0.22),
                      const Color(0xFFFFC4AF).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -120,
            bottom: -100,
            child: IgnorePointer(
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFD7C2B9).withValues(alpha: 0.18),
                      const Color(0xFFD7C2B9).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        child,
      ],
    );
  }
}

class _GoalStepHeader extends StatelessWidget {
  const _GoalStepHeader({
    required this.step,
    required this.totalSteps,
    required this.onSkip,
    this.onBack,
  });

  final int step;
  final int totalSteps;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / totalSteps;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: SizedBox(
        height: 56,
        child: Stack(
          children: [
            if (onBack != null)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  color: AppColors.iconMuted,
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 36),
                ),
              ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
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
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 108,
                    height: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 3,
                        backgroundColor: const Color(0xFFD2C4BE)
                            .withValues(alpha: 0.35),
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'STEP ${step + 1} OF $totalSteps',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
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

class _ContinueFooter extends StatelessWidget {
  const _ContinueFooter({
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_ios,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFD2C4BE).withValues(alpha: 0.35),
          ),
        ),
      ),
      child: GlowPrimaryButton(
        label: label,
        height: 52,
        icon: icon,
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
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: selected ? Colors.white : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFFD2C4BE),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFC5AF),
              ),
              child: Icon(item.icon, size: 20, color: const Color(0xFF7A4F3E)),
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 16 / 12,
                color: AppColors.textSecondary,
              ),
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
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.1),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF7E1D7),
              ),
              child: Icon(
                item.icon,
                size: 22,
                color: const Color(0xFF73635B),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              item.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                height: 24 / 16,
                color: AppColors.textSecondary,
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
        constraints: const BoxConstraints(minHeight: 220),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD2C4BE),
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFFFC4AF).withValues(alpha: 0.3),
                  ),
                  child: Icon(item.icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(height: 24),
                Text(
                  item.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 32 / 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              item.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                height: 24 / 16,
                color: const Color(0xFF4E4540),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpertGuidanceCard extends StatelessWidget {
  const _ExpertGuidanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFFCF9F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFFFCF9F8),
                  const Color(0xFFF8EEE8),
                  const Color(0xFFF0DFD4),
                  const Color(0xFFE5C9B5),
                ],
                stops: const [0, 0.32, 0.68, 1],
              ),
            ),
          ),
          Positioned(
            right: -90,
            top: -70,
            child: IgnorePointer(
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFD4A98A).withValues(alpha: 0.75),
                      const Color(0xFFE8CDB8).withValues(alpha: 0.35),
                      const Color(0xFFFCF9F8).withValues(alpha: 0),
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -110,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC99573).withValues(alpha: 0.65),
                      const Color(0xFFF5E2D9).withValues(alpha: 0.18),
                      const Color(0xFFFCF9F8).withValues(alpha: 0),
                    ],
                    stops: const [0, 0.5, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 48,
            top: 72,
            child: IgnorePointer(
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFB8896A).withValues(alpha: 0.4),
                      const Color(0xFFE8CDB8).withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFFFCF9F8),
                  const Color(0xFFFCF9F8).withValues(alpha: 0.4),
                  const Color(0xFFFCF9F8).withValues(alpha: 0),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EXPERT GUIDANCE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 24 / 16,
                    letterSpacing: 3.2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Not sure about your type?',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 32 / 24,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Perform the 'Wash and Wait' test: Cleanse your face with a gentle pH-balanced cleanser, wait 30 minutes without applying any products, and observe how your skin feels.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 24 / 16,
                    color: const Color(0xFF4E4540),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F2),
        borderRadius: BorderRadius.circular(12),
        border: enabled
            ? Border.all(color: AppColors.primary)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFEAE7E7),
            ),
            child: Icon(item.icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 28 / 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 16 / 12,
                    color: const Color(0xFF4E4540),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD2C4BE),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  const _FrequencyCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _TimeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFF6F3F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD2C4BE),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              size: 32,
              color: selected ? AppColors.primary : const Color(0xFF6B5B53),
            ),
            const SizedBox(height: 8),
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                letterSpacing: 0.7,
                color: selected ? AppColors.primary : const Color(0xFF4E4540),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplexityCard extends StatelessWidget {
  const _ComplexityCard({
    required this.title,
    required this.subtitle,
    required this.stepCount,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final int stepCount;
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
          color: selected ? Colors.white : const Color(0xFFF6F3F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD2C4BE),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: stepCount == 7 ? 43 : 48,
              height: 48,
              decoration: BoxDecoration(
                color: stepCount == 7 && selected
                    ? const Color(0xFFFFC4AF)
                    : const Color(0xFFF7E1D7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$stepCount',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFF6B5B53),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 20 / 14,
                      letterSpacing: 0.7,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 16 / 12,
                      color: const Color(0xFF4E4540),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFF807570),
                  width: selected ? 4 : 1,
                ),
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
