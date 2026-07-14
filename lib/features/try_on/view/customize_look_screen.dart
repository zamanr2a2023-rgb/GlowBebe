import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';
import 'package:glowbebe/features/try_on/model/try_on_models.dart';
import 'package:glowbebe/features/try_on/painter/makeup_painter.dart';
import 'package:glowbebe/features/try_on/provider/makeup_controller.dart';
import 'package:glowbebe/features/try_on/service/face_detection_service.dart';
import 'package:glowbebe/features/try_on/service/image_capture_service.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomizeLookScreen extends StatefulWidget {
  const CustomizeLookScreen({
    super.key,
    this.imagePath,
    this.mirror = false,
  });

  final String? imagePath;
  final bool mirror;

  @override
  State<CustomizeLookScreen> createState() => _CustomizeLookScreenState();
}

class _CustomizeLookScreenState extends State<CustomizeLookScreen> {
  final MakeupController _makeup = MakeupController();
  final FaceDetectionService _faceService = FaceDetectionService();
  late final ImageCaptureService _captureService;

  FaceLandmarks? _landmarks;
  Size? _imageSize;
  String? _displayPath;
  int _presetIndex = 1; // Soft Glam
  double _intensity = 0.65;
  double _opacity = 0.75;
  bool _analyzing = true;
  bool _capturing = false;
  String? _hint;

  bool get _hasPhoto {
    final path = _displayPath ?? widget.imagePath;
    return path != null && File(path).existsSync();
  }

  @override
  void initState() {
    super.initState();
    _captureService = ImageCaptureService.withSharedDetector(_faceService);
    _makeup.setLookOpacity(_opacity);
    _makeup.applyStylePreset(_presetIndex);
    _intensity = 0.65;
    unawaited(_analyzePhoto());
  }

  @override
  void dispose() {
    _makeup.dispose();
    unawaited(_faceService.dispose());
    super.dispose();
  }

  Future<void> _analyzePhoto() async {
    final path = widget.imagePath;
    if (path == null || !File(path).existsSync()) {
      setState(() {
        _analyzing = false;
        _hint = 'No photo to refine';
      });
      return;
    }

    setState(() {
      _analyzing = true;
      _hint = null;
    });

    try {
      final still = await _faceService.analyzeStill(path);
      if (!mounted) return;
      setState(() {
        _displayPath = still?.displayPath ?? path;
        _imageSize = still?.imageSize;
        _landmarks = still?.landmarks;
        _analyzing = false;
        if (still?.landmarks == null) {
          _hint = 'Face not found — try another photo';
        }
      });
      _makeup.setLandmarks(still?.landmarks);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _analyzing = false;
        _hint = 'Could not analyze this photo';
      });
    }
  }

  void _onIntensityChanged(double value) {
    setState(() => _intensity = value);
    _makeup.setAllBaseIntensities(value);
  }

  void _onOpacityChanged(double value) {
    setState(() => _opacity = value);
    _makeup.setLookOpacity(value);
  }

  void _onPreset(int index) {
    setState(() {
      _presetIndex = index;
      // Match style default strengths (also applied inside controller).
      _intensity = switch (index.clamp(0, 3)) {
        0 => 0.45,
        1 => 0.65,
        2 => 0.55,
        _ => 0.85,
      };
    });
    _makeup.applyStylePreset(index);
  }

  Future<void> _captureLook() async {
    if (_capturing) return;
    final path = _displayPath ?? widget.imagePath;
    if (path == null) {
      Navigator.pushNamed(
        context,
        RouteNames.captureComparison,
        arguments: <String, dynamic>{'mirror': widget.mirror},
      );
      return;
    }

    setState(() => _capturing = true);
    try {
      final result = await _captureService.renderMakeupAndSave(
        photoPath: path,
        makeup: _makeup,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Look captured'),
          backgroundColor: result.status == CaptureStatus.success
              ? AppColors.primary
              : Colors.redAccent,
        ),
      );

      await Navigator.pushNamed(
        context,
        RouteNames.captureComparison,
        arguments: <String, dynamic>{
          'beforePath': path,
          'afterPath': result.path ?? path,
          'imagePath': result.path ?? path,
          'mirror': false,
        },
      );
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  Widget _buildPreview() {
    final path = _displayPath ?? widget.imagePath;
    final size = _imageSize ?? const Size(800, 800);

    if (path == null || !File(path).existsSync()) {
      return Image.asset(AppAssets.lookSoftGlam, fit: BoxFit.cover);
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Transform.flip(
          flipX: widget.mirror,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(File(path), fit: BoxFit.fill),
              ListenableBuilder(
                listenable: _makeup,
                builder: (context, _) {
                  return CustomPaint(
                    size: size,
                    painter: MakeupPainter(
                      landmarks: _landmarks,
                      controller: _makeup,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            BrandHeader(
              onClose: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD2C4BE),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildPreview(),
                          if (_analyzing)
                            const ColoredBox(
                              color: Color(0x66000000),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_hint != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _hint!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.surfaceSoft,
                      thumbColor: AppColors.primary,
                      trackHeight: 2,
                    ),
                    child: Slider(
                      value: _intensity,
                      onChanged: _onIntensityChanged,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose Style',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 96,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: TryOnMockData.featuredLooks.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final look = TryOnMockData.featuredLooks[index];
                        final selected = _presetIndex == index;
                        return GestureDetector(
                          onTap: () => _onPreset(index),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                                padding: const EdgeInsets.all(2),
                                child: ClipOval(
                                  child: Image.asset(
                                    look.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                look.title.split(' ').first,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Refine Look',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SliderRow(
                    label: 'SHADE INTENSITY',
                    value: _intensity,
                    onChanged: _onIntensityChanged,
                  ),
                  _SliderRow(
                    label: 'OPACITY',
                    value: _opacity,
                    onChanged: _onOpacityChanged,
                  ),
                  const SizedBox(height: 20),
                  PrimaryPillButton(
                    label: _capturing ? 'SAVING…' : 'CAPTURE LOOK',
                    icon: Icons.camera_alt_outlined,
                    onPressed: () {
                      if (_capturing || !_hasPhoto) return;
                      unawaited(_captureLook());
                    },
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

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '${(value * 100).round()}%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceSoft,
            thumbColor: AppColors.primary,
            trackHeight: 2,
            overlayColor: AppColors.primary.withValues(alpha: 0.12),
          ),
          child: Slider(value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}
