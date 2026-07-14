import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glowbebe/features/try_on/widgets/try_on_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraMirrorScreen extends StatefulWidget {
  const CameraMirrorScreen({super.key});

  @override
  State<CameraMirrorScreen> createState() => _CameraMirrorScreenState();
}

class _CameraMirrorScreenState extends State<CameraMirrorScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;
  bool _initializing = true;
  String? _error;

  late final AnimationController _cameraFade;
  late final AnimationController _tagsAnim;
  late final FaceDetector _faceDetector;

  bool _faceInOval = false;
  bool _tagsRevealed = false;
  bool _processingFrame = false;
  bool _capturing = false;
  bool _streaming = false;
  int _faceHitStreak = 0;

  static const _tagLabels = [
    'Skin tone: Cool',
    'Undertone: Pink',
    'Contrast: High',
    'Align your face',
  ];

  String get _faceHintLabel =>
      _faceInOval ? 'Face locked' : 'Align your face';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cameraFade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _tagsAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableTracking: true,
      ),
    );

    _setupCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_stopStream());
    _controller?.dispose();
    _cameraFade.dispose();
    _tagsAnim.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      unawaited(_stopStream());
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _setupCamera();
    }
  }

  Future<void> _setupCamera() async {
    setState(() {
      _initializing = true;
      _error = null;
      _faceInOval = false;
      _tagsRevealed = false;
    });
    _cameraFade.value = 0;
    _tagsAnim.value = 0;

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
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _initializing = false;
          _error = 'No camera found on this device.';
        });
        return;
      }

      final frontIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      _cameraIndex = frontIndex >= 0 ? frontIndex : 0;
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
    final previous = _controller;
    await _stopStream();

    final controller = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup:
          Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    _controller = controller;
    try {
      await previous?.dispose();
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _initializing = false;
        _faceHitStreak = 0;
      });

      // Slowly reveal camera feed only — tags wait for face in oval.
      await _cameraFade.forward();
      if (!mounted) return;
      await _startStream();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initializing = false;
        _error = 'Camera failed to start.';
      });
    }
  }

  void _revealTags() {
    if (_tagsRevealed || !mounted) return;
    setState(() => _tagsRevealed = true);
    unawaited(_tagsAnim.forward());
  }

  Future<void> _startStream() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        _streaming) {
      return;
    }
    _streaming = true;
    try {
      await controller.startImageStream(_onCameraImage);
    } catch (_) {
      _streaming = false;
    }
  }

  Future<void> _stopStream() async {
    final controller = _controller;
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

  Future<void> _onCameraImage(CameraImage image) async {
    if (_processingFrame || !mounted) return;
    _processingFrame = true;

    try {
      final input = _inputImageFromCamera(image);
      if (input == null) return;

      final faces = await _faceDetector.processImage(input);
      if (!mounted) return;

      final inOval =
          faces.isNotEmpty && _isFaceInOval(faces.first, image);

      if (inOval) {
        _faceHitStreak++;
      } else {
        _faceHitStreak = 0;
      }

      // Require a short streak so brief false positives don't flash UI.
      final stableInOval = _faceHitStreak >= 2;

      if (stableInOval != _faceInOval) {
        setState(() => _faceInOval = stableInOval);
      }

      // Only after head/face sits in the round guide…
      if (stableInOval) {
        _revealTags();
      }
    } catch (_) {
      // Keep streaming even if a frame fails.
    } finally {
      _processingFrame = false;
    }
  }

  /// True when the detected face is large enough and roughly centered
  /// in the on-screen oval guide.
  bool _isFaceInOval(Face face, CameraImage image) {
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();
    if (imgW <= 0 || imgH <= 0) return false;

    final box = face.boundingBox;
    final faceArea = box.width * box.height;
    final imageArea = imgW * imgH;
    if (imageArea <= 0) return false;

    // Face should fill a meaningful portion of the frame (close to camera).
    final areaRatio = faceArea / imageArea;
    if (areaRatio < 0.06) return false;

    // Normalized center in image space.
    final cx = box.center.dx / imgW;
    final cy = box.center.dy / imgH;

    bool nearOvalCenter(double x, double y) {
      // Oval center sits at ~42% height; slightly forgiving radius.
      final dx = (x - 0.5) / 0.38;
      final dy = (y - 0.42) / 0.36;
      return dx * dx + dy * dy <= 1.35;
    }

    // Try both mirrored and non-mirrored X — front camera mapping varies.
    return nearOvalCenter(cx, cy) || nearOvalCenter(1.0 - cx, cy);
  }

  InputImage? _inputImageFromCamera(CameraImage image) {
    final controller = _controller;
    if (controller == null) return null;

    final rotation = _imageRotation(controller);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    if ((Platform.isAndroid && format == InputImageFormat.nv21) ||
        (Platform.isIOS && format == InputImageFormat.bgra8888)) {
      if (image.planes.isEmpty) return null;
      final plane = image.planes.first;
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    }

    final bytesBuilder = BytesBuilder(copy: false);
    for (final plane in image.planes) {
      bytesBuilder.add(plane.bytes);
    }
    return InputImage.fromBytes(
      bytes: bytesBuilder.takeBytes(),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  InputImageRotation? _imageRotation(CameraController controller) {
    final sensorOrientation = controller.description.sensorOrientation;

    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }

    // Android: compensate for device orientation + lens direction.
    const orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    final deviceOrientation =
        orientations[controller.value.deviceOrientation] ?? 0;
    final isFront =
        controller.description.lensDirection == CameraLensDirection.front;

    final compensation = isFront
        ? (sensorOrientation + deviceOrientation) % 360
        : (sensorOrientation - deviceOrientation + 360) % 360;

    return InputImageRotationValue.fromRawValue(compensation);
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2 || _controller == null) return;
    setState(() {
      _initializing = true;
      _faceInOval = false;
      _tagsRevealed = false;
      _faceHitStreak = 0;
    });
    _cameraFade.value = 0;
    _tagsAnim.value = 0;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _startCamera(_cameras[_cameraIndex]);
  }

  Future<void> _onCapture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _capturing) {
      return;
    }

    _capturing = true;
    try {
      await _stopStream();
      final photo = await controller.takePicture();
      if (!mounted) return;

      final isFront =
          controller.description.lensDirection == CameraLensDirection.front;

      await Navigator.pushReplacementNamed(
        context,
        RouteNames.realtimeTryOn,
        arguments: <String, dynamic>{
          'imagePath': photo.path,
          'mirror': isFront,
        },
      );
    } catch (_) {
      if (!mounted) return;
      await _startStream();
    } finally {
      _capturing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: CurvedAnimation(
              parent: _cameraFade,
              curve: Curves.easeInOut,
            ),
            child: _buildPreview(),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.1),
                  radius: 0.95,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.35),
                  ],
                  stops: const [0.55, 1],
                ),
              ),
            ),
          ),
          OvalFaceGuide(faceDetected: _faceInOval),
          Positioned(
            left: 24,
            top: size.height * 0.26,
            child: _AnimatedTag(
              label: _tagLabels[0],
              animation: _tagsAnim,
              intervalStart: 0.0,
              intervalEnd: 0.35,
              fromLeft: true,
            ),
          ),
          Positioned(
            right: 24,
            top: size.height * 0.30,
            child: _AnimatedTag(
              label: _tagLabels[1],
              animation: _tagsAnim,
              intervalStart: 0.15,
              intervalEnd: 0.5,
              fromLeft: false,
            ),
          ),
          Positioned(
            left: 24,
            top: size.height * 0.46,
            child: _AnimatedTag(
              label: _tagLabels[2],
              animation: _tagsAnim,
              intervalStart: 0.3,
              intervalEnd: 0.65,
              fromLeft: true,
            ),
          ),
          Positioned(
            right: 24,
            top: size.height * 0.50,
            child: _AnimatedTag(
              label: _faceHintLabel,
              animation: _tagsAnim,
              intervalStart: 0.45,
              intervalEnd: 0.8,
              fromLeft: false,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: _GlassCircle(
                  icon: Icons.close,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    await _stopStream();
                    if (!mounted) return;
                    nav.pop();
                  },
                ),
              ),
            ),
          ),
          if (!_tagsRevealed && !_initializing && _error == null)
            Positioned(
              left: 24,
              right: 24,
              bottom: 140,
              child: Text(
                'Place your face inside the oval',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _GlassCircle(
                    icon: Icons.photo_library_outlined,
                    onTap: () {},
                  ),
                  GestureDetector(
                    onTap: _controller?.value.isInitialized == true
                        ? _onCapture
                        : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  _GlassCircle(
                    icon: Icons.cameraswitch_outlined,
                    onTap: _cameras.length > 1 ? _flipCamera : () {},
                  ),
                ],
              ),
            ),
          ),
          if (_error != null)
            _ErrorOverlay(
              message: _error!,
              onRetry: _setupCamera,
              onOpenSettings: openAppSettings,
            ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final controller = _controller;
    if (_initializing) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: Colors.black);
    }

    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return CameraPreview(controller);
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: previewSize.height,
          height: previewSize.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _AnimatedTag extends StatelessWidget {
  const _AnimatedTag({
    required this.label,
    required this.animation,
    required this.intervalStart,
    required this.intervalEnd,
    required this.fromLeft,
  });

  final String label;
  final AnimationController animation;
  final double intervalStart;
  final double intervalEnd;
  final bool fromLeft;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOutCubic),
    );

    return IgnorePointer(
      child: FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(fromLeft ? -0.35 : 0.35, 0.15),
            end: Offset.zero,
          ).animate(curved),
          child: _Tag(label: label),
        ),
      ),
    );
  }
}

class _ErrorOverlay extends StatelessWidget {
  const _ErrorOverlay({
    required this.message,
    required this.onRetry,
    required this.onOpenSettings,
  });

  final String message;
  final VoidCallback onRetry;
  final Future<bool> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.videocam_off_outlined, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Try again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => onOpenSettings(),
                child: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassCircle extends StatelessWidget {
  const _GlassCircle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
