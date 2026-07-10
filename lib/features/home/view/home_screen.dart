import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_strings.dart';
import 'package:glowbebe/routes/route_names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.home)),
      body: const Center(child: Text('Welcome to GlowBebe')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(AppStrings.appName, style: TextStyle(fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(AppStrings.profile),
              onTap: () => Navigator.pushNamed(context, RouteNames.profile),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(AppStrings.settings),
              onTap: () => Navigator.pushNamed(context, RouteNames.settings),
            ),
          ],
        ),
      ),
    );
  }
}
