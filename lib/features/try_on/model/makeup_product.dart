import 'package:flutter/material.dart';

enum MakeupCategory {
  lip,
  blush,
  eye,
  foundation,
}

extension MakeupCategoryX on MakeupCategory {
  String get label {
    switch (this) {
      case MakeupCategory.lip:
        return 'LIP';
      case MakeupCategory.blush:
        return 'BLUSH';
      case MakeupCategory.eye:
        return 'EYE';
      case MakeupCategory.foundation:
        return 'FOUNDATION';
    }
  }

  String get shortLabel {
    switch (this) {
      case MakeupCategory.lip:
        return 'LIP';
      case MakeupCategory.blush:
        return 'BLUSH';
      case MakeupCategory.eye:
        return 'EYE';
      case MakeupCategory.foundation:
        return 'FOUNDATION';
    }
  }

  static MakeupCategory fromIndex(int index) {
    return MakeupCategory.values[index.clamp(0, MakeupCategory.values.length - 1)];
  }
}

class MakeupShade {
  const MakeupShade({
    required this.id,
    required this.name,
    required this.color,
  });

  final String id;
  final String name;
  final Color color;
}

class AppliedMakeup {
  const AppliedMakeup({
    required this.category,
    required this.shade,
    required this.intensity,
  });

  final MakeupCategory category;
  final MakeupShade shade;
  final double intensity;
}

class MakeupCatalog {
  MakeupCatalog._();

  static const clearId = 'clear';

  static const lipShades = <MakeupShade>[
    MakeupShade(id: 'rosewood', name: 'ROSEWOOD', color: Color(0xFF9B5C43)),
    MakeupShade(id: 'nude_pink', name: 'NUDE PINK', color: Color(0xFFDFA08E)),
    MakeupShade(id: 'coral_kiss', name: 'CORAL KISS', color: Color(0xFFF2875A)),
    MakeupShade(id: 'berry_mauve', name: 'BERRY MAUVE', color: Color(0xFF9A5068)),
    MakeupShade(id: 'soft_terracotta', name: 'SOFT TERRACOTTA', color: Color(0xFFB8644A)),
  ];

  static const blushShades = <MakeupShade>[
    MakeupShade(id: 'soft_peach', name: 'SOFT PEACH', color: Color(0xFFF28C7A)),
    MakeupShade(id: 'rosy_pink', name: 'ROSY PINK', color: Color(0xFFE8788C)),
    MakeupShade(id: 'coral_bloom', name: 'CORAL BLOOM', color: Color(0xFFF06F5B)),
    MakeupShade(id: 'warm_terracotta', name: 'WARM TERRACOTTA', color: Color(0xFFC96F58)),
    MakeupShade(id: 'berry_rose', name: 'BERRY ROSE', color: Color(0xFFB85F72)),
  ];

  static const eyeShades = <MakeupShade>[
    MakeupShade(id: 'champagne_glow', name: 'CHAMPAGNE GLOW', color: Color(0xFFD8B58A)),
    MakeupShade(id: 'rose_gold', name: 'ROSE GOLD', color: Color(0xFFC98276)),
    MakeupShade(id: 'copper_bronze', name: 'COPPER BRONZE', color: Color(0xFFA96142)),
    MakeupShade(id: 'mauve_mist', name: 'MAUVE MIST', color: Color(0xFF9A6A7B)),
    MakeupShade(id: 'smoky_brown', name: 'SMOKY BROWN', color: Color(0xFF6B4A3A)),
  ];

  static const foundationShades = <MakeupShade>[
    MakeupShade(id: 'warm_sand', name: 'WARM SAND', color: Color(0xFFD8A06F)),
    MakeupShade(id: 'golden_beige', name: 'GOLDEN BEIGE', color: Color(0xFFC98A5B)),
    MakeupShade(id: 'honey_tan', name: 'HONEY TAN', color: Color(0xFFB9784F)),
    MakeupShade(id: 'caramel_glow', name: 'CARAMEL GLOW', color: Color(0xFFA96642)),
    MakeupShade(id: 'mocha_bronze', name: 'MOCHA BRONZE', color: Color(0xFF7B4A35)),
  ];

  static List<MakeupShade> shadesFor(MakeupCategory category) {
    switch (category) {
      case MakeupCategory.lip:
        return lipShades;
      case MakeupCategory.blush:
        return blushShades;
      case MakeupCategory.eye:
        return eyeShades;
      case MakeupCategory.foundation:
        return foundationShades;
    }
  }
}

/// Internal AR placement guides derived from ML Kit contours.
/// Used for makeup alignment — not shown unless debug mode is on.
class FacePlacementMap {
  const FacePlacementMap({
    this.lipOuterBorder = const [],
    this.mouthClosureLine = const [],
    this.cheekboneLine = const [],
    this.contourHollowLine = const [],
    this.jawlineOuter = const [],
    this.underEyeLine = const [],
    this.upperLashLine = const [],
    this.lowerLashLine = const [],
    this.eyeCreaseLine = const [],
    this.browArchLine = const [],
    this.foreheadHairline = const [],
    this.noseBridgeLine = const [],
    this.noseFlankLines = const [],
  });

