import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinScanAnalyzingScreen extends StatefulWidget {
  const SkinScanAnalyzingScreen({super.key});

  @override
  State<SkinScanAnalyzingScreen> createState() =>
      _SkinScanAnalyzingScreenState();
}

class _SkinScanAnalyzingScreenState extends State<SkinScanAnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.skinScanResults);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 8,
                        backgroundColor: AppColors.surfaceSoft,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                        strokeCap: StrokeCap.round,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 36),
                GlowSerifTitle('Analyzing your skin', size: 24, align: TextAlign.center),
                const SizedBox(height: 12),
                Text(
                  'Mapping texture, tone, and hydration patterns…',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
