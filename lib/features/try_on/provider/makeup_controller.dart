import 'package:flutter/foundation.dart';
import 'package:glowbebe/features/try_on/model/makeup_product.dart';

class MakeupController extends ChangeNotifier {
  MakeupCategory _category = MakeupCategory.lip;
  final Map<MakeupCategory, MakeupShade?> _selectedShades = {
    for (final c in MakeupCategory.values) c: null,
  };
  final Map<MakeupCategory, double> _intensities = {
    for (final c in MakeupCategory.values) c: 0.10,
  };

  FaceLandmarks? _landmarks;
  bool _hideMakeup = false;
  bool _panelVisible = true;
  bool _intensityVisible = false;
  bool _debugLandmarks = false;
  String? _statusLabel;
  bool _faceDetected = false;

  MakeupCategory get category => _category;
  int get categoryIndex => MakeupCategory.values.indexOf(_category);
  FaceLandmarks? get landmarks => _landmarks;
  bool get hideMakeup => _hideMakeup;
  bool get panelVisible => _panelVisible;
  bool get intensityVisible => _intensityVisible;
  bool get debugLandmarks => _debugLandmarks;
  String? get statusLabel => _statusLabel;
  bool get faceDetected => _faceDetected;

  MakeupShade? shadeFor(MakeupCategory category) => _selectedShades[category];

  MakeupShade? get selectedShade => _selectedShades[_category];

  double intensityFor(MakeupCategory category) =>
      ((_intensities[category] ?? 0.10) * _lookOpacity).clamp(0.0, 1.0);

  double get selectedIntensity => _intensities[_category] ?? 0.10;

  double get lookOpacity => _lookOpacity;
  double _lookOpacity = 1.0;

  void setLookOpacity(double value) {
    final v = value.clamp(0.0, 1.0);
    if (_lookOpacity == v) return;
    _lookOpacity = v;
    notifyListeners();
  }

  void setAllBaseIntensities(double value) {
    final v = value.clamp(0.0, 1.0);
    for (final c in MakeupCategory.values) {
      _intensities[c] = v;
    }
    notifyListeners();
  }

  void setShadeFor(MakeupCategory category, MakeupShade? shade) {
    _selectedShades[category] = shade;
    notifyListeners();
  }

  List<AppliedMakeup> get appliedProducts {
    final list = <AppliedMakeup>[];
    for (final c in MakeupCategory.values) {
      final shade = _selectedShades[c];
      if (shade != null) {
        list.add(
          AppliedMakeup(
            category: c,
            shade: shade,
            intensity: intensityFor(c),
          ),
        );
      }
    }
    return list;
  }

  bool get hasAnyMakeup => appliedProducts.isNotEmpty;

  void setCategory(int index) {
    final next = MakeupCategoryX.fromIndex(index);
    if (next == _category) return;
    _category = next;
    notifyListeners();
  }

  void selectShade(MakeupShade? shade) {
    _selectedShades[_category] = shade;
    // First apply starts light (10%); user raises it with the intensity slider.
    if (shade != null) {
      _intensities[_category] = 0.10;
      _intensityVisible = true;
    }
    _statusLabel = shade == null
        ? '${_category.shortLabel} CLEARED'
        : '${shade.name} ${_category.shortLabel} APPLIED';
    notifyListeners();
  }

  void clearCurrentCategory() {
    selectShade(null);
  }

  void removeCategory(MakeupCategory category) {
    if (_selectedShades[category] == null) return;
    _selectedShades[category] = null;
    _statusLabel = '${category.shortLabel} REMOVED';
    notifyListeners();
  }

  void setDebugLandmarks(bool value) {
    if (_debugLandmarks == value) return;
    _debugLandmarks = value;
    notifyListeners();
  }

  void toggleDebugLandmarks() {
    _debugLandmarks = !_debugLandmarks;
    notifyListeners();
  }

