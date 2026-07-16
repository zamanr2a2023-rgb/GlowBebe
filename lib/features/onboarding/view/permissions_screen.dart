import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/auth/widgets/auth_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  Future<void> _allowAll(BuildContext context) async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.notification,
    ].request();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  void _later(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthAtmosphere(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      color: AppColors.iconMuted,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _later(context),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                          color: AppColors.iconMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    children: [
                      Text(
                        'Enable Permissions',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'To provide the best experience, we need access to your camera and gallery for skin analysis and try-ons.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          height: 1.55,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _PermissionCard(
                        icon: Icons.camera_alt_outlined,
                        title: 'Camera',
                        subtitle: 'Real-time skin analysis',
                      ),
                      const SizedBox(height: 12),
                      const _PermissionCard(
                        icon: Icons.photo_library_outlined,
                        title: 'Gallery',
                        subtitle: 'Upload skin history',
                      ),
                      const SizedBox(height: 12),
                      const _PermissionCard(
                        icon: Icons.notifications_none_outlined,
                        title: 'Alerts',
                        subtitle: 'Routine reminders',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  children: [
                    GlowPrimaryButton(
                      label: 'Allow All',
                      height: 52,
                      onPressed: () => _allowAll(context),
                    ),
                    const SizedBox(height: 12),
                    GlowOutlinedButton(
                      label: 'Maybe Later',
                      height: 52,
                      onPressed: () => _later(context),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'HIPAA COMPLIANT DATA STORAGE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.iconMuted.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfacePeach.withValues(alpha: 0.65),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
