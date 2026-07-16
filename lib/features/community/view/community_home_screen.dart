import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen> {
  int _chip = 0;
  static const _chips = ['For You', 'Skincare', 'Makeup', 'Routines', 'Reviews'];

  static const _posts = [
    (
      'Sophie Laurent',
      'The Quiet Luxury of Barrier Care',
      'Why ceramides and patience outperform overnight miracles.',
      AppAssets.lookSoftGlam,
      '128',
      '42',
    ),
    (
      'Maya Chen',
      'My Cool Winter Lip Edit',
      'Five soft stains that flatter cool undertones without drying.',
      AppAssets.lookParty,
      '96',
      '31',
    ),
    (
      'Elena Rossi',
      'Morning Glow Protocol',
      'A 6-minute ritual that still feels editorial.',
      AppAssets.lookNatural,
      '214',
      '67',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, RouteNames.createPost),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit_outlined, color: Colors.white),
        label: Text(
          'Create',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GLOW ESSENCE',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.4,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const GlowSerifTitle('Community', size: 28),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.communityProfile,
                      ),
                      icon: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(AppAssets.profileAvatar),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: _chips.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) => GlowChip(
                  label: _chips[i],
                  selected: _chip == i,
                  onTap: () => setState(() => _chip = i),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, widget.embedded ? 110 : 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final p = _posts[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlowSoftCard(
                      padding: EdgeInsets.zero,
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.postDetail),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              p.$4,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.$1.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.4,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  p.$2,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  p.$3,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    height: 1.45,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite_border,
                                      size: 18,
                                      color: AppColors.iconMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      p.$5,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.chat_bubble_outline,
                                      size: 17,
                                      color: AppColors.iconMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      p.$6,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _posts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
