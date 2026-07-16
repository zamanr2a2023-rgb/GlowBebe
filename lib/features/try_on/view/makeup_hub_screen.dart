import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/constants/app_strings.dart';
import 'package:glowbebe/features/profile/view/profile_screen.dart';
import 'package:glowbebe/features/try_on/model/try_on_models.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class MakeupHubScreen extends StatefulWidget {
  const MakeupHubScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<MakeupHubScreen> createState() => _MakeupHubScreenState();
}

class _MakeupHubScreenState extends State<MakeupHubScreen> {
  // Makeup tab is index 2 in Figma nav
  int _tabIndex = 2;

  void _onNavTap(int index) {
    if (index == 2) {
      setState(() => _tabIndex = index);
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      RouteNames.mainShell,
      arguments: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 72)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _HeroCard(
                      onLaunch: () => Navigator.pushNamed(
                        context,
                        RouteNames.cameraMirror,
                      ),
                    ),
                    const SizedBox(height: 30),
                    QuickActionTile(
                      title: AppStrings.shadeMatch,
                      subtitle: AppStrings.shadeMatchDesc,
                      icon: Icons.face_retouching_natural,
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.colorShadeMatch,
                      ),
                    ),
                    const SizedBox(height: 24),
                    QuickActionTile(
                      title: AppStrings.seasonalPalette,
                      subtitle: AppStrings.seasonalPaletteDesc,
                      icon: Icons.palette,
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.analysisResults,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Try a Look',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'View All',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 376,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: TryOnMockData.featuredLooks.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 24),
                        itemBuilder: (context, index) {
                          final look = TryOnMockData.featuredLooks[index];
                          return LookCard(
                            look: look,
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteNames.customizeLook,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Recommended For You',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 500,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: TryOnMockData.recommendedProducts.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 24),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: TryOnMockData.recommendedProducts[index],
                            onAdd: () {},
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          // Top app bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: AppColors.background.withValues(alpha: 0.8),
                  child: SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: 64,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              'Makeup',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.8,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                RouteNames.shadeMatchedShop,
                              ),
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                color: AppColors.iconMuted,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfileScreen(),
                                ),
                              ),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFD2C4BE),
                                  ),
                                  color: AppColors.surfacePeach,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  AppAssets.lookNatural,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.embedded
          ? null
          : GlowBottomNav(
              currentIndex: _tabIndex,
              onTap: _onNavTap,
            ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onLaunch});

  final VoidCallback onLaunch;

  static const _radius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(_radius),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 500,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.heroAr,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: Colors.brown),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'LIVE EXPERIENCE',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                letterSpacing: 2.4,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'AR Makeup\nTry-On',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: -1.2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Instantly visualize our full seasonal collection in real-time with 99.9% accuracy.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          height: 1.6,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: onLaunch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 8,
                            shadowColor: Colors.black26,
                            shape: const StadiumBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.videocam_outlined, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'LAUNCH CAMERA',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  letterSpacing: 1.6,
                                  color: AppColors.primary,
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
            ),
          ],
        ),
      ),
    );
  }
}
