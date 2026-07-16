import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared hero frame for AI Skin Analysis + Virtual Try-On (Figma 350×420).
const double _kHeroAspect = 350 / 420;
const double _kHeroRadius = 20;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  void _goPermissions() {
    Navigator.pushReplacementNamed(context, RouteNames.permissions);
  }

  void _next() {
    if (_page < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goPermissions();
    }
  }

  void _back() {
    if (_page > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _page == 0 ? null : _back,
                    icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                    color: _page == 0
                        ? AppColors.textTertiary.withValues(alpha: 0.3)
                        : AppColors.iconMuted,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _goPermissions,
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
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  _SkinAnalysisPage(),
                  _VirtualTryOnPage(),
                  _SmartRecommendationsPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                children: [
                  GlowPrimaryButton(
                    label: _page == 2 ? 'Get Started' : 'Next',
                    height: 56,
                    onPressed: _next,
                  ),
                  const SizedBox(height: 18),
                  // Page dots below CTA (Figma)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final active = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 12 : 8,
                        height: active ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? const Color(0xFF805443)
                              : const Color(0xFFD2C4BE),
                        ),
                      );
                    }),
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

/// Page 1 — matches Figma / auth.md Onboarding: AI Analysis
class _SkinAnalysisPage extends StatefulWidget {
  const _SkinAnalysisPage();

  @override
  State<_SkinAnalysisPage> createState() => _SkinAnalysisPageState();
}

