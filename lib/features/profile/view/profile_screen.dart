import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  bool _pushNotifications = true;
  bool _emailTips = false;

  static const _shelf = [
    AppAssets.productBakuchiol,
    AppAssets.productExtra1,
    AppAssets.productExtra2,
    AppAssets.productExtra3,
    AppAssets.lookSoftGlam,
    AppAssets.lookNatural,
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
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
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                child: Row(
                  children: [
                    const Expanded(
                      child: GlowSerifTitle('Profile', size: 28),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.editProfile,
                      ),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteNames.settings),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surfacePeach,
                            width: 3,
                          ),
                          image: const DecorationImage(
                            image: AssetImage(AppAssets.profileAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const GlowSerifTitle('Elena Rossi', size: 24),
                            const SizedBox(height: 4),
                            Text(
                              'Combination · Cool undertone',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  '2.8k',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  ' followers  ·  ',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                Text(
                                  '186',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  ' following',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: const [
                      GlowChip(label: 'Glow Explorer', selected: true),
                      GlowChip(label: 'Scan Streak 12'),
                      GlowChip(label: 'Barrier Boss'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GlowSoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Glow Score',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const GlowMetricBar(label: 'Overall', value: 85),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlowSoftCard(
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Push notifications',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: _pushNotifications,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) =>
                              setState(() => _pushNotifications = v),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Email tips',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: _emailTips,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) => setState(() => _emailTips = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.membership),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF805443), Color(0xFFA67B68)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MEMBERSHIP',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.6,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Platinum',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Unlimited scans · Priority consults',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.diamond_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _QuickLink(
                        icon: Icons.face_retouching_natural,
                        label: 'Skin',
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.skinHealth,
                        ),
                      ),
                      _QuickLink(
                        icon: Icons.chat_bubble_outline,
                        label: 'Consultations',
                        onTap: () {},
                      ),
                      _QuickLink(
                        icon: Icons.brush_outlined,
                        label: 'Makeup',
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.makeupHub,
                        ),
                      ),
                      _QuickLink(
                        icon: Icons.receipt_long_outlined,
                        label: 'Orders',
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.orderHistory,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GlowPrimaryButton(
                    label: 'Start to check product',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.barcodeScanner,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabs,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textTertiary,
                indicatorColor: AppColors.primary,
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'My Shelf'),
                  Tab(text: 'Order History'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            GridView.builder(
              padding: EdgeInsets.fromLTRB(20, 16, 20, widget.embedded ? 100 : 32),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(_shelf[i], fit: BoxFit.cover),
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.fromLTRB(20, 16, 20, widget.embedded ? 100 : 32),
              itemCount: _shelf.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(_shelf[i], fit: BoxFit.cover),
              ),
            ),
            ListView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, widget.embedded ? 100 : 32),
              children: [
                GlowSoftCard(
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.orderHistory),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'View full order history',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Track deliveries & reorder',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GlowOutlinedButton(
                  label: 'Logout',
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.login,
                    (_) => false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceSoft,
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: AppColors.background, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
