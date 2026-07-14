import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorShadeMatchScreen extends StatelessWidget {
  const ColorShadeMatchScreen({super.key});

  static const _palette = <Color>[
    Color(0xFF5D1A2F),
    Color(0xFF8E4057),
    Color(0xFF2F1B41),
    Color(0xFF1E2A4F),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: TryOnAppBar(
        title: 'GLOW ANALYSIS',
        brandStyle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, RouteNames.makeupHub),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE5E2E1),
                  border: Border.all(color: const Color(0xFFD2C4BE)),
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.lookSoftGlam),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // Hero
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 50,
                  offset: const Offset(0, 25),
                  spreadRadius: -12,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppAssets.lookNatural,
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0x66FCF9F8),
                        Color(0x00FCF9F8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Perfect\nMatch',
            style: GoogleFonts.playfairDisplay(
              fontSize: 48,
              fontWeight: FontWeight.w600,
              height: 56 / 48,
              letterSpacing: -0.96,
              color: const Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Based on our AI skin analysis and your Cool Winter profile, we've identified the high-performance formulas that sync perfectly with your unique undertones.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              height: 29 / 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4E4540),
            ),
          ),
          const SizedBox(height: 28),
          const _ShadeMatchCard(
            label: 'FOUNDATION',
            shadeName: 'Shade TN2',
            detail: 'Neutral True Tone • Satin Finish',
            swatch: Color(0xFFEBC3A8),
          ),
          const SizedBox(height: 12),
          const _ShadeMatchCard(
            label: 'CONCEALER',
            shadeName: 'Shade C1',
            detail: 'Brightening Peach • Creamy Cover',
            swatch: Color(0xFFF0D5C8),
          ),
          const SizedBox(height: 32),

          // Profile diagnosis / palette
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: const Color(0xFFD2C4BE).withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'PROFILE DIAGNOSIS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: const Color(0xFF6B5B53),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cool Winter Palette',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 40 / 32,
                    color: const Color(0xFF1C1B1B),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _palette
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          Text(
            'Recommended Colors',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 40 / 32,
              color: const Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Curated pigments designed to contrast elegantly with your cool undertones and enhance your natural vibrancy.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 24 / 16,
              color: const Color(0xFF4E4540),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ProductRecCard(
                  image: AppAssets.productExtra1,
                  badge: 'Best Seller',
                  category: 'LIP COLOR',
                  title: 'Berry Bliss',
                  subtitle: 'Cool Berry Satin',
                  swatch: const Color(0xFF72243D),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProductRecCard(
                  image: AppAssets.productExtra2,
                  category: 'BLUSH',
                  title: 'Soft Mauve',
                  subtitle: 'Petal Pink Velvet',
                  swatch: const Color(0xFFB07A8C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ProductRecCard(
            image: AppAssets.productExtra3,
            category: 'EYESHADOW',
            title: 'Deep Plum',
            subtitle: 'Smoky Amethyst',
            swatch: const Color(0xFF4A2C4D),
            wide: true,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.cameraMirror),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF805443),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Try-On',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShadeMatchCard extends StatelessWidget {
  const _ShadeMatchCard({
    required this.label,
    required this.shadeName,
    required this.detail,
    required this.swatch,
  });

  final String label;
  final String shadeName;
  final String detail;
  final Color swatch;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2C4BE)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: swatch,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: const Color(0xFF805443),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  shadeName,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 32 / 24,
                    color: const Color(0xFF1C1B1B),
                  ),
                ),
                Text(
                  detail,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 16 / 12,
                    color: const Color(0xFF4E4540),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductRecCard extends StatelessWidget {
  const _ProductRecCard({
    required this.image,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.swatch,
    this.badge,
    this.wide = false,
  });

  final String image;
  final String category;
  final String title;
  final String subtitle;
  final Color swatch;
  final String? badge;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: wide ? 2.1 : 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: Color(0xFFF6F3F2),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        badge!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 8,
                          color: const Color(0xFF1C1B1B),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8,
                      color: const Color(0xFF805443),
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      height: 24 / 16,
                      color: const Color(0xFF1C1B1B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: const Color(0xFF4E4540),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: swatch,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD2C4BE)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
