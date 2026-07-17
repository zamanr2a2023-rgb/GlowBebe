import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/storage_keys.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:glowbebe/services/storage_service.dart';

/// Routes users after sign-in or registration.
/// First-time users see the 5-step goals questionnaire; returning users go home.
class AuthNavigation {
  AuthNavigation._();

  static Future<bool> isGoalsOnboardingComplete() {
    return StorageService.instance.getBool(StorageKeys.goalsOnboardingComplete);
  }

  static Future<void> markGoalsOnboardingComplete() {
    return StorageService.instance.setBool(
      StorageKeys.goalsOnboardingComplete,
      true,
    );
  }

  static Future<void> continueAfterSignIn(BuildContext context) async {
    var completed = false;
    try {
      completed = await isGoalsOnboardingComplete();
    } catch (_) {
      completed = false;
    }
    if (!context.mounted) return;

    if (completed) {
      Navigator.pushReplacementNamed(context, RouteNames.mainShell);
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      RouteNames.skinQuestionnaire,
      arguments: const {'fromAuth': true},
    );
  }
}
