import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GlowPrimaryButton extends StatelessWidget {
  const GlowPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = true,
    this.height = 56,
    this.icon,
    this.iconLeading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final double height;
  final IconData? icon;
  final bool iconLeading;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && iconLeading) ...[
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: Colors.white,
              ),
            ),
            if (icon != null && !iconLeading) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: Colors.white),
            ],
          ],
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class GlowOutlinedButton extends StatelessWidget {
  const GlowOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = true,
    this.height = 52,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final double height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class GlowSerifTitle extends StatelessWidget {
  const GlowSerifTitle(
    this.text, {
    super.key,
    this.size = 24,
    this.color,
    this.letterSpacing = 0.5,
    this.align,
  });

  final String text;
  final double size;
  final Color? color;
  final double letterSpacing;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: FontWeight.w500,
        letterSpacing: letterSpacing,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      ),
    );
  }
}

class GlowBrandMark extends StatelessWidget {
  const GlowBrandMark({
    super.key,
    this.title = 'GlowBéBé',
    this.size = 28,
  });

  final String title;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: AppColors.primary,
      ),
    );
  }
}

class GlowField extends StatelessWidget {
  const GlowField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.hint,
    this.validator,
    this.labelTrailing,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? hint;
  final String? Function(String?)? validator;
  final Widget? labelTrailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                  color: AppColors.iconMuted,
                ),
              ),
            ),
            ?labelTrailing,
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: const Color(0xFFD2C4BE),
            ),
            filled: false,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.fromLTRB(24, 13, 24, 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF807570)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF807570)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class GlowSoftCard extends StatelessWidget {
  const GlowSoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.onTap,
    this.borderRadius = 16,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      ),
    );
  }
}

class GlowMetricBar extends StatelessWidget {
  const GlowMetricBar({
    super.key,
    required this.label,
    required this.value,
    this.max = 100,
    this.trailing,
  });

  final String label;
  final double value;
  final double max;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final ratio = (value / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              trailing ?? value.toInt().toString(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppColors.surfaceSoft,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class GlowScoreRing extends StatelessWidget {
  const GlowScoreRing({
    super.key,
    required this.score,
    this.max = 100,
    this.size = 140,
    this.label,
    this.subtitle,
    this.solidRing = false,
    this.ringStrokeWidth,
  });

  final int score;
  final int max;
  final double size;
  final String? label;
  final String? subtitle;
  final bool solidRing;
  final double? ringStrokeWidth;

  @override
  Widget build(BuildContext context) {
    final progress = (score / max).clamp(0.0, 1.0);
    final stroke = ringStrokeWidth ?? size * 0.085;
    final scoreSize = size * 0.36;
    final denomSize = size * 0.14;
    final labelSize = size * 0.075;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (solidRing)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: stroke,
                ),
              ),
            )
          else
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: stroke,
                backgroundColor: const Color(0xFFE8E2DF),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                strokeCap: StrokeCap.round,
              ),
            ),
          // Centered score block — Figma: 85 /100 · EXCELLENT
          Padding(
            padding: EdgeInsets.only(top: size * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$score',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: scoreSize,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '/$max',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: denomSize,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: AppColors.primary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                if (label != null) ...[
                  SizedBox(height: size * 0.045),
                  Text(
                    label!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: labelSize.clamp(12.0, 15.0),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      height: 1.0,
                      color: AppColors.primary,
                    ),
                  ),
                ],
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GlowChip extends StatelessWidget {
  const GlowChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderSoft,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : AppColors.iconMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlowImagePlaceholder extends StatelessWidget {
  const GlowImagePlaceholder({
    super.key,
    this.width,
    this.height = 160,
    this.borderRadius = 12,
    this.icon = Icons.face_retouching_natural,
    this.label,
    this.child,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final IconData icon;
  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.borderSoft),
      ),
      clipBehavior: Clip.antiAlias,
      child: child ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: AppColors.iconMuted),
              if (label != null) ...[
                const SizedBox(height: 8),
                Text(
                  label!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
    );
  }
}

class GlowStepHeader extends StatelessWidget {
  const GlowStepHeader({
    super.key,
    required this.step,
    required this.total,
    required this.title,
    this.subtitle,
  });

  final int step;
  final int total;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP $step OF $total',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: step / total,
          minHeight: 4,
          backgroundColor: AppColors.surfaceSoft,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          borderRadius: BorderRadius.circular(999),
        ),
        const SizedBox(height: 20),
        GlowSerifTitle(title, size: 26),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class GlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlowAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.brandStyle = false,
    this.centerTitle = true,
    this.titleColor,
    this.serifTitle = true,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final bool brandStyle;
  final bool centerTitle;
  final Color? titleColor;
  final bool serifTitle;

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
        style: serifTitle
            ? (brandStyle
                ? GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                    color: titleColor ?? AppColors.primary,
                  )
                : GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                    color: titleColor ?? AppColors.primary,
                  ))
            : GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: titleColor ?? AppColors.textWarm,
              ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      backgroundColor: AppColors.background.withValues(alpha: 0.92),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class GlowSectionHeader extends StatelessWidget {
  const GlowSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
