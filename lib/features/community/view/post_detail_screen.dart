import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  static const _comments = [
    ('Aisha Noor', 'This changed how I think about morning oils.'),
    ('Maya Chen', 'Saving for my cool winter edit — ceramides forever.'),
    ('Lena Park', 'Barrier care over trends. Beautifully written.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 260,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      AppAssets.lookSoftGlam,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.communityProfile,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  AssetImage(AppAssets.profileAvatar),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sophie Laurent',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Esthetician · Combination skin',
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
                      const SizedBox(height: 20),
                      const GlowSerifTitle(
                        'The Quiet Luxury of Barrier Care',
                        size: 28,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'In a culture obsessed with overnight miracles, the most luminous skin often comes from slower rituals — ceramides, gentle acids, and consistency.\n\n'
                        'Barrier care is not boring; it is the architecture that lets every other active work. When the lipid matrix is intact, makeup sits softer, redness quiets, and glow feels earned rather than forced.\n\n'
                        'Start with a milky cleanser, a ceramide serum, and a cream that seals — then wait. The glow always arrives.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          height: 1.65,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const GlowSerifTitle('Comments', size: 20),
                      const SizedBox(height: 12),
                      ..._comments.map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlowSoftCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.$1,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  c.$2,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    height: 1.45,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.borderSoft),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment…',
                        filled: true,
                        fillColor: AppColors.surfaceSoft,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
