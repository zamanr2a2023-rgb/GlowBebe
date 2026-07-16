import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';
import 'package:glowbebe/features/try_on/provider/makeup_controller.dart';

class MakeupPainter extends CustomPainter {
  MakeupPainter({
    required this.landmarks,
    required this.controller,
  }) : super(repaint: controller);

  final FaceLandmarks? landmarks;
  final MakeupController controller;

  @override
  void paint(Canvas canvas, Size size) {
    if (controller.hideMakeup && !controller.debugLandmarks) return;
    final raw = landmarks;
    if (raw == null || !raw.hasFace) return;

    final lm = raw.imageSize == size
        ? raw
        : raw.mappedTo(widgetSize: size, mirror: false);

    if (!controller.hideMakeup) {
      // Foundation → blush → eyes → lips (no separate beauty base mask).
      _paintFoundation(canvas, lm);
      _paintBlush(canvas, lm);
      _paintEyes(canvas, lm);
      _paintLips(canvas, lm);
    }

    if (controller.debugLandmarks) {
      _paintDebugPlacement(canvas, lm);
    }
  }

  void _paintFoundation(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.foundation);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.foundation);
    if (intensity <= 0.01) return;

    final facePath = _skinMask(lm, punchLips: true, punchEyes: true);
    if (facePath == null) return;

    final bounds = facePath.getBounds();
    final layerBounds = bounds.inflate(6);
    canvas.saveLayer(layerBounds, Paint());
    canvas.clipPath(facePath);

    // Soft top fade: hides the hard kopal cut without spilling into hair.
    final topFade = bounds.top;
    final fadeEnd = bounds.top + bounds.height * 0.18;
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(bounds.center.dx, topFade),
        Offset(bounds.center.dx, fadeEnd),
        [
          shade.color.withValues(alpha: 0.0),
          shade.color.withValues(alpha: 0.22 * intensity),
          shade.color.withValues(alpha: 0.34 * intensity),
        ],
        const [0.0, 0.35, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver;
    canvas.drawPath(facePath, paint);

    // Mid/lower face — even coverage.
    canvas.drawPath(
      facePath,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(bounds.center.dx, fadeEnd),
          Offset(bounds.center.dx, bounds.bottom),
          [
            shade.color.withValues(alpha: 0.28 * intensity),
            shade.color.withValues(alpha: 0.32 * intensity),
            shade.color.withValues(alpha: 0.26 * intensity),
          ],
          const [0.0, 0.55, 1.0],
        )
        ..blendMode = BlendMode.softLight,
    );

    canvas.restore();
  }

  void _paintBlush(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.blush);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.blush);
    final cheeks = _cheekCenters(lm);
    if (cheeks.isEmpty) return;

    final faceBounds = _bounds(lm.faceOval) ?? _estimateFaceBounds(lm);
    final radius = faceBounds == null
        ? 48.0
        : (faceBounds.width * 0.16).clamp(36.0, 68.0);

    final clip = _skinMask(lm, punchLips: true, punchEyes: true);
    final map = lm.placement;

    for (final center in cheeks) {
      var paintAt = center;
      if (map.cheekboneLine.isNotEmpty) {
        Offset? nearest;
        var best = double.infinity;
        for (final p in map.cheekboneLine) {
          final d = (p - center).distanceSquared;
          if (d < best) {
            best = d;
            nearest = p;
          }
        }
        if (nearest != null) {
          paintAt = Offset(
            (center.dx * 0.55) + (nearest.dx * 0.45),
            (center.dy * 0.6) + (nearest.dy * 0.4),
          );
        }
      }

      canvas.save();
      if (clip != null) canvas.clipPath(clip);

      final glow = Paint()
        ..shader = ui.Gradient.radial(
          paintAt,
          radius,
          [
            shade.color.withValues(alpha: 0.42 * intensity),
            shade.color.withValues(alpha: 0.18 * intensity),
            shade.color.withValues(alpha: 0.0),
          ],
          const [0.0, 0.45, 1.0],
        )
        ..blendMode = BlendMode.softLight;
      canvas.drawCircle(paintAt, radius, glow);
      canvas.restore();
    }
  }

  void _paintEyes(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.eye);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.eye);
    final leftBrow = lm.leftEyebrowBottom.isNotEmpty
        ? lm.leftEyebrowBottom
        : lm.leftEyebrow;
    final rightBrow = lm.rightEyebrowBottom.isNotEmpty
        ? lm.rightEyebrowBottom
        : lm.rightEyebrow;
    _paintEyeShadow(canvas, lm.leftEye, leftBrow, shade, intensity);
    _paintEyeShadow(canvas, lm.rightEye, rightBrow, shade, intensity);
  }

  void _paintEyeShadow(
    Canvas canvas,
    List<Offset> eye,
    List<Offset> brow,
    MakeupShade shade,
    double intensity,
  ) {
    final lid = _eyelidPath(eye, brow);
    if (lid == null) return;

    final eyeBounds = _bounds(eye);
    if (eyeBounds == null) return;

    canvas.save();
    canvas.clipPath(lid);

    final top = lid.getBounds().top;
    canvas.drawPath(
      lid,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(eyeBounds.center.dx, top),
          Offset(eyeBounds.center.dx, eyeBounds.top + eyeBounds.height * 0.15),
          [
            shade.color.withValues(alpha: 0.58 * intensity),
            shade.color.withValues(alpha: 0.28 * intensity),
            shade.color.withValues(alpha: 0.0),
          ],
          const [0.0, 0.55, 1.0],
        )
        ..blendMode = BlendMode.srcOver
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );

    // Crease definition along the top of the lid band.
    final creasePts = _eyelidCreaseLine(eye, brow);
    if (creasePts.length >= 2) {
      final crease = Path()..moveTo(creasePts.first.dx, creasePts.first.dy);
      for (var i = 1; i < creasePts.length; i++) {
        crease.lineTo(creasePts[i].dx, creasePts[i].dy);
      }
      canvas.drawPath(
        crease,
        Paint()
          ..color = shade.color.withValues(alpha: 0.4 * intensity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
          ..blendMode = BlendMode.srcOver,
      );
    }

    // Upper lash line — mesh contour, not eyeball fill.
    final midY = eye.map((p) => p.dy).reduce((a, b) => a + b) / eye.length;
    final lashPts = eye.where((p) => p.dy <= midY + 1).toList()
      ..sort((a, b) => a.dx.compareTo(b.dx));
    if (lashPts.length >= 2) {
      final lash = Path()..moveTo(lashPts.first.dx, lashPts.first.dy);
      for (var i = 1; i < lashPts.length; i++) {
        lash.lineTo(lashPts[i].dx, lashPts[i].dy);
      }
      canvas.drawPath(
        lash,
        Paint()
          ..color = shade.color.withValues(alpha: 0.45 * intensity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..blendMode = BlendMode.srcOver,
      );
    }

    canvas.restore();
  }

  /// Eyelid band: upper lash → crease (below brow). Never covers the iris.
  Path? _eyelidPath(List<Offset> eye, List<Offset> brow) {
    if (eye.length < 4) return null;
    final eyeBounds = _bounds(eye);
    if (eyeBounds == null || eyeBounds.width < 2) return null;

    final midY = eye.map((p) => p.dy).reduce((a, b) => a + b) / eye.length;
    final upper = eye.where((p) => p.dy <= midY + 0.8).toList()
      ..sort((a, b) => a.dx.compareTo(b.dx));
    if (upper.length < 2) return null;

    final crease = _eyelidCreaseLine(eye, brow);
    if (crease.length < 2) return null;

    final path = Path()..moveTo(upper.first.dx, upper.first.dy);
    for (var i = 1; i < upper.length; i++) {
      path.lineTo(upper[i].dx, upper[i].dy);
    }
    for (var i = crease.length - 1; i >= 0; i--) {
      path.lineTo(crease[i].dx, crease[i].dy);
    }
    path.close();
    return path;
  }

  List<Offset> _eyelidCreaseLine(List<Offset> eye, List<Offset> brow) {
    if (eye.length < 4) return const [];
    final midY = eye.map((p) => p.dy).reduce((a, b) => a + b) / eye.length;
    final upper = eye.where((p) => p.dy <= midY + 0.8).toList()
      ..sort((a, b) => a.dx.compareTo(b.dx));
    if (upper.isEmpty) return const [];

    final eyeBounds = _bounds(eye)!;
    double browBottom;
    if (brow.length >= 2) {
      browBottom = brow.map((p) => p.dy).reduce(math.max);
    } else {
      browBottom = eyeBounds.top - eyeBounds.height * 0.85;
    }

    // Keep crease between brow and upper lash (lid only).
    return [
      for (final p in upper)
        () {
          final y = browBottom * 0.35 + p.dy * 0.65;
          final lo = math.min(browBottom + 1.0, p.dy - 1.0);
          final hi = math.max(browBottom + 1.0, p.dy - 1.0);
          return Offset(p.dx, y.clamp(lo, hi));
        }(),
    ];
  }

  void _paintLips(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.lip);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.lip);

    // Mesh-precise lip fill — stay inside outer border (no inflate overflow).
    final upper = _smoothLipBand(lm.upperLipTop, lm.upperLipBottom, inflate: 0);
    final lower = _smoothLipBand(lm.lowerLipTop, lm.lowerLipBottom, inflate: 0);
    final full = _lipCombinedPath(lm, inflate: 0);
    if (full == null && upper == null && lower == null) return;

    final clipPath = full ??
        (upper != null && lower != null
            ? Path.combine(PathOperation.union, upper, lower)
            : upper ?? lower!);
    final bounds = clipPath.getBounds();

    canvas.save();
    canvas.clipPath(clipPath);

    // Soft multiply base so lipstick blends into natural lip texture.
    canvas.drawPath(
      clipPath,
      Paint()
        ..color = shade.color.withValues(alpha: 0.42 * intensity)
        ..blendMode = BlendMode.multiply
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
    );

    final body = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver
      ..shader = ui.Gradient.linear(
        Offset(bounds.center.dx, bounds.top),
        Offset(bounds.center.dx, bounds.bottom),
        [
          Color.lerp(Colors.white, shade.color, 0.55)!
              .withValues(alpha: 0.55 * intensity),
          shade.color.withValues(alpha: 0.62 * intensity),
          Color.lerp(shade.color, const Color(0xFF4A2020), 0.18)!
              .withValues(alpha: 0.58 * intensity),
        ],
        const [0.0, 0.48, 1.0],
      );

    if (upper != null) canvas.drawPath(upper, body);
    if (lower != null) canvas.drawPath(lower, body);

    // SoftLight glaze for natural sheen.
    canvas.drawPath(
      clipPath,
      Paint()
        ..color = shade.color.withValues(alpha: 0.28 * intensity)
        ..blendMode = BlendMode.softLight
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Mouth closure line for natural lip split.
    final closure = lm.placement.mouthClosureLine;
    if (closure.length >= 2) {
      final mid = Path()..moveTo(closure.first.dx, closure.first.dy);
      for (var i = 1; i < closure.length; i++) {
        mid.lineTo(closure[i].dx, closure[i].dy);
      }
      canvas.drawPath(
        mid,
        Paint()
          ..color = Color.lerp(shade.color, const Color(0xFF3A1818), 0.45)!
              .withValues(alpha: 0.32 * intensity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8)
          ..blendMode = BlendMode.srcOver,
      );
    }

    if (lm.upperLipTop.length >= 3) {
      final pts = _sampleSmooth(lm.upperLipTop, steps: 18);
      if (pts.isNotEmpty) {
        final highlight = Path()..moveTo(pts.first.dx, pts.first.dy + 1.0);
        for (var i = 1; i < pts.length; i++) {
          highlight.lineTo(pts[i].dx, pts[i].dy + 1.0);
        }
        canvas.drawPath(
          highlight,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.22 * intensity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.8
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2)
            ..blendMode = BlendMode.softLight,
        );
      }
    }

    canvas.restore();
  }

  void _paintDebugPlacement(Canvas canvas, FaceLandmarks lm) {
    final map = lm.placement;
    void stroke(List<Offset> pts, Color color, {double width = 1.5}) {
      if (pts.length < 2) return;
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (var i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    stroke(map.lipOuterBorder, const Color(0xFFFF4D6D), width: 2);
    stroke(map.mouthClosureLine, const Color(0xFFFF8FAB));
    stroke(map.cheekboneLine, const Color(0xFFFFB703));
    stroke(map.contourHollowLine, const Color(0xFFFB8500));
    stroke(map.jawlineOuter, const Color(0xFF8ECAE6));
    stroke(map.underEyeLine, const Color(0xFF90E0EF));
    stroke(map.upperLashLine, const Color(0xFF48CAE4));
    stroke(map.lowerLashLine, const Color(0xFF00B4D8));
    stroke(map.eyeCreaseLine, const Color(0xFF0077B6));
    stroke(map.browArchLine, const Color(0xFF9B5DE5));
    stroke(map.foreheadHairline, const Color(0xFF80ED99));
    stroke(map.noseBridgeLine, const Color(0xFFF72585));
    stroke(map.noseFlankLines, const Color(0xFFB5179E));
  }

  /// Tight skin silhouette for foundation/beauty — face only, no background halo.
  ///
  /// Mild forehead lift (capped) so coverage reaches under the hairline without
  /// spilling onto hair, ears, or walls. Eyes and lips are punched out.
  Path? _skinMask(
    FaceLandmarks lm, {
    bool punchLips = true,
    bool punchEyes = true,
  }) {
    final skin = _tightFaceSilhouette(lm);
    if (skin == null) {
      return _faceMask(lm, punchLips: punchLips, punchEyes: punchEyes);
    }

    Path mask = skin;
    if (punchEyes) {
      for (final eye in [lm.leftEye, lm.rightEye]) {
        // Slight inflate so foundation never paints the eyeball.
        final eyePath = _closedPath(eye, inflate: 1.5);
        if (eyePath != null) {
          mask = Path.combine(PathOperation.difference, mask, eyePath);
        }
      }
    }
    if (punchLips) {
      final lips = _lipCombinedPath(lm, inflate: 1);
      if (lips != null) {
        mask = Path.combine(PathOperation.difference, mask, lips);
      }
    }
    return mask;
  }

  Path? _tightFaceSilhouette(FaceLandmarks lm) {
    final oval = lm.faceOval;
    if (oval.length < 6) {
      final bounds = _estimateFaceBounds(lm);
      if (bounds == null) return null;
      return Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(
              bounds.center.dx,
              bounds.center.dy - bounds.height * 0.02,
            ),
            width: bounds.width * 1.01,
            height: bounds.height * 1.06,
          ),
        );
    }

    final bounds = _bounds(oval);
    if (bounds == null || bounds.height < 8) return null;

    final h = bounds.height;
    final cx = bounds.center.dx;
    // Raise only the crown toward kopal (~12%), pull temples slightly inward
    // so sides don't sit on hair.
    const liftFactor = 0.12;
    final expanded = <Offset>[];
    for (final p in oval) {
      final t = ((bounds.bottom - p.dy) / h).clamp(0.0, 1.0);
      final w = t < 0.50 ? 0.0 : math.pow((t - 0.50) / 0.50, 1.15).toDouble();
      final up = h * liftFactor * w;
      final inward = (p.dx - cx) * (-0.03 * w);
      expanded.add(Offset(p.dx + inward, p.dy - up));
    }

    final smooth = _sampleSmooth(expanded, steps: 48);
    if (smooth.length < 3) return null;

    final path = Path()..moveTo(smooth.first.dx, smooth.first.dy);
    for (var i = 1; i < smooth.length; i++) {
      path.lineTo(smooth[i].dx, smooth[i].dy);
    }
    path.close();
    return path;
  }

  /// Face oval with optional eye / lip holes.
  Path? _faceMask(
    FaceLandmarks lm, {
    bool punchLips = true,
    bool punchEyes = true,
  }) {
    Path? facePath = _closedPath(lm.faceOval);
    facePath ??= () {
      final bounds = _estimateFaceBounds(lm);
      if (bounds == null) return null;
      return Path()..addOval(bounds.inflate(bounds.width * 0.02));
    }();
    if (facePath == null) return null;

    Path mask = facePath;
    if (punchEyes) {
      for (final eye in [lm.leftEye, lm.rightEye]) {
        final eyePath = _closedPath(eye, inflate: 1.5);
        if (eyePath != null) {
          mask = Path.combine(PathOperation.difference, mask, eyePath);
        }
      }
    }
    if (punchLips) {
      final lips = _lipCombinedPath(lm);
      if (lips != null) {
        mask = Path.combine(PathOperation.difference, mask, lips);
      }
    }
    return mask;
  }

  Path? _lipCombinedPath(FaceLandmarks lm, {double inflate = 0}) {
    final upper = _smoothLipBand(
      lm.upperLipTop,
      lm.upperLipBottom,
      inflate: inflate,
    );
    final lower = _smoothLipBand(
      lm.lowerLipTop,
      lm.lowerLipBottom,
      inflate: inflate,
    );
    if (upper == null && lower == null) return null;
    if (upper == null) return lower;
    if (lower == null) return upper;
    return Path.combine(PathOperation.union, upper, lower);
  }

  Path? _smoothLipBand(
    List<Offset> outer,
    List<Offset> inner, {
    double inflate = 0,
  }) {
    if (outer.length < 2) return null;
    final outerSmooth = _sampleSmooth(outer, steps: 24);
    final innerSmooth = inner.length < 2
        ? <Offset>[]
        : _sampleSmooth(inner.reversed.toList(growable: false), steps: 24);

    final path = Path()..moveTo(outerSmooth.first.dx, outerSmooth.first.dy);
    for (var i = 1; i < outerSmooth.length; i++) {
      path.lineTo(outerSmooth[i].dx, outerSmooth[i].dy);
    }
    if (innerSmooth.isEmpty) {
      path.close();
    } else {
      for (final p in innerSmooth) {
        path.lineTo(p.dx, p.dy);
      }
      path.close();
    }

    if (inflate <= 0) return path;
    final bounds = path.getBounds();
    if (bounds.width <= 0 || bounds.height <= 0) return path;
    final cx = bounds.center.dx;
    final cy = bounds.center.dy;
    final sx = (bounds.width + inflate * 2) / bounds.width;
    final sy = (bounds.height + inflate * 2) / bounds.height;
    final matrix = Matrix4.identity()
      ..translateByDouble(cx, cy, 0, 1)
      ..scaleByDouble(sx, sy, 1, 1)
      ..translateByDouble(-cx, -cy, 0, 1);
    return path.transform(matrix.storage);
  }

  List<Offset> _sampleSmooth(List<Offset> points, {required int steps}) {
    if (points.length < 2) return points;
    if (points.length == 2) return points;
    final out = <Offset>[];
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i == 0 ? i : i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[i + 2 < points.length ? i + 2 : i + 1];
      final segs = math.max(1, steps ~/ (points.length - 1));
      for (var s = 0; s < segs; s++) {
        final t = s / segs;
        out.add(_catmullRom(p0, p1, p2, p3, t));
      }
    }
    out.add(points.last);
    return out;
  }

  Offset _catmullRom(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;
    return Offset(
      0.5 *
          ((2 * p1.dx) +
              (-p0.dx + p2.dx) * t +
              (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * t2 +
              (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * t3),
      0.5 *
          ((2 * p1.dy) +
              (-p0.dy + p2.dy) * t +
              (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * t2 +
              (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * t3),
    );
  }

  Path? _closedPath(List<Offset> points, {double inflate = 0}) {
    if (points.length < 3) return null;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    if (inflate <= 0) return path;
    final bounds = path.getBounds();
    if (bounds.width <= 0 || bounds.height <= 0) return path;
    final cx = bounds.center.dx;
    final cy = bounds.center.dy;
    final sx = (bounds.width + inflate * 2) / bounds.width;
    final sy = (bounds.height + inflate * 2) / bounds.height;
    final matrix = Matrix4.identity()
      ..translateByDouble(cx, cy, 0, 1)
      ..scaleByDouble(sx, sy, 1, 1)
      ..translateByDouble(-cx, -cy, 0, 1);
    return path.transform(matrix.storage);
  }

  List<Offset> _cheekCenters(FaceLandmarks lm) {
    // Prefer geometric cheeks from face/eyes — ML Kit cheek points sit too
    // close to the nose and look wrong / invisible.
    final face = _bounds(lm.faceOval) ?? _estimateFaceBounds(lm);
    if (face == null) {
      if (lm.leftCheek != null && lm.rightCheek != null) {
        return [lm.leftCheek!, lm.rightCheek!];
      }
      return const [];
    }

    final nose = lm.noseBase ??
        (lm.noseBottom.isNotEmpty
            ? lm.noseBottom[lm.noseBottom.length ~/ 2]
            : Offset(face.center.dx, face.center.dy + face.height * 0.05));

    final mouthY = () {
      final lips = [...lm.upperLipTop, ...lm.lowerLipBottom];
      if (lips.isEmpty) return nose.dy + face.height * 0.12;
      final sum = lips.fold<double>(0, (a, b) => a + b.dy);
      return sum / lips.length;
    }();

    final y = (nose.dy + mouthY) / 2;
    final dx = face.width * 0.28;

    var left = Offset(nose.dx - dx, y);
    var right = Offset(nose.dx + dx, y);

    // Nudge from detector cheek points when present.
    if (lm.leftCheek != null) {
      left = Offset(
        (left.dx * 0.45) + (lm.leftCheek!.dx * 0.55),
        (left.dy * 0.55) + (lm.leftCheek!.dy * 0.45),
      );
    }
    if (lm.rightCheek != null) {
      right = Offset(
        (right.dx * 0.45) + (lm.rightCheek!.dx * 0.55),
        (right.dy * 0.55) + (lm.rightCheek!.dy * 0.45),
      );
    }

    return [left, right];
  }

  Rect? _estimateFaceBounds(FaceLandmarks lm) {
    final pts = <Offset>[
      ...lm.faceOval,
      ...lm.leftEye,
      ...lm.rightEye,
      ...lm.upperLipTop,
      ...lm.lowerLipBottom,
      ...lm.leftEyebrow,
      ...lm.rightEyebrow,
      if (lm.leftCheek != null) lm.leftCheek!,
      if (lm.rightCheek != null) lm.rightCheek!,
      if (lm.noseBase != null) lm.noseBase!,
    ];
    final box = _bounds(pts);
    if (box == null) return null;
    return Rect.fromCenter(
      center: box.center,
      width: box.width * 1.35,
      height: box.height * 1.55,
    );
  }

  Rect? _bounds(List<Offset> points) {
    if (points.isEmpty) return null;
    var minX = points.first.dx;
    var maxX = points.first.dx;
    var minY = points.first.dy;
    var maxY = points.first.dy;
    for (final p in points) {
      minX = math.min(minX, p.dx);
      maxX = math.max(maxX, p.dx);
      minY = math.min(minY, p.dy);
      maxY = math.max(maxY, p.dy);
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  bool shouldRepaint(covariant MakeupPainter oldDelegate) {
    return oldDelegate.landmarks != landmarks ||
        oldDelegate.controller != controller ||
        oldDelegate.controller.hideMakeup != controller.hideMakeup ||
        oldDelegate.controller.debugLandmarks != controller.debugLandmarks ||
        oldDelegate.controller.shadeFor(MakeupCategory.lip) !=
            controller.shadeFor(MakeupCategory.lip) ||
        oldDelegate.controller.shadeFor(MakeupCategory.blush) !=
            controller.shadeFor(MakeupCategory.blush) ||
        oldDelegate.controller.shadeFor(MakeupCategory.eye) !=
            controller.shadeFor(MakeupCategory.eye) ||
        oldDelegate.controller.shadeFor(MakeupCategory.foundation) !=
            controller.shadeFor(MakeupCategory.foundation) ||
        oldDelegate.controller.intensityFor(MakeupCategory.lip) !=
            controller.intensityFor(MakeupCategory.lip) ||
        oldDelegate.controller.intensityFor(MakeupCategory.blush) !=
            controller.intensityFor(MakeupCategory.blush) ||
        oldDelegate.controller.intensityFor(MakeupCategory.eye) !=
            controller.intensityFor(MakeupCategory.eye) ||
        oldDelegate.controller.intensityFor(MakeupCategory.foundation) !=
            controller.intensityFor(MakeupCategory.foundation) ||
        oldDelegate.controller.lookOpacity != controller.lookOpacity;
  }
}