  final List<Offset> lipOuterBorder;
  final List<Offset> mouthClosureLine;
  final List<Offset> cheekboneLine;
  final List<Offset> contourHollowLine;
  final List<Offset> jawlineOuter;
  final List<Offset> underEyeLine;
  final List<Offset> upperLashLine;
  final List<Offset> lowerLashLine;
  final List<Offset> eyeCreaseLine;
  final List<Offset> browArchLine;
  final List<Offset> foreheadHairline;
  final List<Offset> noseBridgeLine;
  final List<Offset> noseFlankLines;
}

/// Landmark and contour points in image (or widget) space.
class FaceLandmarks {
  const FaceLandmarks({
    required this.imageSize,
    this.faceOval = const [],
    this.upperLipTop = const [],
    this.upperLipBottom = const [],
    this.lowerLipTop = const [],
    this.lowerLipBottom = const [],
    this.leftEye = const [],
    this.rightEye = const [],
    this.leftEyebrow = const [],
    this.rightEyebrow = const [],
    this.leftEyebrowBottom = const [],
    this.rightEyebrowBottom = const [],
    this.leftCheekContour = const [],
    this.rightCheekContour = const [],
    this.noseBridge = const [],
    this.noseBottom = const [],
    this.leftCheek,
    this.rightCheek,
    this.noseBase,
  });

  final Size imageSize;
  final List<Offset> faceOval;
  final List<Offset> upperLipTop;
  final List<Offset> upperLipBottom;
  final List<Offset> lowerLipTop;
  final List<Offset> lowerLipBottom;
  final List<Offset> leftEye;
  final List<Offset> rightEye;
  final List<Offset> leftEyebrow;
  final List<Offset> rightEyebrow;
  final List<Offset> leftEyebrowBottom;
  final List<Offset> rightEyebrowBottom;
  final List<Offset> leftCheekContour;
  final List<Offset> rightCheekContour;
  final List<Offset> noseBridge;
  final List<Offset> noseBottom;
  final Offset? leftCheek;
  final Offset? rightCheek;
  final Offset? noseBase;

  bool get hasFace =>
      faceOval.isNotEmpty ||
      leftEye.isNotEmpty ||
      rightEye.isNotEmpty ||
      upperLipTop.isNotEmpty ||
      lowerLipBottom.isNotEmpty ||
      leftCheek != null ||
      rightCheek != null;

  /// Derived placement lines for accurate AR makeup (internal use).
  FacePlacementMap get placement {
    final lipOuter = <Offset>[
      ...upperLipTop,
      ...lowerLipBottom.reversed,
    ];

    final mouthClosure = <Offset>[
      if (upperLipBottom.isNotEmpty) ...upperLipBottom,
      if (lowerLipTop.isNotEmpty) ...lowerLipTop.reversed,
    ];

    final browArch = <Offset>[
      ...leftEyebrow,
      ...rightEyebrow,
    ];

    final upperLash = <Offset>[
      ..._polylineTopHalf(leftEye),
      ..._polylineTopHalf(rightEye),
    ];
    final lowerLash = <Offset>[
      ..._polylineBottomHalf(leftEye),
      ..._polylineBottomHalf(rightEye),
    ];
    final underEye = lowerLash;

    final crease = <Offset>[
      ..._eyeCrease(leftEye, leftEyebrowBottom.isNotEmpty
          ? leftEyebrowBottom
          : leftEyebrow),
      ..._eyeCrease(rightEye, rightEyebrowBottom.isNotEmpty
          ? rightEyebrowBottom
          : rightEyebrow),
    ];

    final cheekbone = <Offset>[
      ?leftCheek,
      ...leftCheekContour,
      ...rightCheekContour,
      ?rightCheek,
    ];

    final hollow = _contourHollow();
    final jaw = _jawlineSlice();
    final hairline = _foreheadSlice();
    final flanks = _noseFlanks();

    return FacePlacementMap(
      lipOuterBorder: lipOuter,
      mouthClosureLine: mouthClosure,
      cheekboneLine: cheekbone,
      contourHollowLine: hollow,
      jawlineOuter: jaw,
      underEyeLine: underEye,
      upperLashLine: upperLash,
      lowerLashLine: lowerLash,
      eyeCreaseLine: crease,
      browArchLine: browArch,
      foreheadHairline: hairline,
      noseBridgeLine: noseBridge,
      noseFlankLines: flanks,
    );
  }

  List<Offset> _polylineTopHalf(List<Offset> eye) {
    if (eye.length < 3) return const [];
    final midY = eye.map((p) => p.dy).reduce((a, b) => a + b) / eye.length;
    return eye.where((p) => p.dy <= midY + 1).toList(growable: false);
  }

