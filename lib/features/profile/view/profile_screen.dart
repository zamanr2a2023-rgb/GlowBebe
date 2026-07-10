import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_strings.dart';
import 'package:glowbebe/routes/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, RouteNames.editProfile),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
            SizedBox(height: 16),
            Text('GlowBebe User', style: TextStyle(fontSize: 20)),
            Text('user@example.com'),
          ],
        ),
      ),
    );
  }
}
