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

    List<Offset> mapAll(List<Offset> pts) => pts.map(map).toList(growable: false);

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
      noseBridge: mapAll(noseBridge),
      noseBottom: mapAll(noseBottom),
      leftCheek: leftCheek == null ? null : map(leftCheek!),
      rightCheek: rightCheek == null ? null : map(rightCheek!),
      noseBase: noseBase == null ? null : map(noseBase!),
    );
  }
}
