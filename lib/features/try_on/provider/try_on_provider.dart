import 'package:flutter/foundation.dart';

class TryOnProvider extends ChangeNotifier {
  int _hubTabIndex = 0;
  int _selectedShadeIndex = 0;
  int _selectedCategoryIndex = 0;
  int _selectedPresetIndex = 0;
  double _intensity = 0.65;
  double _comparisonValue = 0.5;
  String _cameraMode = 'Try-On';

  int get hubTabIndex => _hubTabIndex;
  int get selectedShadeIndex => _selectedShadeIndex;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  int get selectedPresetIndex => _selectedPresetIndex;
  double get intensity => _intensity;
  double get comparisonValue => _comparisonValue;
  String get cameraMode => _cameraMode;

  void setHubTab(int index) {
    _hubTabIndex = index;
    notifyListeners();
  }

  void setShade(int index) {
    _selectedShadeIndex = index;
    notifyListeners();
  }

  void setCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void setPreset(int index) {
    _selectedPresetIndex = index;
    notifyListeners();
  }

  void setIntensity(double value) {
    _intensity = value;
    notifyListeners();
  }

  void setComparisonValue(double value) {
    _comparisonValue = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setCameraMode(String mode) {
    _cameraMode = mode;
    notifyListeners();
  }
}
