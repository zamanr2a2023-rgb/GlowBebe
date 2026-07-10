import 'package:flutter/material.dart';
import 'package:glowbebe/core/theme/app_theme.dart';
import 'package:glowbebe/routes/app_routes.dart';

class GlowBebeApp extends StatelessWidget {
  const GlowBebeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlowBebe',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
