import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultHistoryScreen extends StatelessWidget {
  const ConsultHistoryScreen({super.key});

  static const _items = [
    ('Dark spots strategy', 'Jul 16 · 12 min', 'Completed'),
    ('Barrier repair check-in', 'Jul 2 · 8 min', 'Completed'),
    ('Acne flare guidance', 'Jun 18 · 15 min', 'Completed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'Consult History',
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.consultStart),
            icon: const Icon(Icons.add, color: AppColors.iconMuted),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text(
            'Past sessions with your AI skin coach.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlowSoftCard(
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.consultSummary),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePeach,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$1,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.$2,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.$3,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlowPrimaryButton(
            label: 'NEW CONSULTATION',
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.consultConcerns),
          ),
        ],
      ),
    );
  }
}
