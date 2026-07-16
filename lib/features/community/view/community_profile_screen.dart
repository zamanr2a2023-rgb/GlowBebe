import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityProfileScreen extends StatelessWidget {
  const CommunityProfileScreen({super.key});

  static const _posts = [
    AppAssets.lookSoftGlam,
    AppAssets.lookNatural,
    AppAssets.lookParty,
    AppAssets.lookOffice,
    AppAssets.productBakuchiol,
    AppAssets.productExtra1,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfacePeach, width: 3),
                    image: const DecorationImage(
                      image: AssetImage(AppAssets.profileAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const GlowSerifTitle('Sophie Laurent', size: 28),
                const SizedBox(height: 4),
                Text(
                  'Paris · Esthetician & Writer',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Stat('12.4k', 'Followers'),
                    const SizedBox(width: 28),
                    _Stat('186', 'Posts'),
                    const SizedBox(width: 28),
                    _Stat('842', 'Following'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlowSoftCard(
            color: AppColors.surfacePeach.withValues(alpha: 0.45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKIN SUMMARY',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Combination · Cool undertone · Barrier-focused',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Loves ceramides, bakuchiol, and soft glam for cool winters.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GlowOutlinedButton(
                  label: 'Follow',
                  height: 48,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlowPrimaryButton(
                  label: 'Message',
                  height: 48,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const GlowSerifTitle('Posts', size: 20),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _posts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.postDetail),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(_posts[i], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
