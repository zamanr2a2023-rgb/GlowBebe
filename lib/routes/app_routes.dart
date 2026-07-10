import 'package:flutter/material.dart';
import 'package:glowbebe/features/auth/view/forgot_password_screen.dart';
import 'package:glowbebe/features/auth/view/login_screen.dart';
import 'package:glowbebe/features/auth/view/register_screen.dart';
import 'package:glowbebe/features/home/view/home_screen.dart';
import 'package:glowbebe/features/profile/view/edit_profile_screen.dart';
import 'package:glowbebe/features/profile/view/profile_screen.dart';
import 'package:glowbebe/features/settings/view/settings_screen.dart';
import 'package:glowbebe/routes/route_names.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = RouteNames.login;

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
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
