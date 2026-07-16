import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool _yearly = false;
  int _selected = 2;

  List<_Plan> get _plans => [
        _Plan(
          name: 'Essential',
          monthly: 9,
          yearly: 79,
          perks: ['Basic glow score', '3 product scans / mo', 'Community access'],
        ),
        _Plan(
          name: 'Premium',
          monthly: 19,
          yearly: 169,
          perks: [
            'Unlimited scans',
            'Shade-matched shop',
            'Weekly AI coach tips',
          ],
        ),
        _Plan(
          name: 'Platinum',
          monthly: 29,
          yearly: 249,
          perks: [
            'Everything in Premium',
            'Priority consultations',
            'Exclusive editorial drops',
          ],
          highlight: true,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Membership'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const GlowSerifTitle('Choose your glow path', size: 26),
          const SizedBox(height: 8),
          Text(
            'Unlock deeper analysis, scans, and editorial perks.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              children: [
                _BillingTab(
                  label: 'Monthly',
                  selected: !_yearly,
                  onTap: () => setState(() => _yearly = false),
                ),
                _BillingTab(
                  label: 'Yearly',
                  selected: _yearly,
                  onTap: () => setState(() => _yearly = true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(_plans.length, (i) {
            final plan = _plans[i];
            final price = _yearly ? plan.yearly : plan.monthly;
            final selected = _selected == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: plan.highlight
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.borderSoft,
                      width: selected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: plan.highlight
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$$price',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: plan.highlight
                                  ? Colors.white
                                  : AppColors.primary,
                            ),
                          ),
                          Text(
                            _yearly ? '/yr' : '/mo',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: plan.highlight
                                  ? Colors.white70
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...plan.perks.map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: plan.highlight
                                    ? Colors.white70
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  p,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: plan.highlight
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          GlowPrimaryButton(
            label: 'Continue with ${_plans[_selected].name}',
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
    );
  }
}

class _Plan {
  const _Plan({
    required this.name,
    required this.monthly,
    required this.yearly,
    required this.perks,
    this.highlight = false,
  });

  final String name;
  final int monthly;
  final int yearly;
  final List<String> perks;
  final bool highlight;
}

class _BillingTab extends StatelessWidget {
  const _BillingTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(99),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
