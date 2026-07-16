import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/auth/widgets/auth_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthAtmosphere(
        child: SafeArea(
          child: Column(
            children: [
              AuthLuminousHeader(
                showBack: true,
                onBack: () => Navigator.maybePop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4DED4),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'Account Recovery',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF52443D),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          height: 1.15,
                          letterSpacing: -0.8,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Don't worry, it happens. Enter your email and we'll send you instructions to reset your password.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          height: 1.55,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD2C4BE)
                                .withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email address',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.plusJakartaSans(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Enter your registered email',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  color: const Color(0xFFD2C4BE),
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(
                                  24,
                                  13,
                                  24,
                                  14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF807570),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF807570),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            GlowPrimaryButton(
                              label: 'Send Reset Link',
                              height: 52,
                              icon: Icons.arrow_forward_ios,
                              onPressed: () => Navigator.pushNamed(
                                context,
                                RouteNames.otp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Directly under the card (Figma), not pinned to bottom
                      const SizedBox(height: 28),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          RouteNames.login,
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.7,
                              color: AppColors.iconMuted,
                            ),
                            children: const [
                              TextSpan(text: '<  '),
                              TextSpan(text: 'Back to Login'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
