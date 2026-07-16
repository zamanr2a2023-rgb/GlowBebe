import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisResultsScreen extends StatelessWidget {
  const AnalysisResultsScreen({super.key});

  static const _seasonColors = <({String name, Color color})>[
    (name: 'Midnight', color: Color(0xFF1E2A4F)),
    (name: 'Crimson', color: Color(0xFF5D1A2F)),
    (name: 'Pure Frost', color: Color(0xFFE8E6EA)),
    (name: 'Amethyst', color: Color(0xFF2F1B41)),
    (name: 'Ruby Ice', color: Color(0xFF8E4057)),
    (name: 'Teal Jewel', color: Color(0xFF1A4A4A)),
  ];

  static final _ingredients = <({String name, String benefit, IconData icon})>[
    (name: 'Niacinamide', benefit: 'Brightness', icon: Icons.wb_sunny_outlined),
    (name: 'Squalane', benefit: 'Hydration', icon: Icons.water_drop_outlined),
    (name: 'Ceramides', benefit: 'Barrier Support', icon: Icons.shield_outlined),
    (name: 'Peptides', benefit: 'Firmness', icon: Icons.auto_awesome_outlined),
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
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
        children: [
          Text(
            'ANALYSIS CONFIRMED',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: const Color(0xFF805443),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Signature\nIdentity',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 40 / 32,
              color: const Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Our AI has synthesized your facial architecture and pigment levels to define your unique aesthetic profile.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              height: 28 / 18,
              color: const Color(0xFF4E4540),
            ),
          ),
          const SizedBox(height: 16),
          const _InfoPill(
            icon: Icons.face_retouching_natural,
            label: 'Oval Face Shape',
          ),
          const SizedBox(height: 12),
          const _InfoPill(
            icon: Icons.palette_outlined,
            label: 'Neutral Cool Undertone',
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 280,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppAssets.lookNatural, fit: BoxFit.cover),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '98% Match Confidence',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF805443),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF805443),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Seasonal Color Type',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: const Color(0xFFF3BAA4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Cool Winter',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 40 / 32,
                  color: const Color(0xFF1C1B1B),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFF805443),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your features are characterized by high contrast and cool undertones. Silver jewelry, stark whites, and deep jewel tones illuminate your complexion most effectively.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 24 / 16,
              color: const Color(0xFF4E4540),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _seasonColors.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, i) {
              final item = _seasonColors[i];
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(10),
                        border: item.name == 'Pure Frost'
                            ? Border.all(color: const Color(0xFFD2C4BE))
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4E4540),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF7E1D7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Contrast Level',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF73635B),
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const value = 0.85;
                    final trackW = constraints.maxWidth;
                    final thumbLeft = (trackW * value) - 10;
                    return SizedBox(
                      height: 20,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 8,
                            width: trackW,
                            decoration: BoxDecoration(
                              color: const Color(0xFF73635B)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Container(
                            height: 8,
                            width: trackW * value,
                            decoration: BoxDecoration(
                              color: const Color(0xFF73635B),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Positioned(
                            left: thumbLeft.clamp(0, trackW - 20),
                            top: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF73635B),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  '85% High Contrast',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: const Color(0xFF73635B),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.placementAdvice,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF805443),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Get Shop Guide  ›',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Clinical Recommendations',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 16),
          ..._ingredients.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD2C4BE).withValues(alpha: 0.1),
                  ),
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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5E2D9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: const Color(0xFF695C55),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C1B1B),
                          ),
                        ),
                        Text(
                          item.benefit,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF4E4540),
                          ),
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
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF7E1D7)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF805443)),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: const Color(0xFF1C1B1B),
            ),
          ),
        ],
      ),
    );
  }
}


