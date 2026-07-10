import 'package:flutter/foundation.dart';
import 'package:glowbebe/features/profile/model/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Fetch profile from API
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _profile = const ProfileModel(
      id: '1',
      email: 'user@example.com',
      name: 'GlowBebe User',
    );

    _isLoading = false;
    notifyListeners();
  }

  void updateProfile(ProfileModel profile) {
    _profile = profile;
    notifyListeners();
  }
}
