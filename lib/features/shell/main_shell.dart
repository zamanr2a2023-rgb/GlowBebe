import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/features/community/view/community_home_screen.dart';
import 'package:glowbebe/features/home/view/home_screen.dart';
import 'package:glowbebe/features/profile/view/profile_screen.dart';
import 'package:glowbebe/features/shop/view/shop_home_screen.dart';
import 'package:glowbebe/features/skin/view/skin_health_screen.dart';
import 'package:glowbebe/features/try_on/view/makeup_hub_screen.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';

/// Root tab shell matching Figma bottom nav:
/// Home · Skin · Makeup · Shop · Community · Me
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(embedded: true),
          SkinHealthScreen(embedded: true),
          MakeupHubScreen(embedded: true),
          ShopHomeScreen(embedded: true),
          CommunityHomeScreen(embedded: true),
          ProfileScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: GlowBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
