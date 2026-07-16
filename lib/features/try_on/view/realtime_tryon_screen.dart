import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';
import 'package:glowbebe/features/try_on/painter/makeup_painter.dart';
import 'package:glowbebe/features/try_on/provider/makeup_controller.dart';
import 'package:glowbebe/features/try_on/service/face_mesh_service.dart';
import 'package:glowbebe/features/try_on/service/image_capture_service.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class RealtimeTryOnScreen extends StatefulWidget {
  const RealtimeTryOnScreen({
    super.key,
    this.imagePath,
    this.mirror = false,
  });

  /// Captured still from Camera Mirror — shown as static, tappable photo.
  final String? imagePath;
  final bool mirror;

  @override
  State<RealtimeTryOnScreen> createState() => _RealtimeTryOnScreenState();
}

class _RealtimeTryOnScreenState extends State<RealtimeTryOnScreen>
    with WidgetsBindingObserver {
  final MakeupController _makeup = MakeupController();
  final FaceMeshService _faceService = FaceMeshService();
  late final ImageCaptureService _captureService;
  final ValueNotifier<FaceLandmarks?> _landmarks =
      ValueNotifier<FaceLandmarks?>(null);

  CameraController? _camera;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;
  bool _initializing = true;
  bool _streaming = false;
  bool _capturing = false;
  CaptureStatus _captureStatus = CaptureStatus.idle;
  String? _error;
  String? _faceHint;
  Size? _staticImageSize;
  String? _staticDisplayPath;

  bool get _useStaticImage {
    final path = widget.imagePath;
    return path != null && path.isNotEmpty && File(path).existsSync();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _captureService = ImageCaptureService.withSharedMesh(_faceService);

    if (_useStaticImage) {
      _initializing = false;
      unawaited(_loadStaticLandmarks());
    } else {
      _setupCamera();
    }
  }

  Future<void> _loadStaticLandmarks() async {
    final path = widget.imagePath;
    if (path == null) return;

    setState(() => _faceHint = null);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;

      var still = await _faceService.analyzeStill(path);
      if (still?.landmarks == null) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        still = await _faceService.analyzeStill(path);
      }

      if (!mounted) return;

      setState(() {
        _staticDisplayPath = still?.displayPath ?? path;
        _staticImageSize = still?.imageSize;
      });

      final raw = still?.landmarks;
      _makeup.setLandmarks(raw);
      _landmarks.value = raw;

      if (raw == null) {
        setState(
          () => _faceHint = 'Face not found — retake with more light',
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _faceHint = 'Could not analyze this photo');
    }
  }

  void _openStaticPhotoViewer() {
    final path = widget.imagePath;
    if (path == null) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _FullScreenPhotoPage(
          imagePath: path,
          mirror: widget.mirror,
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_stopStream());
    _camera?.dispose();
    _landmarks.dispose();
    _makeup.dispose();
    unawaited(_faceService.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_useStaticImage) return;
    final cam = _camera;
    if (cam == null || !cam.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      unawaited(_stopStream());
      cam.dispose();
      _camera = null;
    } else if (state == AppLifecycleState.resumed) {
      _setupCamera();
    }
  }

  Future<void> _setupCamera() async {
    setState(() {
      _initializing = true;
      _error = null;
      _faceHint = null;
    });

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) return;
      setState(() {
        _initializing = false;
        _error = status.isPermanentlyDenied
            ? 'Camera permission is blocked. Open settings to enable it.'
            : 'Camera permission is required for AR try-on.';
      });
      return;
    }

    try {
      await _faceService.ensureInitialized();
      _faceService.resetTracking();

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _initializing = false;
          _error = 'No camera found on this device.';
        });
        return;
      }
      final front = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      _cameraIndex = front >= 0 ? front : 0;
      await _startCamera(_cameras[_cameraIndex]);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initializing = false;
        _error = 'Could not start camera: $e';
      });
    }
  }

  Future<void> _startCamera(CameraDescription description) async {
    final previous = _camera;
    await _stopStream();

    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup:
          Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    _camera = controller;

    try {
      await previous?.dispose();
      await controller.initialize();
      if (!mounted) return;
      setState(() => _initializing = false);
      await _startStream();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _initializing = false;
        _error = 'Camera failed to start.';
      });
    }
  }

  Future<void> _startStream() async {
    final controller = _camera;
    if (controller == null ||
        !controller.value.isInitialized ||
        _streaming) {
      return;
    }
    _streaming = true;
    try {
      await controller.startImageStream(_onFrame);
    } catch (_) {
      _streaming = false;
    }
  }

  Future<void> _stopStream() async {
    final controller = _camera;
    if (controller == null || !_streaming) {
      _streaming = false;
      return;
    }
    _streaming = false;
    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } catch (_) {}
  }

  Future<void> _onFrame(CameraImage image) async {
    if (!_streaming || _capturing || _faceService.isBusy) return;

    final controller = _camera;
    if (controller == null) return;

    final raw = await _faceService.processCameraImage(
      image: image,
      controller: controller,
    );

    if (!mounted) return;

    if (raw == null) {
      if (_landmarks.value != null) {
        _landmarks.value = null;
      }
      _makeup.setLandmarks(null);
      if (_faceHint == null && mounted) {
        setState(() => _faceHint = 'Position your face in the frame');
      }
      return;
    }

    if (_faceHint != null && mounted) {
      setState(() => _faceHint = null);
    }

    _makeup.updateLandmarksQuiet(raw);
    if (!_makeup.faceDetected) {
      _makeup.setLandmarks(raw);
    }
    _landmarks.value = raw;
  }

  Future<void> _onCapture() async {
    if (_capturing) return;

    setState(() {
      _capturing = true;
      _captureStatus = CaptureStatus.loading;
    });

    try {
      String photoPath;

      if (_useStaticImage) {
        photoPath = widget.imagePath!;
      } else {
        final controller = _camera;
        if (controller == null || !controller.value.isInitialized) {
          throw StateError('Camera is not ready');
        }
        await _stopStream();
        final photo = await controller.takePicture();
        photoPath = photo.path;
      }

      final result = await _captureService.renderMakeupAndSave(
        photoPath: photoPath,
        makeup: _makeup,
      );

      if (!mounted) return;
      setState(() => _captureStatus = result.status);

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.message ??
                (result.status == CaptureStatus.success
                    ? 'Saved'
                    : 'Capture failed'),
          ),
          backgroundColor: result.status == CaptureStatus.success
              ? AppColors.primary
              : Colors.redAccent,
        ),
      );

      if (result.status == CaptureStatus.success && result.path != null) {
        await Navigator.pushNamed(
          context,
          RouteNames.customizeLook,
          arguments: <String, dynamic>{
            // Keep original capture so Customize / Compare can show before/after.
            'imagePath': photoPath,
            'mirror': _useStaticImage ? widget.mirror : false,
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _captureStatus = CaptureStatus.error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _capturing = false);
        if (!_useStaticImage) {
          await _startStream();
        }
      }
    }
  }

  void _showAppliedProducts() {
    final items = _makeup.appliedProducts;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applied products',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  Text(
                    'No makeup applied yet.',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  ...items.map((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(backgroundColor: item.shade.color),
                      title: Text(
                        '${item.shade.name} · ${item.category.shortLabel}',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Intensity ${(item.intensity * 100).round()}%',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _makeup.removeCategory(item.category);
                          Navigator.pop(ctx);
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaticPhotoLayer() {
    final path = _staticDisplayPath ?? widget.imagePath!;
    final imgSize = _staticImageSize ?? const Size(1080, 1440);

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: imgSize.width,
        height: imgSize.height,
        child: Transform.flip(
          flipX: widget.mirror,
          // Flip photo + makeup together — landmarks stay in image space.
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(path),
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
              ValueListenableBuilder<FaceLandmarks?>(
                valueListenable: _landmarks,
                builder: (context, raw, _) {
                  return CustomPaint(
                    size: imgSize,
                    painter: MakeupPainter(
                      landmarks: raw,
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
    final cam = _camera;
    final mirrorOverlay = _useStaticImage
        ? widget.mirror
        : cam?.description.lensDirection == CameraLensDirection.front;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListenableBuilder(
        listenable: _makeup,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              if (_useStaticImage)
                GestureDetector(
                  onTap: _openStaticPhotoViewer,
                  child: Hero(
                    tag: 'tryon-static-${widget.imagePath}',
                    // Photo + makeup share one FittedBox so lip landmarks stay aligned.
                    child: _buildStaticPhotoLayer(),
                  ),
                )
              else if (cam != null && cam.value.isInitialized)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: cam.value.previewSize!.height,
                    height: cam.value.previewSize!.width,
                    child: CameraPreview(cam),
                  ),
                )
              else
                const ColoredBox(color: Colors.black),
              if (!_useStaticImage &&
                  cam != null &&
                  cam.value.isInitialized)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ValueListenableBuilder<FaceLandmarks?>(
                      valueListenable: _landmarks,
                      builder: (context, raw, _) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final size = Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            );
                            final mapped = raw?.mappedTo(
                              widgetSize: size,
                              mirror: mirrorOverlay,
                            );
                            return CustomPaint(
                              painter: MakeupPainter(
                                landmarks: mapped,
                                controller: _makeup,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              // Let taps pass to the photo except on interactive UI.
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.4),
                      ],
                      stops: const [0, 0.5, 1],
                    ),
                  ),
                ),
              ),
              // Controls + panel overlays below.
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16),
                    child: _ToolBtn(
                      icon: Icons.close,
                      onTap: () => _makeup.togglePanel(),
                    ),
                  ),
                ),
              ),
              if (_makeup.statusLabel != null)
                Positioned(
                  top: 100,
                  left: 60,
                  right: 60,
                  child: _StatusPill(label: _makeup.statusLabel!),
                ),
              if (_faceHint != null && !_makeup.faceDetected)
                Positioned(
                  top: 160,
                  left: 40,
                  right: 40,
                  child: IgnorePointer(
                    child: Text(
                      _faceHint!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 16,
                top: MediaQuery.of(context).padding.top + 64,
                child: Column(
                  children: [
                    _ToolBtn(
                      icon: Icons.layers_outlined,
                      onTap: _showAppliedProducts,
                      onLongPress: _makeup.toggleDebugLandmarks,
                    ),
                    const SizedBox(height: 12),
                    _ToolBtn(
                      icon: Icons.wb_sunny_outlined,
                      onTap: _makeup.toggleIntensitySlider,
                    ),
                    const SizedBox(height: 12),
                    Listener(
                      onPointerDown: (_) => _makeup.setHideMakeup(true),
                      onPointerUp: (_) => _makeup.setHideMakeup(false),
                      onPointerCancel: (_) => _makeup.setHideMakeup(false),
                      child: _ToolBtn(
                        icon: Icons.face_retouching_natural,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              if (_makeup.intensityVisible)
                Positioned(
                  right: 72,
                  top: MediaQuery.of(context).padding.top + 64 + 60,
                  child: _IntensitySlider(
                    value: _makeup.selectedIntensity,
                    onChanged: _makeup.setIntensity,
                  ),
                ),
              if (_makeup.panelVisible)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _MakeupPanel(
                    categoryIndex: _makeup.categoryIndex,
                    selectedShade: _makeup.selectedShade,
                    onCategory: _makeup.setCategory,
                    onClear: _makeup.clearCurrentCategory,
                    onShade: _makeup.selectShade,
                    onCapture: _capturing ? null : _onCapture,
                    capturing: _capturing,
                  ),
                )
              else
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 28,
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () => _makeup.setPanelVisible(true),
                      icon: const Icon(Icons.palette_outlined),
                      label: const Text('Show makeup panel'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black45,
                      ),
                    ),
                  ),
                ),
              if (_initializing)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (_captureStatus == CaptureStatus.loading)
                const ColoredBox(
                  color: Color(0x66000000),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              if (_error != null)
                _ErrorBody(
                  message: _error!,
                  onRetry: _setupCamera,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    height: 1.2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntensitySlider extends StatelessWidget {
  const _IntensitySlider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 160,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceSoft,
            thumbColor: AppColors.primary,
            trackHeight: 2,
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _MakeupPanel extends StatelessWidget {
  const _MakeupPanel({
    required this.categoryIndex,
    required this.selectedShade,
    required this.onCategory,
    required this.onClear,
    required this.onShade,
    required this.onCapture,
    required this.capturing,
  });

  final int categoryIndex;
  final MakeupShade? selectedShade;
  final ValueChanged<int> onCategory;
  final VoidCallback onClear;
  final ValueChanged<MakeupShade> onShade;
  final VoidCallback? onCapture;
  final bool capturing;

  @override
  Widget build(BuildContext context) {
    final category = MakeupCategoryX.fromIndex(categoryIndex);
    final shades = MakeupCatalog.shadesFor(category);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: List.generate(MakeupCategory.values.length, (i) {
                  final selected = categoryIndex == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onCategory(i),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          MakeupCategory.values[i].label,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.7,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textSecondary.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 96,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ShadeChip(
                            name: 'CLEAR',
                            color: Colors.transparent,
                            selected: selectedShade == null,
                            isClear: true,
                            onTap: onClear,
                          ),
                          const SizedBox(width: 16),
                          ...shades.map((s) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: ShadeChip(
                                name: s.name,
                                color: s.color,
                                selected: selectedShade?.id == s.id,
                                onTap: () => onShade(s),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: onCapture,
                        child: Opacity(
                          opacity: capturing ? 0.5 : 1,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 4,
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF6B5B53),
                                  Color(0xFF805443),
                                ],
                              ),
                            ),
                            child: capturing
                                ? const Padding(
                                    padding: EdgeInsets.all(22),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.photo_camera_outlined,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'CAPTURE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  const _ToolBtn({
    required this.icon,
    required this.onTap,
    this.onLongPress,
  });

  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: AppColors.background.withValues(alpha: 0.7),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black87,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
              TextButton(
                onPressed: () => openAppSettings(),
                child: const Text('Open settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullScreenPhotoPage extends StatelessWidget {
  const _FullScreenPhotoPage({
    required this.imagePath,
    required this.mirror,
  });

  final String imagePath;
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Hero(
              tag: 'tryon-static-$imagePath',
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Transform.flip(
                  flipX: mirror,
                  child: Image.file(File(imagePath), fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
