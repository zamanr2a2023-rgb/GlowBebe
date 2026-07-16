import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinRegimenScreen extends StatefulWidget {
  const SkinRegimenScreen({super.key});

  @override
  State<SkinRegimenScreen> createState() => _SkinRegimenScreenState();
}

class _SkinRegimenScreenState extends State<SkinRegimenScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  static const _morning = [
    ('CLEANSE', 'Gentle foaming cleanser', '60 sec'),
    ('TREAT', 'Hydrating serum · HA + B5', 'Wait 60s'),
    ('PROTECT', 'Mineral SPF 50', 'Daily'),
  ];

  static const _night = [
    ('CLEANSE', 'Oil cleanser + foam', '90 sec'),
    ('TREAT', 'Niacinamide 10%', 'Wait 60s'),
    ('PROTECT', 'Barrier cream', 'Seal'),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Your Regimen'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: TabBar(
                controller: _tabs,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Morning'),
                  Tab(text: 'Night'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _RegimenBody(steps: _morning),
                _RegimenBody(steps: _night),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: GlowPrimaryButton(
                label: 'START ROUTINE',
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.routineSteps),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegimenBody extends StatelessWidget {
  const _RegimenBody({required this.steps});

  final List<(String, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      children: [
        ...steps.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlowSoftCard(
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePeach,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      s.$1 == 'CLEANSE'
                          ? Icons.water_drop_outlined
                          : s.$1 == 'TREAT'
                              ? Icons.science_outlined
                              : Icons.shield_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.$1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.$2,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    s.$3,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        const GlowSectionHeader(title: 'Matched For You'),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              const names = [
                'CeraVe Hydrating Cleanser',
                'The Ordinary Niacinamide',
                'La Roche-Posay SPF',
              ];
              return SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlowImagePlaceholder(
                      height: 110,
                      icon: Icons.spa_outlined,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      names[i],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
