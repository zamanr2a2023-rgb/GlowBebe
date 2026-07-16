import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/utils/helpers.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Elena Rossi');
  final _bioController = TextEditingController(
    text: 'Combination skin · Cool undertone · Barrier-first rituals',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfacePeach,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Change photo',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              GlowField(label: 'Name', controller: _nameController),
              const SizedBox(height: 16),
              GlowField(label: 'Bio', controller: _bioController),
              const SizedBox(height: 28),
              GlowPrimaryButton(
                label: 'Save Changes',
                onPressed: () {
                  Helpers.showSnackBar(context, 'Profile updated');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