  /// Applies a full look for Customize → Choose Style.
  void applyStylePreset(int index) {
    for (final c in MakeupCategory.values) {
      _selectedShades[c] = null;
    }

    var intensity = 0.65;
    switch (index.clamp(0, 4)) {
      case 0: // Natural
        _selectedShades[MakeupCategory.lip] = MakeupCatalog.lipShades[1];
        _selectedShades[MakeupCategory.blush] = MakeupCatalog.blushShades[0];
        _selectedShades[MakeupCategory.foundation] =
            MakeupCatalog.foundationShades[0];
        intensity = 0.45;
        break;
      case 1: // Soft Glam
        _selectedShades[MakeupCategory.lip] = MakeupCatalog.lipShades[0];
        _selectedShades[MakeupCategory.blush] = MakeupCatalog.blushShades[1];
        _selectedShades[MakeupCategory.eye] = MakeupCatalog.eyeShades[1];
        _selectedShades[MakeupCategory.foundation] =
            MakeupCatalog.foundationShades[1];
        intensity = 0.65;
        break;
      case 2: // Office
        _selectedShades[MakeupCategory.lip] = MakeupCatalog.lipShades[4];
        _selectedShades[MakeupCategory.blush] = MakeupCatalog.blushShades[3];
        _selectedShades[MakeupCategory.eye] = MakeupCatalog.eyeShades[0];
        _selectedShades[MakeupCategory.foundation] =
            MakeupCatalog.foundationShades[2];
        intensity = 0.55;
        break;
      case 3: // Party
        _selectedShades[MakeupCategory.lip] = MakeupCatalog.lipShades[3];
        _selectedShades[MakeupCategory.blush] = MakeupCatalog.blushShades[2];
        _selectedShades[MakeupCategory.eye] = MakeupCatalog.eyeShades[2];
        _selectedShades[MakeupCategory.foundation] =
            MakeupCatalog.foundationShades[4];
        intensity = 0.85;
        break;
      case 4: // Date Night
      default:
        _selectedShades[MakeupCategory.lip] = MakeupCatalog.lipShades[0];
        _selectedShades[MakeupCategory.blush] = MakeupCatalog.blushShades[1];
        _selectedShades[MakeupCategory.eye] = MakeupCatalog.eyeShades[2];
        _selectedShades[MakeupCategory.foundation] =
            MakeupCatalog.foundationShades[1];
        intensity = 0.72;
        break;
    }
    for (final c in MakeupCategory.values) {
      _intensities[c] = intensity;
    }
    _statusLabel = 'STYLE APPLIED';
    notifyListeners();
  }

  void setIntensity(double value) {
    final v = value.clamp(0.0, 1.0);
    if ((_intensities[_category] ?? 0) == v) return;
    _intensities[_category] = v;
    notifyListeners();
  }

  void setLandmarks(FaceLandmarks? landmarks) {
    final detected = landmarks != null && landmarks.hasFace;
    final changed = detected != _faceDetected;
    _landmarks = landmarks;
    _faceDetected = detected;
    if (changed) notifyListeners();
  }

  /// For CustomPaint: landmarks update without forcing full widget rebuilds
  /// when face presence is unchanged — callers use ValueNotifier instead.
  void updateLandmarksQuiet(FaceLandmarks? landmarks) {
    _landmarks = landmarks;
    _faceDetected = landmarks != null && landmarks.hasFace;
  }

  void setHideMakeup(bool value) {
    if (_hideMakeup == value) return;
    _hideMakeup = value;
    notifyListeners();
  }

  void togglePanel() {
    _panelVisible = !_panelVisible;
    notifyListeners();
  }

  void setPanelVisible(bool value) {
    if (_panelVisible == value) return;
    _panelVisible = value;
    notifyListeners();
  }

  void toggleIntensitySlider() {
    _intensityVisible = !_intensityVisible;
    notifyListeners();
  }

  void setIntensityVisible(bool value) {
    if (_intensityVisible == value) return;
    _intensityVisible = value;
    notifyListeners();
  }
}
