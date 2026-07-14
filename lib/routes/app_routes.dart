import 'package:flutter/material.dart';
import 'package:glowbebe/features/auth/view/forgot_password_screen.dart';
import 'package:glowbebe/features/auth/view/login_screen.dart';
import 'package:glowbebe/features/auth/view/register_screen.dart';
import 'package:glowbebe/features/home/view/home_screen.dart';
import 'package:glowbebe/features/profile/view/edit_profile_screen.dart';
import 'package:glowbebe/features/profile/view/profile_screen.dart';
import 'package:glowbebe/features/settings/view/settings_screen.dart';
import 'package:glowbebe/features/try_on/view/analysis_results_screen.dart';
import 'package:glowbebe/features/try_on/view/camera_mirror_screen.dart';
import 'package:glowbebe/features/try_on/view/capture_comparison_screen.dart';
import 'package:glowbebe/features/try_on/view/color_shade_match_screen.dart';
import 'package:glowbebe/features/try_on/view/customize_look_screen.dart';
import 'package:glowbebe/features/try_on/view/makeup_hub_screen.dart';
import 'package:glowbebe/features/try_on/view/placement_advice_screen.dart';
import 'package:glowbebe/features/try_on/view/realtime_tryon_screen.dart';
import 'package:glowbebe/features/try_on/view/shade_matched_shop_screen.dart';
import 'package:glowbebe/routes/route_names.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = RouteNames.login;
  static const String makeupHub = RouteNames.makeupHub;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouteNames.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case RouteNames.makeupHub:
        return MaterialPageRoute(builder: (_) => const MakeupHubScreen());
      case RouteNames.cameraMirror:
        return MaterialPageRoute(builder: (_) => const CameraMirrorScreen());
      case RouteNames.realtimeTryOn:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>?;
            return RealtimeTryOnScreen(
              imagePath: args?['imagePath'] as String?,
              mirror: args?['mirror'] as bool? ?? false,
            );
          },
        );
      case RouteNames.customizeLook:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>?;
            return CustomizeLookScreen(
              imagePath: args?['imagePath'] as String?,
              mirror: args?['mirror'] as bool? ?? false,
            );
          },
        );
      case RouteNames.captureComparison:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>?;
            return CaptureComparisonScreen(
              imagePath: args?['imagePath'] as String?,
              beforePath: args?['beforePath'] as String?,
              afterPath: args?['afterPath'] as String?,
              mirror: args?['mirror'] as bool? ?? false,
            );
          },
        );
      case RouteNames.colorShadeMatch:
        return MaterialPageRoute(builder: (_) => const ColorShadeMatchScreen());
      case RouteNames.shadeMatchedShop:
        return MaterialPageRoute(
          builder: (_) => const ShadeMatchedShopScreen(),
        );
      case RouteNames.placementAdvice:
        return MaterialPageRoute(builder: (_) => const PlacementAdviceScreen());
      case RouteNames.analysisResults:
        return MaterialPageRoute(builder: (_) => const AnalysisResultsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