class _SkinAnalysisPageState extends State<_SkinAnalysisPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan;

  @override
  void initState() {
    super.initState();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        children: [
          // Hero: shared size with Virtual Try-On
          AspectRatio(
            aspectRatio: _kHeroAspect,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_kHeroRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAssets.aiSkin,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    alignment: const Alignment(0, -0.1),
                  ),
                  // Soft brown radial overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.85,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Mesh grid faint
                  CustomPaint(painter: _MeshGridPainter()),
                  // Scan line: first (top) → last (bottom), looping
                  AnimatedBuilder(
                    animation: _scan,
                    builder: (context, _) {
                      return Align(
                        alignment: Alignment(0, -1 + 2 * _scan.value),
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0),
                                AppColors.primary,
                                AppColors.primary.withValues(alpha: 0),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.45),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'AI Skin Analysis',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get a personalized skincare routine based on your unique skin profile.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PRODUCT RECOMMENDATIONS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _ProductCard(
                  image: AppAssets.productExtra1,
                  name: 'Glow Serum C',
                  rating: '4.9',
                  reviews: '128',
                ),
                _ProductCard(
                  image: AppAssets.productBakuchiol,
                  name: 'Pure Cleanser',
                  rating: '4.8',
                  reviews: '94',
                ),
                _ProductCard(
                  image: AppAssets.productExtra2,
                  name: 'Night Cream',
                  rating: '4.7',
                  reviews: '76',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeshGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const cols = 8;
    const rows = 10;
    for (var i = 1; i < cols; i++) {
      final x = size.width * i / cols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var j = 1; j < rows; j++) {
      final y = size.height * j / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final dots = Paint()..color = Colors.white.withValues(alpha: 0.85);
    final points = [
      Offset(size.width * 0.35, size.height * 0.32),
      Offset(size.width * 0.5, size.height * 0.28),
      Offset(size.width * 0.65, size.height * 0.32),
      Offset(size.width * 0.38, size.height * 0.48),
      Offset(size.width * 0.62, size.height * 0.48),
      Offset(size.width * 0.5, size.height * 0.58),
    ];
    for (final p in points) {
      canvas.drawCircle(p, 3.2, dots);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.image,
    required this.name,
    required this.rating,
    required this.reviews,
  });

  final String image;
  final String name;
  final String rating;
  final String reviews;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD2C4BE).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColoredBox(
              color: AppColors.surfaceSoft,
              child: Image.asset(
                image,
                width: 114,
                height: 114,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 12, color: Color(0xFFC9A227)),
              const SizedBox(width: 4),
              Text(
                '$rating ($reviews)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VirtualTryOnPage extends StatefulWidget {
  const _VirtualTryOnPage();

  @override
  State<_VirtualTryOnPage> createState() => _VirtualTryOnPageState();
}

class _VirtualTryOnPageState extends State<_VirtualTryOnPage>
    with TickerProviderStateMixin {
  late final AnimationController _scan;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scan.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        children: [
          // Hero + floating wand FAB (half outside image edge)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: AspectRatio(
              aspectRatio: _kHeroAspect,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_kHeroRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            AppAssets.tryOnHero,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            alignment: const Alignment(0, 0.05),
                          ),
                          AnimatedBuilder(
                            animation: Listenable.merge([_scan, _pulse]),
                            builder: (context, _) {
                              final breathe = 1.0 + (_pulse.value * 0.04);
                              final opacity = 0.45 + (_pulse.value * 0.45);
                              return Opacity(
                                opacity: opacity,
                                child: Transform.scale(
                                  scale: breathe,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Positioned(
                                        top: 70,
                                        left: 48,
                                        child: _CornerBracket(topLeft: true),
                                      ),
                                      Positioned(
                                        top: 70,
                                        right: 48,
                                        child: _CornerBracket(topRight: true),
                                      ),
                                      Positioned(
                                        bottom: 100,
                                        left: 48,
                                        child: _CornerBracket(bottomLeft: true),
                                      ),
                                      Positioned(
                                        bottom: 100,
                                        right: 48,
                                        child:
                                            _CornerBracket(bottomRight: true),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Same scan liner as AI Skin Analysis
                          AnimatedBuilder(
                            animation: _scan,
                            builder: (context, _) {
                              return Align(
                                alignment: Alignment(0, -1 + 2 * _scan.value),
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withValues(alpha: 0),
                                        AppColors.primary,
                                        AppColors.primary.withValues(alpha: 0),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.45),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Radiant Matte card
                          Positioned(
                            left: 12,
                            bottom: 16,
                            child: AnimatedBuilder(
                              animation: _pulse,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, -_pulse.value * 8),
                                  child: child,
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 8, 14, 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.88),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFD2C4BE)
                                        .withValues(alpha: 0.3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        AppAssets.lipstickThumb,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Radiant Matte',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        AnimatedBuilder(
                                          animation: _scan,
                                          builder: (context, _) {
                                            final dots = '.' *
                                                ((_scan.value * 3).floor() %
                                                        3 +
                                                    1);
                                            return Text(
                                              'Applying$dots',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontSize: 12,
                                                color: const Color(0xFF805443),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // White circular wand FAB — sits on image corner edge
                  Positioned(
                    top: -6,
                    right: -10,
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -_pulse.value * 5),
                          child: child,
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.92),
                            border: Border.all(
                              color: const Color(0xFFD2C4BE)
                                  .withValues(alpha: 0.35),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            AppAssets.wandIcon,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            color: const Color(0xFF6B5B53),
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'AUGMENTED REALITY',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: const Color(0xFF805443),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Virtual Try-On',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 34 / 28,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Experiment with thousands of shades and products instantly from home.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 28 / 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Product preview — photos.png strip (auto-scrolling)
          const _MovingPhotosStrip(),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF805443).withValues(alpha: 0.55);
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _BracketPainter(
          color: color,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  _BracketPainter({
    required this.color,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (topLeft) {
      canvas.drawLine(Offset.zero, Offset(size.width, 0), p);
      canvas.drawLine(Offset.zero, Offset(0, size.height), p);
    }
    if (topRight) {
      canvas.drawLine(Offset(size.width, 0), Offset(0, 0), p);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), p);
    }
    if (bottomLeft) {
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), p);
      canvas.drawLine(Offset(0, size.height), Offset.zero, p);
    }
    if (bottomRight) {
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(0, size.height),
        p,
      );
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width, 0),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MovingPhotosStrip extends StatefulWidget {
  const _MovingPhotosStrip();

  @override
  State<_MovingPhotosStrip> createState() => _MovingPhotosStripState();
}

class _MovingPhotosStripState extends State<_MovingPhotosStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _marquee;
  // Intrinsic asset size: 690 × 216
  static const double _assetAspect = 690 / 216;
  static const double _stripHeight = 112;

  @override
  void initState() {
    super.initState();
    _marquee = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _marquee.dispose();
    super.dispose();
  }

  Widget _tile(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        AppAssets.tryOnPhotosStrip,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        filterQuality: FilterQuality.medium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tileWidth = _stripHeight * _assetAspect;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: _stripHeight,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _marquee,
          builder: (context, _) {
            final dx = -_marquee.value * tileWidth;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: dx,
                  top: 0,
                  child: Row(
                    children: [
                      _tile(tileWidth, _stripHeight),
                      _tile(tileWidth, _stripHeight),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SmartRecommendationsPage extends StatelessWidget {
  const _SmartRecommendationsPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 350 / 437.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Zoom into product shelf so excess brown is cropped out
                  Transform.scale(
                    scale: 1.35,
                    alignment: const Alignment(0, 0.55),
                    child: Image.asset(
                      AppAssets.smartRecommendations,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Image.asset(
                      AppAssets.clinicallyProvenBadge,
                      width: 243,
                      height: 46,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'PHASE 03',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Smart Recommendations',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Shop the best products for your skin type, recommended just for you based on our clinical AI analysis.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag('Tailored Selection'),
              _Tag('Dermatologist Vetted'),
              _Tag('Ingredient Analysis'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4DED4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF52443D),
        ),
      ),
    );
  }
}
