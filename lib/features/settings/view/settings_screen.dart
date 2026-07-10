import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_strings.dart';
import 'package:glowbebe/routes/route_names.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false,
            onChanged: (_) {},
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () => Navigator.pushReplacementNamed(context, RouteNames.login),
          ),
        ],
      ),
    );
  }
}
