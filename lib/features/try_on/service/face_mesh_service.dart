import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:glowbebe/features/try_on/model/face_mesh_regions.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';
import 'package:mediapipe_face_mesh/mediapipe_face_mesh.dart';

/// MediaPipe Face Mesh tracking for live camera + still photos.
class FaceMeshService {
  FaceMeshService();

  FaceDetectorProcessor? _detector;
  FaceMeshProcessor? _mesh;
  FaceMeshInferencePipeline? _pipeline;

  bool _initializing = false;
  bool _busy = false;
  FaceLandmarks? _smoothed;
  int _missFrames = 0;
  static const double _smoothAlpha = 0.55;
  static const int _maxMissFrames = 12;

  bool get isBusy => _busy;
  bool get isReady => _pipeline != null;

  Future<void> ensureInitialized() async {
    if (_pipeline != null || _initializing) return;
    _initializing = true;
    try {
      _detector = await FaceDetectorProcessor.create(
        model: FaceDetectionModel.shortRange,
        delegate: FaceMeshDelegate.xnnpack,
        maxResults: 1,
        allowDelegateFallback: true,
      );
      _mesh = await FaceMeshProcessor.create(
        delegate: FaceMeshDelegate.xnnpack,
        enableSmoothing: true,
        enableRoiTracking: true,
        enableAttentionMesh: true,
        allowDelegateFallback: true,
        threads: 2,
      );
      _pipeline = FaceMeshInferencePipeline(
        detector: _detector!,
        mesh: _mesh!,
        enableLandmarkTracking: true,
      );
    } finally {
      _initializing = false;
    }
  }

  Future<void> dispose() async {
    _pipeline?.resetTracking();
    _pipeline = null;
    _mesh?.close();
    _mesh = null;
    _detector?.close();
    _detector = null;
    _smoothed = null;
  }

  void resetTracking() {
    _pipeline?.resetTracking();
    _smoothed = null;
    _missFrames = 0;
  }

  /// Live camera frame → makeup landmarks (null if busy / no face).
  Future<FaceLandmarks?> processCameraImage({
    required CameraImage image,
    required CameraController controller,
  }) async {
    if (_busy) return null;
    _busy = true;
    try {
      await ensureInitialized();
      final pipeline = _pipeline;
      if (pipeline == null) return null;

      final rotation = rotationCompensationDegrees(controller);
      if (rotation == null) return null;

      final FaceMeshInferenceResult result;
      if (Platform.isAndroid) {
        final nv21 = FaceMeshCameraAdapter.toNv21(image);
        if (nv21 == null) return null;
        result = pipeline.processNv21(
          nv21,
          rotationDegrees: rotation,
          mirrorHorizontal: false,
        );
      } else {
        final bgra = FaceMeshCameraAdapter.toBgra(image);
        if (bgra == null) return null;
        result = pipeline.process(
          bgra,
          rotationDegrees: rotation,
          mirrorHorizontal: false,
        );
      }

      final mesh = result.meshResult;
      if (mesh == null || mesh.landmarks.length < 468) {
        _missFrames++;
        if (_missFrames > _maxMissFrames) {
          _smoothed = null;
          return null;
        }
        return _smoothed;
      }

      _missFrames = 0;
      // Landmarks already in display orientation after inference rotation.
      final landmarks = _landmarksFromMesh(mesh, mapRotation: 0);
      return _applySmoothing(landmarks);
    } catch (e, st) {
      debugPrint('FaceMeshService.processCameraImage: $e\n$st');
      return _smoothed;
    } finally {
      _busy = false;
    }
  }

  /// Still photo analysis — same mesh path as live for consistent makeup.
  Future<StillFaceResult?> analyzeStill(String path) async {
    try {
      await ensureInitialized();
      final pipeline = _pipeline;
      if (pipeline == null) return null;

      final decoded = await _decodeRgba(path);
      if (decoded == null) return null;

      // Prefer upright PNG for display (matches previous ML Kit behavior).
      final pngPath = await _rewriteAsPng(path) ?? path;

      pipeline.resetTracking();
      final meshImage = FaceMeshImage(
        pixels: decoded.pixels,
        width: decoded.width,
        height: decoded.height,
        pixelFormat: FaceMeshPixelFormat.rgba,
      );
      final result = pipeline.process(
        meshImage,
        rotationDegrees: 0,
        mirrorHorizontal: false,
      );
      final mesh = result.meshResult;
      FaceLandmarks? landmarks;
      if (mesh != null && mesh.landmarks.length >= 468) {
        landmarks = _landmarksFromMesh(mesh, mapRotation: 0);
        _smoothed = landmarks;
      }

      return StillFaceResult(
        landmarks: landmarks,
        displayPath: pngPath,
        imageSize: Size(decoded.width.toDouble(), decoded.height.toDouble()),
      );
    } catch (e, st) {
      debugPrint('FaceMeshService.analyzeStill: $e\n$st');
      return null;
    }
  }

