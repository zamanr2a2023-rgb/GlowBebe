import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/constants/app_text_styles.dart';
import 'package:glowbebe/features/try_on/model/try_on_models.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 12,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class TryOnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TryOnAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.brandStyle = false,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final bool brandStyle;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              color: AppColors.iconMuted,
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      title: Text(
        title,
        style: brandStyle
            ? GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.4,
                color: AppColors.primary,
              )
            : GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                color: AppColors.primary,
              ),
      ),
      centerTitle: true,
      actions: actions,
      backgroundColor: AppColors.background.withValues(alpha: 0.8),
    );
  }
}

class GlowBottomNav extends StatelessWidget {
  const GlowBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  // Figma: Home, Skin, Makeup, Shop, Community, Me
  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.face_outlined, Icons.face, 'Skin'),
    (Icons.brush_outlined, Icons.brush, 'Makeup'),
    (Icons.shopping_bag_outlined, Icons.shopping_bag, 'Shop'),
    (Icons.people_outline, Icons.people, 'Community'),
    (Icons.person_outline, Icons.person, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    const topRadius = BorderRadius.vertical(top: Radius.circular(40));

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: topRadius,
          border: Border(
            top: BorderSide(color: AppColors.borderSoft),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final selected = currentIndex == index;
                final color =
                    selected ? AppColors.primary : AppColors.textTertiary;
                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected ? item.$2 : item.$1,
                          size: 20,
                          color: color,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.$3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: selected ? 12 : 10,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            letterSpacing: selected ? 0.5 : 0,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD2C4BE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfacePeach,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.iconMuted, size: 22),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  letterSpacing: 0.8,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  height: 1.5,
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

class LookCard extends StatelessWidget {
  const LookCard({
    super.key,
    required this.look,
    this.onTap,
  });

  final LookItem look;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 256,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 320,
              width: 256,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      look.image,
                      width: 256,
                      height: 320,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.surfaceSoft,
                        child: const Icon(Icons.face),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Try',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              look.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              look.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.compact = false,
    this.onAdd,
  });

  final ProductItem product;
  final bool compact;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    // Figma product cards are ~259–288 wide; use 288 so price + CTA fit.
    final cardWidth = compact ? null : 288.0;
    final imageHeight = compact ? 160.0 : 346.0;

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: compact ? double.infinity : cardWidth,
                  height: imageHeight,
                  color: const Color(0xFFF0EDED),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                    width: compact ? double.infinity : cardWidth,
                    height: imageHeight,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.spa_outlined),
                    ),
                  ),
                ),
              ),
              if (product.matchPercent != null)
                Positioned(
                  left: 16,
                  top: 16,
                  child: _Badge(label: product.matchPercent!),
                ),
              if (product.discountLabel != null)
                Positioned(
                  right: 16,
                  top: 16,
                  child: _Badge(label: product.discountLabel!, bold: true),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.playfairDisplay(
              fontSize: compact ? 18 : 24,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (product.oldPrice != null) ...[
                      Flexible(
                        child: Text(
                          product.oldPrice!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      product.price,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_bag_outlined,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'Add to Bag',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.bold = false});

  final String label;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: bold ? 8 : 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: bold ? 10 : 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          letterSpacing: bold ? 1 : 0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ShadeChip extends StatelessWidget {
  const ShadeChip({
    super.key,
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
    this.isClear = false,
  });

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final bool isClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isClear ? Colors.transparent : color,
              border: Border.all(
                color: isClear
                    ? const Color(0xFFD2C4BE)
                    : selected
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.5),
                width: selected ? 3 : (isClear ? 2 : 1),
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 0,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isClear
                ? const Icon(Icons.block, color: Color(0xFFD2C4BE), size: 20)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              letterSpacing: -0.6,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryPillButton extends StatelessWidget {
  const PrimaryPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: filled ? 1.2 : 0.5,
          ),
        ),
      ],
    );

    if (filled) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: child,
      ),
    );
  }
}

class NetworkOrAssetImage extends StatelessWidget {
  const NetworkOrAssetImage({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
  });

  final String asset;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => Container(
        color: const Color(0xFF3A2A24),
        child: Icon(
          Icons.face_retouching_natural,
          size: 64,
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class OvalFaceGuide extends StatelessWidget {
  const OvalFaceGuide({
    super.key,
    this.faceDetected = false,
  });

  final bool faceDetected;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OvalGuidePainter(faceDetected: faceDetected),
      child: const SizedBox.expand(),
    );
  }
}

class _OvalGuidePainter extends CustomPainter {
  _OvalGuidePainter({required this.faceDetected});

  final bool faceDetected;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = faceDetected
          ? const Color(0xFF4ADE80).withValues(alpha: 0.9)
          : Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = faceDetected ? 2.5 : 2;

    final cx = size.width / 2;
    final cy = size.height * 0.42;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: size.width * 0.58,
        height: size.height * 0.48,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _OvalGuidePainter oldDelegate) =>
      oldDelegate.faceDetected != faceDetected;
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    this.onClose,
    this.onShare,
    this.title = 'LUMIÈRE BEAUTÉ',
  });

  final VoidCallback? onClose;
  final VoidCallback? onShare;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Row(
          children: [
            _CircleIconButton(
              icon: Icons.close,
              onTap: onClose ?? () => Navigator.maybePop(context),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.4,
                  color: AppColors.primary,
                ),
              ),
            ),
            _CircleIconButton(
              icon: Icons.ios_share,
              onTap: onShare ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: AppColors.background.withValues(alpha: 0.7),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}

// Keep for backward compat with older screens
class PlaceholderFaceCanvas extends StatelessWidget {
  const PlaceholderFaceCanvas({
    super.key,
    this.label = 'Virtual Mirror',
    this.showOverlay = true,
    this.tint,
    this.asset,
  });

  final String label;
  final bool showOverlay;
  final Color? tint;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (asset != null)
          Image.asset(asset!, fit: BoxFit.cover)
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2A2220),
                  tint ?? const Color(0xFF4A3530),
                  const Color(0xFF1A1412),
                ],
              ),
            ),
          ),
        if (showOverlay && asset == null)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.face_retouching_natural,
                  size: 72,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
