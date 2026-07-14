import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class StillFaceResult {
  const StillFaceResult({
    required this.landmarks,
    required this.displayPath,
    required this.imageSize,
  });

  final FaceLandmarks? landmarks;
  final String displayPath;
  final Size imageSize;
}

class FaceDetectionService {
  FaceDetectionService({FaceDetector? detector})
      : _detector = detector ??
            FaceDetector(
              options: FaceDetectorOptions(
                performanceMode: FaceDetectorMode.accurate,
                enableContours: true,
                enableLandmarks: true,
                enableClassification: false,
                enableTracking: false,
                minFaceSize: 0.1,
              ),
            );

  final FaceDetector _detector;
  bool _busy = false;

  bool get isBusy => _busy;

  Future<void> dispose() => _detector.close();

  /// Process a camera stream frame. Returns null if busy or no face.
  Future<FaceLandmarks?> processCameraImage({
    required CameraImage image,
    required CameraController controller,
  }) async {
    if (_busy) return null;
    _busy = true;
    try {
      final input = inputImageFromCamera(image, controller);
      if (input == null) return null;
      return await _detect(
        input,
        fromStream: true,
        cameraImage: image,
      );
    } finally {
      _busy = false;
    }
  }

  /// Still-image detection — returns landmarks + upright display path so the
  /// painted makeup uses the exact same bitmap ML Kit analyzed.
  Future<StillFaceResult?> analyzeStill(String path) async {
    final pngPath = await _rewriteAsPng(path);
    final displayPath = pngPath ?? path;
    final size = await _decodedImageSize(displayPath);
    if (size == null) return null;

    final landmarks = await _detect(
      InputImage.fromFilePath(displayPath),
      fromStream: false,
      cameraImage: null,
      fallbackSize: size,
    );

    return StillFaceResult(
      landmarks: landmarks,
      displayPath: displayPath,
      imageSize: size,
    );
  }

  /// Convenience for capture compositing (temp PNG cleaned by caller if needed).
  Future<FaceLandmarks?> processFile(String path) async {
    final still = await analyzeStill(path);
    return still?.landmarks;
  }

  Future<Size?> _decodedImageSize(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final size = Size(
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );
      frame.image.dispose();
      return size;
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
        '${Directory.systemTemp.path}/glowbebe_mlkit_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await out.writeAsBytes(png.buffer.asUint8List(), flush: true);
      return out.path;
    } catch (_) {
      return null;
    }
  }

  Future<FaceLandmarks?> processBytes({
    required Uint8List bytes,
    required int width,
    required int height,
    required InputImageRotation rotation,
    required InputImageFormat format,
    required int bytesPerRow,
  }) async {
    final input = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(width.toDouble(), height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: bytesPerRow,
      ),
    );
    return _detect(
      input,
      fromStream: false,
      cameraImage: null,
      fallbackSize: Size(width.toDouble(), height.toDouble()),
    );
  }

  Future<FaceLandmarks?> _detect(
    InputImage input, {
    required bool fromStream,
    CameraImage? cameraImage,
    Size? fallbackSize,
  }) async {
    final faces = await _detector.processImage(input);
    if (faces.isEmpty) return null;

    final face = faces.first;
    final rawSize = input.metadata?.size;
    Size imageSize;
    if (rawSize != null) {
      final rot = input.metadata?.rotation ?? InputImageRotation.rotation0deg;
      final swapped = rot == InputImageRotation.rotation90deg ||
          rot == InputImageRotation.rotation270deg;
      imageSize = fromStream && Platform.isAndroid && swapped
          ? Size(rawSize.height, rawSize.width)
          : Size(rawSize.width, rawSize.height);
    } else if (fallbackSize != null) {
      // fromFilePath has no metadata — use decoded pixel size.
      imageSize = fallbackSize;
    } else if (cameraImage != null) {
      imageSize = Size(
        cameraImage.width.toDouble(),
        cameraImage.height.toDouble(),
      );
    } else {
      imageSize = const Size(1, 1);
    }

    return _landmarksFromFace(face, imageSize);
  }

  FaceLandmarks _landmarksFromFace(Face face, Size imageSize) {
    List<Offset> contour(FaceContourType type) {
      final c = face.contours[type];
      if (c == null) return const [];
      return c.points
          .map((p) => Offset(p.x.toDouble(), p.y.toDouble()))
          .toList(growable: false);
    }

    Offset? landmark(FaceLandmarkType type) {
      final l = face.landmarks[type];
      if (l == null) return null;
      return Offset(l.position.x.toDouble(), l.position.y.toDouble());
    }

    return FaceLandmarks(
      imageSize: imageSize,
      faceOval: contour(FaceContourType.face),
      upperLipTop: contour(FaceContourType.upperLipTop),
      upperLipBottom: contour(FaceContourType.upperLipBottom),
      lowerLipTop: contour(FaceContourType.lowerLipTop),
      lowerLipBottom: contour(FaceContourType.lowerLipBottom),
      leftEye: contour(FaceContourType.leftEye),
      rightEye: contour(FaceContourType.rightEye),
      leftEyebrow: contour(FaceContourType.leftEyebrowTop),
      rightEyebrow: contour(FaceContourType.rightEyebrowTop),
      noseBridge: contour(FaceContourType.noseBridge),
      noseBottom: contour(FaceContourType.noseBottom),
      leftCheek: landmark(FaceLandmarkType.leftCheek),
      rightCheek: landmark(FaceLandmarkType.rightCheek),
      noseBase: landmark(FaceLandmarkType.noseBase),
    );
  }

  static InputImage? inputImageFromCamera(
    CameraImage image,
    CameraController controller,
  ) {
    final rotation = imageRotationFor(controller);
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

    final builder = BytesBuilder(copy: false);
    for (final plane in image.planes) {
      builder.add(plane.bytes);
    }
    return InputImage.fromBytes(
      bytes: builder.takeBytes(),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  static InputImageRotation? imageRotationFor(CameraController controller) {
    final sensorOrientation = controller.description.sensorOrientation;

    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }

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
}