  Future<FaceLandmarks?> processFile(String path) async {
    final still = await analyzeStill(path);
    return still?.landmarks;
  }

  FaceLandmarks _landmarksFromMesh(
    FaceMeshResult mesh, {
    required int mapRotation,
  }) {
    final all = FaceMeshRegions.offsetsFromResult(
      mesh,
      mapRotationDegrees: mapRotation,
      mirrorHorizontal: false,
    );
    final size = Size(mesh.imageWidth.toDouble(), mesh.imageHeight.toDouble());

    return FaceLandmarks(
      imageSize: size,
      faceOval: FaceMeshRegions.pick(all, FaceMeshRegions.faceOval),
      upperLipTop: FaceMeshRegions.pick(all, FaceMeshRegions.upperLipTop),
      upperLipBottom: FaceMeshRegions.pick(all, FaceMeshRegions.upperLipBottom),
      lowerLipTop: FaceMeshRegions.pick(all, FaceMeshRegions.lowerLipTop),
      lowerLipBottom: FaceMeshRegions.pick(all, FaceMeshRegions.lowerLipBottom),
      leftEye: FaceMeshRegions.pick(all, FaceMeshRegions.leftEye),
      rightEye: FaceMeshRegions.pick(all, FaceMeshRegions.rightEye),
      leftEyebrow: FaceMeshRegions.pick(all, FaceMeshRegions.leftEyebrowTop),
      rightEyebrow: FaceMeshRegions.pick(all, FaceMeshRegions.rightEyebrowTop),
      leftEyebrowBottom:
          FaceMeshRegions.pick(all, FaceMeshRegions.leftEyebrowBottom),
      rightEyebrowBottom:
          FaceMeshRegions.pick(all, FaceMeshRegions.rightEyebrowBottom),
      leftCheekContour:
          FaceMeshRegions.pick(all, FaceMeshRegions.leftCheekContour),
      rightCheekContour:
          FaceMeshRegions.pick(all, FaceMeshRegions.rightCheekContour),
      noseBridge: FaceMeshRegions.pick(all, FaceMeshRegions.noseBridge),
      noseBottom: FaceMeshRegions.pick(all, FaceMeshRegions.noseBottom),
      leftCheek: FaceMeshRegions.pickOne(all, FaceMeshRegions.leftCheek),
      rightCheek: FaceMeshRegions.pickOne(all, FaceMeshRegions.rightCheek),
      noseBase: FaceMeshRegions.pickOne(all, FaceMeshRegions.noseBase),
    );
  }

  FaceLandmarks _applySmoothing(FaceLandmarks next) {
    final prev = _smoothed;
    if (prev == null || prev.imageSize != next.imageSize) {
      _smoothed = next;
      return next;
    }
    final a = _smoothAlpha;
    final b = 1.0 - a;

    List<Offset> lerpList(List<Offset> p, List<Offset> n) {
      if (p.length != n.length || p.isEmpty) return n;
      return [
        for (var i = 0; i < n.length; i++)
          Offset(p[i].dx * b + n[i].dx * a, p[i].dy * b + n[i].dy * a),
      ];
    }

    Offset? lerpOpt(Offset? p, Offset? n) {
      if (n == null) return p;
      if (p == null) return n;
      return Offset(p.dx * b + n.dx * a, p.dy * b + n.dy * a);
    }

    final smoothed = FaceLandmarks(
      imageSize: next.imageSize,
      faceOval: lerpList(prev.faceOval, next.faceOval),
      upperLipTop: lerpList(prev.upperLipTop, next.upperLipTop),
      upperLipBottom: lerpList(prev.upperLipBottom, next.upperLipBottom),
      lowerLipTop: lerpList(prev.lowerLipTop, next.lowerLipTop),
      lowerLipBottom: lerpList(prev.lowerLipBottom, next.lowerLipBottom),
      leftEye: lerpList(prev.leftEye, next.leftEye),
      rightEye: lerpList(prev.rightEye, next.rightEye),
      leftEyebrow: lerpList(prev.leftEyebrow, next.leftEyebrow),
      rightEyebrow: lerpList(prev.rightEyebrow, next.rightEyebrow),
      leftEyebrowBottom:
          lerpList(prev.leftEyebrowBottom, next.leftEyebrowBottom),
      rightEyebrowBottom:
          lerpList(prev.rightEyebrowBottom, next.rightEyebrowBottom),
      leftCheekContour: lerpList(prev.leftCheekContour, next.leftCheekContour),
      rightCheekContour:
          lerpList(prev.rightCheekContour, next.rightCheekContour),
      noseBridge: lerpList(prev.noseBridge, next.noseBridge),
      noseBottom: lerpList(prev.noseBottom, next.noseBottom),
      leftCheek: lerpOpt(prev.leftCheek, next.leftCheek),
      rightCheek: lerpOpt(prev.rightCheek, next.rightCheek),
      noseBase: lerpOpt(prev.noseBase, next.noseBase),
    );
    _smoothed = smoothed;
    return smoothed;
  }

