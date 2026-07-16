import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Soft peach radial blobs used across auth screens (auth.md atmospheric layers).
class AuthAtmosphere extends StatelessWidget {
  const AuthAtmosphere({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -40,
          top: -40,
          child: _Blob(
            size: 300,
            color: const Color(0xFFD7C2B9).withValues(alpha: 0.2),
          ),
        ),
        Positioned(
          right: -20,
          bottom: 40,
          child: _Blob(
            size: 280,
            color: const Color(0xFFF7E1D7).withValues(alpha: 0.35),
          ),
        ),
        Positioned(
          right: -60,
          top: -80,
          child: _Blob(
            size: 220,
            color: const Color(0xFFFFC4AF).withValues(alpha: 0.18),
          ),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class AuthLuminousHeader extends StatelessWidget {
  const AuthLuminousHeader({
    super.key,
    this.title = 'Luminous',
    this.showBack = false,
    this.onBack,
    this.trailing,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 0),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            if (showBack)
              IconButton(
                onPressed: onBack ?? () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                color: AppColors.iconMuted,
              )
            else
              const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
            trailing ?? const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key, this.label = 'OR LOGIN WITH'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }
}

class AuthSocialRow extends StatelessWidget {
  const AuthSocialRow({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialCircle(label: 'G', onTap: onTap),
        const SizedBox(width: 16),
        _SocialCircle(icon: Icons.facebook, onTap: onTap),
        const SizedBox(width: 16),
        _SocialCircle(icon: Icons.apple, onTap: onTap),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({this.icon, this.label, this.onTap});

  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.18),
          ),
        ),
        alignment: Alignment.center,
        child: label != null
            ? Text(
                label!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              )
            : Icon(icon, color: AppColors.primary, size: 26),
      ),
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prefix,
    required this.action,
    required this.onTap,
  });

  final String prefix;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefix,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.textTertiary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
