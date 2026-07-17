import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/auth/auth_navigation.dart';
import 'package:glowbebe/features/auth/widgets/auth_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Female';
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _goMain() {
    AuthNavigation.continueAfterSignIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthAtmosphere(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthLuminousHeader(
                  showBack: true,
                  onBack: () => Navigator.maybePop(context),
                ),
                const SizedBox(height: 28),
                Text(
                  'Create Account',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    letterSpacing: -0.96,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your personalized skincare journey.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                GlowField(
                  label: 'Name',
                  controller: _nameController,
                  hint: 'Enter your full name',
                ),
                const SizedBox(height: 16),
                GlowField(
                  label: 'Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'Enter your email address',
                ),
                const SizedBox(height: 16),
                GlowField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter your phone number',
                ),
                const SizedBox(height: 16),
                GlowField(
                  label: 'Location',
                  controller: _locationController,
                  hint: 'Enter your location',
                ),
                const SizedBox(height: 16),
                GlowField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: _obscure,
                  hint: 'Create a secure password',
                  suffix: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GlowField(
                        label: 'Age',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        hint: '25',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GENDER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.7,
                              color: AppColors.iconMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 49,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF807570),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _gender,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.textTertiary,
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Female',
                                    child: Text('Female'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Male',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Other',
                                    child: Text('Other'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Prefer not to say',
                                    child: Text('Prefer not to say'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() => _gender = v);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                GlowPrimaryButton(
                  label: 'Create Account',
                  height: 56,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.otp,
                    arguments: const {'flow': 'register'},
                  ),
                ),
                const SizedBox(height: 24),
                const AuthOrDivider(label: 'OR CONTINUE WITH'),
                const SizedBox(height: 18),
                AuthSocialRow(onTap: _goMain),
                const SizedBox(height: 24),
                GlowOutlinedButton(
                  label: 'CONTINUE AS GUEST',
                  height: 56,
                  onPressed: _goMain,
                ),
                const SizedBox(height: 20),
                AuthFooterLink(
                  prefix: 'Already have an account? ',
                  action: 'Login',
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    RouteNames.login,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
