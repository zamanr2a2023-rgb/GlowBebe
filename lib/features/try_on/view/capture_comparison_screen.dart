import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class CaptureComparisonScreen extends StatefulWidget {
  const CaptureComparisonScreen({
    super.key,
    this.imagePath,
    this.beforePath,
    this.afterPath,
    this.mirror = false,
  });

  final String? imagePath;
  final String? beforePath;
  final String? afterPath;
  final bool mirror;

  @override
  State<CaptureComparisonScreen> createState() =>
      _CaptureComparisonScreenState();
}

class _CaptureComparisonScreenState extends State<CaptureComparisonScreen> {
  double _slider = 0.45;
  int _navIndex = 2;

  String? get _after {
    final path = widget.afterPath ?? widget.imagePath;
    if (path != null && File(path).existsSync()) return path;
    return null;
  }

  String? get _before {
    final path = widget.beforePath;
    if (path != null && File(path).existsSync()) return path;
    return null;
  }

  Widget _photo(String? path, {required String fallbackAsset}) {
    if (path != null) {
      Widget image = Image.file(File(path), fit: BoxFit.cover);
      if (widget.mirror) {
        image = Transform.flip(flipX: true, child: image);
      }
      return image;
    }
    return Image.asset(fallbackAsset, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopNav(
              onBack: () => Navigator.pop(context),
              onProfile: () => Navigator.pushNamed(context, RouteNames.makeupHub),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                children: [
                  Text(
                    'Transformation Complete',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      height: 32 / 24,
                      color: const Color(0xFF1C1B1B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Behold your AI-enhanced Lumière glow. Slide to see the magic happen.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 24 / 16,
                      color: const Color(0xFF4E4540),
                    ),
                  ),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final split = width * _slider;
                      return Column(
                        children: [
                          Container(
                            height: width * (466.66 / 350),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F3F2),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 50,
                                  offset: const Offset(0, 25),
                                  spreadRadius: -12,
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                setState(() {
                                  _slider =
                                      (_slider + details.delta.dx / width)
                                          .clamp(0.08, 0.92);
                                });
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Base = natural (before)
                                  if (_before != null)
                                    _photo(
                                      _before,
                                      fallbackAsset: AppAssets.lookNatural,
                                    )
                                  else
                                    ColorFiltered(
                                      colorFilter: const ColorFilter.matrix([
                                        0.45, 0.35, 0.15, 0, 12,
                                        0.45, 0.35, 0.15, 0, 12,
                                        0.45, 0.35, 0.15, 0, 12,
                                        0, 0, 0, 1, 0,
                                      ]),
                                      child: _photo(
                                        _after,
                                        fallbackAsset: AppAssets.lookNatural,
                                      ),
                                    ),
                                  // Glam clipped from the right (Figma after starts ~40%)
                                  Positioned(
                                    left: split,
                                    top: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: ClipRect(
                                      child: OverflowBox(
                                        alignment: Alignment.centerRight,
                                        maxWidth: width,
                                        child: SizedBox(
                                          width: width,
                                          child: _photo(
                                            _after,
                                            fallbackAsset: AppAssets.lookSoftGlam,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    left: 24,
                                    top: 24,
                                    child: _GlassChip(label: 'NATURAL'),
                                  ),
                                  const Positioned(
                                    right: 24,
                                    top: 24,
                                    child: _GlassChip(label: 'LUMIÈRE GLAM'),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 18,
                                    child: Center(
                                      child: _GlassChip(
                                        label: 'SLIDE TO COMPARE',
                                        large: true,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: split - 1,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    left: split - 20,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.15),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.code,
                                          size: 18,
                                          color: Color(0xFF805443),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'NO MAKEUP',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: const Color(0xFF4E4540),
                                ),
                              ),
                              Text(
                                'GLAM FILTER',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: const Color(0xFF805443),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.analysisResults,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF805443),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: 0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            'Save Look',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Share sheet coming soon'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE5E2E1),
                              foregroundColor: const Color(0xFF1C1B1B),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.ios_share, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Share',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              RouteNames.cameraMirror,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF805443),
                              side: const BorderSide(
                                color: Color(0xFF805443),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.refresh, size: 16),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Try Another Look',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'ENHANCED WITH AI PRECISION',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      color: const Color(0xFF4E4540),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      'Pore Refining',
                      'Luminance Boost',
                      'Soft Glam Palette',
                    ].map((t) => _TanChip(label: t)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GlowBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 2) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.makeupHub,
              (route) => false,
            );
          }
        },
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  const _TopNav({required this.onBack, required this.onProfile});

  final VoidCallback onBack;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F8).withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Text(
              'LUMIÈRE',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.4,
                color: const Color(0xFF805443),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onProfile,
            child: Container(
              width: 36,
              height: 36,
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
        ],
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.label, this.large = false});

  final String label;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 24 : 16,
        vertical: large ? 7.5 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: large ? 12 : 10,
          fontWeight: FontWeight.w400,
          letterSpacing: large ? 0 : 1,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TanChip extends StatelessWidget {
  const _TanChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E1D7),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF73635B),
        ),
      ),
    );
  }
}
