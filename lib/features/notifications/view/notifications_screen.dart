import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _onNavTap(BuildContext context, int index) {
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
      appBar: GlowAppBar(
        title: 'Notifications',
        serifTitle: false,
        titleColor: AppColors.textWarm,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          const _GroupHeader('TODAY'),
          const SizedBox(height: 12),
          _NotifTile(
            icon: Icons.wb_sunny_outlined,
            title: 'Routine Reminder',
            body: 'Time for your morning glow routine!',
            time: '8:00 AM',
            unread: true,
            onTap: () =>
                Navigator.pushNamed(context, RouteNames.todaysRoutine),
          ),
          _NotifTile(
            icon: Icons.local_shipping_outlined,
            title: 'Order Update',
            body: 'Your Glow Serum has shipped — track delivery in Shop.',
            time: '10:30 AM',
            unread: true,
            onTap: () =>
                Navigator.pushNamed(context, RouteNames.orderStatus),
          ),
          const SizedBox(height: 24),
          const _GroupHeader('YESTERDAY'),
          const SizedBox(height: 12),
          _NotifTile(
            icon: Icons.face_retouching_natural,
            title: 'Skin Analysis',
            body: 'Your weekly scan results are ready to review.',
            time: '2:15 PM',
            unread: false,
            onTap: () =>
                Navigator.pushNamed(context, RouteNames.skinEvolution),
          ),
          _NotifTile(
            icon: Icons.sell_outlined,
            title: 'Offer Alert',
            body: '20% off curated serums matched to your glow profile.',
            time: '11:00 AM',
            unread: false,
            onTap: () =>
                Navigator.pushNamed(context, RouteNames.recommendations),
          ),
        ],
      ),
      bottomNavigationBar: GlowBottomNav(
        currentIndex: 0,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
        color: AppColors.textTertiary,
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlowSoftCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        color: AppColors.surfaceSoft,
        borderRadius: 12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.surfacePeach,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: AppColors.textWarm),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textWarm,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
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
