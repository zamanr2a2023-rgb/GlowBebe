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
    if (controller.hideMakeup) return;
    final raw = landmarks;
    if (raw == null || !raw.hasFace) return;

    final lm = raw.imageSize == size
        ? raw
        : raw.mappedTo(widgetSize: size, mirror: false);

    // Draw order: foundation → blush → eyes → lips
    _paintFoundation(canvas, lm);
    _paintBlush(canvas, lm);
    _paintEyes(canvas, lm);
    _paintLips(canvas, lm);
  }

  void _paintFoundation(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.foundation);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.foundation);
    final facePath = _faceMask(lm);
    if (facePath == null) return;

    // Visible even tint — softLight was basically invisible on camera photos.
    final base = Paint()
      ..color = shade.color.withValues(alpha: 0.32 * intensity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..blendMode = BlendMode.srcOver;
    canvas.drawPath(facePath, base);

    final veil = Paint()
      ..color = shade.color.withValues(alpha: 0.18 * intensity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
      ..blendMode = BlendMode.softLight;
    canvas.drawPath(facePath, veil);
  }

  void _paintBlush(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.blush);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.blush);
    final cheeks = _cheekCenters(lm);
    if (cheeks.isEmpty) return;

    final faceBounds = _bounds(lm.faceOval) ?? _estimateFaceBounds(lm);
    final radius = faceBounds == null
        ? 52.0
        : (faceBounds.width * 0.18).clamp(40.0, 78.0);

    final clip = _faceMask(lm);

    for (final center in cheeks) {
      canvas.save();
      if (clip != null) canvas.clipPath(clip);

      final glow = Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius,
          [
            shade.color.withValues(alpha: 0.55 * intensity),
            shade.color.withValues(alpha: 0.28 * intensity),
            shade.color.withValues(alpha: 0.0),
          ],
          const [0.0, 0.45, 1.0],
        )
        ..blendMode = BlendMode.srcOver
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, radius, glow);

      // Warm core so blush reads on darker skin / photos.
      final core = Paint()
        ..color = shade.color.withValues(alpha: 0.28 * intensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..blendMode = BlendMode.srcOver;
      canvas.drawCircle(center, radius * 0.45, core);
      canvas.restore();
    }
  }

  void _paintEyes(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.eye);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.eye);
    _paintEyeShadow(canvas, lm.leftEye, lm.leftEyebrow, shade, intensity);
    _paintEyeShadow(canvas, lm.rightEye, lm.rightEyebrow, shade, intensity);
  }

  void _paintEyeShadow(
    Canvas canvas,
    List<Offset> eye,
    List<Offset> brow,
    MakeupShade shade,
    double intensity,
  ) {
    if (eye.length < 3) return;

    final eyeBounds = _bounds(eye);
    if (eyeBounds == null || eyeBounds.width < 2) return;

    final lidHeight = math.max(eyeBounds.height * 1.35, 18.0);
    var top = eyeBounds.top - lidHeight * 0.85;
    if (brow.length >= 2) {
      final browBottom = brow.map((p) => p.dy).reduce(math.max);
      // Keep eyeshadow under the brow.
      top = math.max(top, browBottom + 2);
    }

    final path = Path()
      ..moveTo(eyeBounds.left - 4, eyeBounds.center.dy)
      ..quadraticBezierTo(
        eyeBounds.center.dx,
        top,
        eyeBounds.right + 4,
        eyeBounds.center.dy,
      )
      ..quadraticBezierTo(
        eyeBounds.center.dx,
        eyeBounds.top + eyeBounds.height * 0.15,
        eyeBounds.left - 4,
        eyeBounds.center.dy,
      )
      ..close();

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(eyeBounds.center.dx, top),
        Offset(eyeBounds.center.dx, eyeBounds.bottom),
        [
          shade.color.withValues(alpha: 0.62 * intensity),
          shade.color.withValues(alpha: 0.22 * intensity),
          shade.color.withValues(alpha: 0.0),
        ],
        const [0.0, 0.55, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..blendMode = BlendMode.srcOver;
    canvas.drawPath(path, paint);

    // Crease line for definition.
    final crease = Paint()
      ..color = shade.color.withValues(alpha: 0.35 * intensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..blendMode = BlendMode.srcOver;
    final creasePath = Path()
      ..moveTo(eyeBounds.left, eyeBounds.top + 2)
      ..quadraticBezierTo(
        eyeBounds.center.dx,
        top + lidHeight * 0.35,
        eyeBounds.right,
        eyeBounds.top + 2,
      );
    canvas.drawPath(creasePath, crease);
  }

  void _paintLips(Canvas canvas, FaceLandmarks lm) {
    final shade = controller.shadeFor(MakeupCategory.lip);
    if (shade == null) return;

    final intensity = controller.intensityFor(MakeupCategory.lip);
    final upper =
        _smoothLipBand(lm.upperLipTop, lm.upperLipBottom, inflate: 1.4);
    final lower =
        _smoothLipBand(lm.lowerLipTop, lm.lowerLipBottom, inflate: 1.6);
    final full = _lipCombinedPath(lm, inflate: 1.2);
    final bounds = full?.getBounds();

    if (full != null) {
      canvas.drawPath(
        full,
        Paint()
          ..color = shade.color.withValues(alpha: 0.22 * intensity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
          ..blendMode = BlendMode.srcOver,
      );
    }

    final body = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver;

    if (bounds != null) {
      body.shader = ui.Gradient.linear(
        Offset(bounds.center.dx, bounds.top),
        Offset(bounds.center.dx, bounds.bottom),
        [
          Color.lerp(Colors.white, shade.color, 0.72)!
              .withValues(alpha: 0.78 * intensity),
          shade.color.withValues(alpha: 0.84 * intensity),
          Color.lerp(shade.color, const Color(0xFF4A2020), 0.25)!
              .withValues(alpha: 0.76 * intensity),
        ],
        const [0.0, 0.45, 1.0],
      );
    } else {
      body.color = shade.color.withValues(alpha: 0.78 * intensity);
    }

    if (upper != null) canvas.drawPath(upper, body);
    if (lower != null) canvas.drawPath(lower, body);

    if (lm.upperLipTop.length >= 3) {
      final pts = _sampleSmooth(lm.upperLipTop, steps: 18);
      if (pts.isNotEmpty) {
        final highlight = Path()..moveTo(pts.first.dx, pts.first.dy + 1.5);
        for (var i = 1; i < pts.length; i++) {
          highlight.lineTo(pts[i].dx, pts[i].dy + 1.5);
        }
        canvas.drawPath(
          highlight,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.28 * intensity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.2
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
            ..blendMode = BlendMode.srcOver,
        );
      }
    }
  }

  /// Face oval with eye / lip holes when available.
  Path? _faceMask(FaceLandmarks lm) {
    Path? facePath = _closedPath(lm.faceOval);
    facePath ??= () {
      final bounds = _estimateFaceBounds(lm);
      if (bounds == null) return null;
      return Path()..addOval(bounds.inflate(bounds.width * 0.02));
    }();
    if (facePath == null) return null;

    Path mask = facePath;
    for (final eye in [lm.leftEye, lm.rightEye]) {
      final eyePath = _closedPath(eye, inflate: 6);
      if (eyePath != null) {
        mask = Path.combine(PathOperation.difference, mask, eyePath);
      }
    }
    final lips = _lipCombinedPath(lm);
    if (lips != null) {
      mask = Path.combine(PathOperation.difference, mask, lips);
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
