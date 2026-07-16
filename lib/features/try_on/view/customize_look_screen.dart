import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';
import 'package:glowbebe/features/try_on/model/try_on_models.dart';
import 'package:glowbebe/features/try_on/painter/makeup_painter.dart';
import 'package:glowbebe/features/try_on/provider/makeup_controller.dart';
import 'package:glowbebe/features/try_on/service/face_mesh_service.dart';
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
  final FaceMeshService _faceService = FaceMeshService();
  late final ImageCaptureService _captureService;

  FaceLandmarks? _landmarks;
  Size? _imageSize;
  String? _displayPath;
  String? _savedPath;
  int _presetIndex = 1; // Soft
  double _intensity = 0.10;
  double _opacity = 0.10;
  bool _analyzing = true;
  bool _busy = false;
  String? _hint;

  bool get _hasPhoto {
    final path = _displayPath ?? widget.imagePath;
    return path != null && File(path).existsSync();
  }

  @override
  void initState() {
    super.initState();
    _captureService = ImageCaptureService.withSharedMesh(_faceService);
    _makeup.applyStylePreset(_presetIndex);
    // First open: light defaults — user raises with Refine Look sliders.
    _intensity = 0.10;
    _opacity = 0.10;
    _makeup.setAllBaseIntensities(_intensity);
    _makeup.setLookOpacity(_opacity);
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
      // New style starts at 10%; user increases shade / opacity after.
      _intensity = 0.10;
      _opacity = 0.10;
    });
    _makeup.applyStylePreset(index);
    _makeup.setAllBaseIntensities(0.10);
    _makeup.setLookOpacity(0.10);
  }

  Future<CaptureResult?> _renderLook() async {
    final path = _displayPath ?? widget.imagePath;
    if (path == null) return null;

    final result = await _captureService.renderMakeupAndSave(
      photoPath: path,
      makeup: _makeup,
    );
    if (result.status == CaptureStatus.success && result.path != null) {
      _savedPath = result.path;
    }
    return result;
  }

  Future<void> _applyLook() async {
    if (_busy || !_hasPhoto) return;
    setState(() => _busy = true);
    try {
      final path = _displayPath ?? widget.imagePath!;
      final result = await _renderLook();
      if (!mounted) return;

      await Navigator.pushNamed(
        context,
        RouteNames.captureComparison,
        arguments: <String, dynamic>{
          'beforePath': path,
          'afterPath': result?.path ?? path,
          'imagePath': result?.path ?? path,
          'mirror': false,
        },
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveLook() async {
    if (_busy || !_hasPhoto) return;
    setState(() => _busy = true);
    try {
      final result = await _renderLook();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result?.message ?? 'Look saved'),
          backgroundColor: result?.status == CaptureStatus.success
              ? AppColors.primary
              : Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _shareLook() async {
    if (_busy || !_hasPhoto) return;
    setState(() => _busy = true);
    try {
      if (_savedPath == null) {
        await _renderLook();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Share sheet coming soon')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _tryAgain() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacementNamed(context, RouteNames.realtimeTryOn);
  }

  Widget _buildPreview() {
    final path = _displayPath ?? widget.imagePath;
    final size = _imageSize ?? const Size(800, 1000);

    if (path == null || !File(path).existsSync()) {
      return Image.asset(AppAssets.lookSoftGlam, fit: BoxFit.contain);
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
    final screenH = MediaQuery.sizeOf(context).height;
    final previewH = (screenH * 0.48).clamp(280.0, 420.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            BrandHeader(
              onClose: () => Navigator.pop(context),
              onShare: () => unawaited(_shareLook()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: Container(
                      key: ValueKey('look_$_presetIndex'),
                      width: double.infinity,
                      height: previewH,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEEA),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFD2C4BE),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
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
                  const SizedBox(height: 22),
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
                    height: 104,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: TryOnMockData.featuredLooks.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final look = TryOnMockData.featuredLooks[index];
                        final selected = _presetIndex == index;
                        return GestureDetector(
                          onTap: () => _onPreset(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            width: 72,
                            child: Column(
                              children: [
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : const Color(0x00FFFFFF),
                                      width: 2.5,
                                    ),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.22),
                                              blurRadius: 10,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: ClipOval(
                                    child: Image.asset(
                                      look.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  look.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
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
                  const SizedBox(height: 18),
                  PrimaryPillButton(
                    label: _busy ? 'WORKING…' : 'APPLY LOOK',
                    icon: Icons.check_rounded,
                    onPressed: () {
                      if (_busy || !_hasPhoto) return;
                      unawaited(_applyLook());
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SecondaryAction(
                          label: 'Save Look',
                          icon: Icons.bookmark_border_rounded,
                          onTap: () {
                            if (_busy || !_hasPhoto) return;
                            unawaited(_saveLook());
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SecondaryAction(
                          label: 'Share',
                          icon: Icons.ios_share_rounded,
                          onTap: () {
                            if (_busy || !_hasPhoto) return;
                            unawaited(_shareLook());
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _tryAgain,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text(
                        'Try Again',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.7),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
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

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8E2DE),
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
