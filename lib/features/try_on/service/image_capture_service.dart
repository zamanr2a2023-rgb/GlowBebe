import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';
import 'package:glowbebe/features/try_on/painter/makeup_painter.dart';
import 'package:glowbebe/features/try_on/provider/makeup_controller.dart';
import 'package:glowbebe/features/try_on/service/face_detection_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum CaptureStatus { idle, loading, success, error }

class CaptureResult {
  const CaptureResult({
    required this.status,
    this.path,
    this.message,
  });

  final CaptureStatus status;
  final String? path;
  final String? message;
}

class ImageCaptureService {
  ImageCaptureService({FaceDetectionService? faceDetection})
      : _faceDetection = faceDetection ?? FaceDetectionService(),
        _ownsDetector = faceDetection == null;

  ImageCaptureService.withSharedDetector(FaceDetectionService detector)
      : _faceDetection = detector,
        _ownsDetector = false;

  final FaceDetectionService _faceDetection;
  final bool _ownsDetector;

  Future<void> dispose() async {
    if (_ownsDetector) {
      await _faceDetection.dispose();
    }
  }

  /// Gallery permission is best-effort — capture still succeeds with a local file.
  Future<bool> _tryEnsureGalleryPermission() async {
    try {
      if (await Gal.hasAccess(toAlbum: true)) return true;
      if (await Gal.requestAccess(toAlbum: true)) return true;
    } on MissingPluginException {
      return false;
    } catch (_) {
      // Fall through to permission_handler.
    }

    try {
      final photos = await Permission.photos.request();
      final storage = await Permission.storage.request();
      return photos.isGranted || storage.isGranted;
    } catch (_) {
      return false;
    }
  }

  /// Runs face detection on a full-resolution still, paints makeup, saves.
  Future<CaptureResult> renderMakeupAndSave({
    required String photoPath,
    required MakeupController makeup,
  }) async {
    try {
      final landmarks = await _faceDetection.processFile(photoPath);
      final bytes = await File(photoPath).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final original = frame.image;
      final size = Size(
        original.width.toDouble(),
        original.height.toDouble(),
      );

      FaceLandmarks? mapped = landmarks;
      if (landmarks != null && landmarks.imageSize != size) {
        mapped = landmarks.mappedTo(widgetSize: size, mirror: false);
      }

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImage(original, Offset.zero, Paint());

      final wasHidden = makeup.hideMakeup;
      if (wasHidden) makeup.setHideMakeup(false);

      MakeupPainter(
        landmarks: mapped,
        controller: makeup,
      ).paint(canvas, size);

      if (wasHidden) makeup.setHideMakeup(true);

      final picture = recorder.endRecording();
      final composed = await picture.toImage(
        original.width,
        original.height,
      );
      final png = await composed.toByteData(format: ui.ImageByteFormat.png);
      original.dispose();
      composed.dispose();

      if (png == null) {
        return const CaptureResult(
          status: CaptureStatus.error,
          message: 'Could not render the makeup look.',
        );
      }

      final dir = await getApplicationDocumentsDirectory();
      final outPath =
          '${dir.path}/glowbebe_tryon_${DateTime.now().millisecondsSinceEpoch}.png';
      await File(outPath).writeAsBytes(png.buffer.asUint8List(), flush: true);

      final savedToGallery = await _trySaveToGallery(outPath);

      return CaptureResult(
        status: CaptureStatus.success,
        path: outPath,
        message: savedToGallery
            ? 'Look saved to your gallery.'
            : 'Look captured. Restart the app once to enable gallery save.',
      );
    } on GalException catch (e) {
      return CaptureResult(
        status: CaptureStatus.error,
        message: e.type.message,
      );
    } catch (e) {
      return CaptureResult(
        status: CaptureStatus.error,
        message: 'Capture failed: $e',
      );
    }
  }

  Future<bool> _trySaveToGallery(String path) async {
    try {
      await _tryEnsureGalleryPermission();
      await Gal.putImage(path, album: 'GlowBebe');
      return true;
    } on MissingPluginException {
      // Hot-restart won't register new plugins — local file is enough.
      return false;
    } catch (_) {
      return false;
    }
  }
}
