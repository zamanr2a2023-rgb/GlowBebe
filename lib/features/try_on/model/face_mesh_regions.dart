import 'dart:ui';

import 'package:mediapipe_face_mesh/mediapipe_face_mesh.dart';

/// Canonical MediaPipe Face Mesh landmark index sets for makeup regions.
///
/// Indices follow the standard 468-point topology (478 with iris/attention).
class FaceMeshRegions {
  FaceMeshRegions._();

  /// Face oval / silhouette.
  static const List<int> faceOval = [
    10, 338, 297, 332, 284, 251, 389, 356, 454, 323, 361, 288, 397, 365, 379,
    378, 400, 377, 152, 148, 176, 149, 150, 136, 172, 58, 132, 93, 234, 127,
    162, 21, 54, 103, 67, 109,
  ];

  /// Upper lip outer border (top of upper lip).
  static const List<int> upperLipTop = [
    61, 185, 40, 39, 37, 0, 267, 269, 270, 409, 291,
  ];

  /// Upper lip inner border (mouth closure, upper side).
  static const List<int> upperLipBottom = [
    78, 191, 80, 81, 82, 13, 312, 311, 310, 415, 308,
  ];

  /// Lower lip inner border (mouth closure, lower side).
  static const List<int> lowerLipTop = [
    78, 95, 88, 178, 87, 14, 317, 402, 318, 324, 308,
  ];

  /// Lower lip outer border (bottom of lower lip).
  static const List<int> lowerLipBottom = [
    146, 91, 181, 84, 17, 314, 405, 321, 375, 291,
  ];

  static const List<int> leftEye = [
    33, 7, 163, 144, 145, 153, 154, 155, 133, 173, 157, 158, 159, 160, 161, 246,
  ];

  static const List<int> rightEye = [
    362, 382, 381, 380, 374, 373, 390, 249, 263, 466, 388, 387, 386, 385, 384,
    398,
  ];

  static const List<int> leftEyebrowTop = [
    70, 63, 105, 66, 107,
  ];

  static const List<int> leftEyebrowBottom = [
    46, 53, 52, 65, 55,
  ];

  static const List<int> rightEyebrowTop = [
    300, 293, 334, 296, 336,
  ];

  static const List<int> rightEyebrowBottom = [
    276, 283, 282, 295, 285,
  ];

  static const List<int> noseBridge = [168, 6, 197, 195, 5];

  static const List<int> noseBottom = [98, 97, 2, 326, 327];

  static const List<int> leftCheekContour = [50, 101, 118, 117, 123, 147, 213];

  static const List<int> rightCheekContour = [
    280, 330, 347, 346, 352, 376, 433,
  ];

  static const int leftCheek = 50;
  static const int rightCheek = 280;
  static const int noseBase = 2;

  /// Forehead / hairline (upper oval + mid-forehead points only).
  static const List<int> foreheadHairline = [
    10, 151, 9, 8,
    109, 67, 103, 54,
    338, 297, 332, 284,
  ];

  /// Jawline (lower oval).
  static const List<int> jawline = [
    172, 136, 150, 149, 176, 148, 152, 377, 400, 378, 379, 365, 397, 288,
  ];

  static List<Offset> pick(
    List<Offset> all,
    List<int> indices,
  ) {
    final out = <Offset>[];
    for (final i in indices) {
      if (i >= 0 && i < all.length) out.add(all[i]);
    }
    return out;
  }

  static Offset? pickOne(List<Offset> all, int index) {
    if (index < 0 || index >= all.length) return null;
    return all[index];
  }

  /// Converts a [FaceMeshResult] into pixel-space offsets.
  ///
  /// After inference with [rotationDegrees] applied in the pipeline, pass
  /// `mapRotationDegrees: 0` (landmarks are already in display orientation).
  static List<Offset> offsetsFromResult(
    FaceMeshResult result, {
    int mapRotationDegrees = 0,
    bool mirrorHorizontal = false,
    Size? targetSize,
  }) {
    return result.landmarksAsOffsets(
      targetSize: targetSize ??
          Size(result.imageWidth.toDouble(), result.imageHeight.toDouble()),
      rotationDegrees: mapRotationDegrees,
      mirrorHorizontal: mirrorHorizontal,
      clampToBounds: true,
    );
  }
}