  List<Offset> _polylineBottomHalf(List<Offset> eye) {
    if (eye.length < 3) return const [];
    final midY = eye.map((p) => p.dy).reduce((a, b) => a + b) / eye.length;
    return eye.where((p) => p.dy >= midY - 1).toList(growable: false);
  }

  List<Offset> _eyeCrease(List<Offset> eye, List<Offset> browBottom) {
    if (eye.length < 2) return const [];
    final top = _polylineTopHalf(eye);
    if (top.isEmpty) return const [];
    if (browBottom.length < 2) {
      return top
          .map((p) => Offset(p.dx, p.dy - 6))
          .toList(growable: false);
    }
    final browY =
        browBottom.map((p) => p.dy).reduce((a, b) => a + b) / browBottom.length;
    return top
        .map((p) => Offset(p.dx, (p.dy + browY) / 2))
        .toList(growable: false);
  }

  List<Offset> _contourHollow() {
    if (faceOval.length < 6) return const [];
    final sorted = [...faceOval]..sort((a, b) => a.dy.compareTo(b.dy));
    final start = (sorted.length * 0.45).floor();
    final end = (sorted.length * 0.78).ceil().clamp(start + 1, sorted.length);
    final band = sorted.sublist(start, end);
    final cx = faceOval.map((p) => p.dx).reduce((a, b) => a + b) / faceOval.length;
    final left = band.where((p) => p.dx < cx).toList()
      ..sort((a, b) => a.dy.compareTo(b.dy));
    final right = band.where((p) => p.dx >= cx).toList()
      ..sort((a, b) => a.dy.compareTo(b.dy));
    return [
      ...left.map((p) => Offset(p.dx + (cx - p.dx) * 0.22, p.dy)),
      ...right.map((p) => Offset(p.dx - (p.dx - cx) * 0.22, p.dy)),
    ];
  }

  List<Offset> _jawlineSlice() {
    if (faceOval.length < 6) return const [];
    final sorted = [...faceOval]..sort((a, b) => a.dy.compareTo(b.dy));
    final start = (sorted.length * 0.55).floor();
    return sorted.sublist(start);
  }

  List<Offset> _foreheadSlice() {
    if (faceOval.length < 6) return const [];
    final sorted = [...faceOval]..sort((a, b) => a.dy.compareTo(b.dy));
    final end = (sorted.length * 0.22).ceil().clamp(2, sorted.length);
    return sorted.sublist(0, end)..sort((a, b) => a.dx.compareTo(b.dx));
  }

  List<Offset> _noseFlanks() {
    if (noseBottom.isEmpty && noseBridge.isEmpty) return const [];
    final pts = <Offset>[...noseBridge, ...noseBottom];
    if (pts.length < 2) return pts;
    pts.sort((a, b) => a.dx.compareTo(b.dx));
    return [pts.first, pts.last];
  }

  FaceLandmarks mappedTo({
    required Size widgetSize,
    required bool mirror,
  }) {
    Offset map(Offset p) {
      final fitted = applyBoxFit(BoxFit.cover, imageSize, widgetSize);
      final output = fitted.destination;
      final dx = (widgetSize.width - output.width) / 2;
      final dy = (widgetSize.height - output.height) / 2;
      final sx = output.width / imageSize.width;
      final sy = output.height / imageSize.height;
      var x = p.dx * sx + dx;
      final y = p.dy * sy + dy;
      if (mirror) {
        x = widgetSize.width - x;
      }
      return Offset(x, y);
    }

    List<Offset> mapAll(List<Offset> pts) =>
        pts.map(map).toList(growable: false);

    return FaceLandmarks(
      imageSize: widgetSize,
      faceOval: mapAll(faceOval),
      upperLipTop: mapAll(upperLipTop),
      upperLipBottom: mapAll(upperLipBottom),
      lowerLipTop: mapAll(lowerLipTop),
      lowerLipBottom: mapAll(lowerLipBottom),
      leftEye: mapAll(leftEye),
      rightEye: mapAll(rightEye),
      leftEyebrow: mapAll(leftEyebrow),
      rightEyebrow: mapAll(rightEyebrow),
      leftEyebrowBottom: mapAll(leftEyebrowBottom),
      rightEyebrowBottom: mapAll(rightEyebrowBottom),
      leftCheekContour: mapAll(leftCheekContour),
      rightCheekContour: mapAll(rightCheekContour),
      noseBridge: mapAll(noseBridge),
      noseBottom: mapAll(noseBottom),
      leftCheek: leftCheek == null ? null : map(leftCheek!),
      rightCheek: rightCheek == null ? null : map(rightCheek!),
      noseBase: noseBase == null ? null : map(noseBase!),
    );
  }
}

/// Result of still-image face analysis.
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