  static int? rotationCompensationDegrees(CameraController controller) {
    final sensorOrientation = controller.description.sensorOrientation;

    if (Platform.isIOS) {
      return _deviceOrientationDegrees[controller.value.deviceOrientation] ??
          sensorOrientation;
    }

    final deviceRotation =
        _deviceOrientationDegrees[controller.value.deviceOrientation];
    if (deviceRotation == null) return null;

    final isFront =
        controller.description.lensDirection == CameraLensDirection.front;
    if (isFront) {
      return (sensorOrientation + deviceRotation) % 360;
    }
    return (sensorOrientation - deviceRotation + 360) % 360;
  }

  static const _deviceOrientationDegrees = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Future<_RgbaImage?> _decodeRgba(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final bd = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final w = image.width;
      final h = image.height;
      image.dispose();
      if (bd == null) return null;
      return _RgbaImage(
        pixels: bd.buffer.asUint8List(),
        width: w,
        height: h,
      );
    } catch (_) {
      return null;
    }
  }

  Future<String?> _rewriteAsPng(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (png == null) return null;
      final out = File(
        '${Directory.systemTemp.path}/glowbebe_mesh_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await out.writeAsBytes(png.buffer.asUint8List(), flush: true);
      return out.path;
    } catch (_) {
      return null;
    }
  }
}

class _RgbaImage {
  const _RgbaImage({
    required this.pixels,
    required this.width,
    required this.height,
  });

  final Uint8List pixels;
  final int width;
  final int height;
}

/// Converts `camera` [CameraImage] frames into MediaPipe input types.
class FaceMeshCameraAdapter {
  const FaceMeshCameraAdapter._();

  static FaceMeshNv21Image? toNv21(CameraImage image) {
    final planes = image.planes;
    if (planes.isEmpty) return null;
    if ((image.width & 1) != 0 || (image.height & 1) != 0) return null;

    if (planes.length == 1) {
      final plane = planes.first;
      return FaceMeshNv21Image.tryFromSinglePlane(
        bytes: plane.bytes,
        width: image.width,
        height: image.height,
        bytesPerRow: plane.bytesPerRow,
      );
    }
    if (planes.length == 2) {
      return FaceMeshNv21Image.tryFromYAndInterleavedVuPlanes(
        width: image.width,
        height: image.height,
        yPlane: planes[0]._asMeshPlane(),
        vuPlane: planes[1]._asMeshPlane(),
      );
    }
    if (planes.length >= 3) {
      return FaceMeshNv21Image.tryFromYuv420Planes(
        width: image.width,
        height: image.height,
        yPlane: planes[0]._asMeshPlane(),
        uPlane: planes[1]._asMeshPlane(),
        vPlane: planes[2]._asMeshPlane(),
      );
    }
    return null;
  }

  static FaceMeshImage? toBgra(CameraImage image) {
    final planes = image.planes;
    if (planes.isEmpty) return null;
    final plane = planes.first;
    return FaceMeshImage(
      pixels: plane.bytes,
      width: image.width,
      height: image.height,
      bytesPerRow: plane.bytesPerRow,
      pixelFormat: FaceMeshPixelFormat.bgra,
    );
  }
}

extension on Plane {
  FaceMeshImagePlane _asMeshPlane() {
    return FaceMeshImagePlane(
      bytes: bytes,
      bytesPerRow: bytesPerRow,
      bytesPerPixel: bytesPerPixel,
    );
  }
}
