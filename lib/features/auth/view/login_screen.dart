import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/auth/auth_navigation.dart';
import 'package:glowbebe/features/auth/widgets/auth_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthLuminousHeader(),
                const SizedBox(height: 40),
                Text(
                  'Welcome Back',
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
                  'Sign in to continue your beauty journey.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                GlowField(
                  label: 'Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'Enter your email address',
                ),
                const SizedBox(height: 20),
                GlowField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: _obscure,
                  hint: 'Enter your password',
                  labelTrailing: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.forgotPassword,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
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
                const SizedBox(height: 28),
                GlowPrimaryButton(
                  label: 'Sign In',
                  height: 56,
                  onPressed: _goMain,
                ),
                const SizedBox(height: 28),
                const AuthOrDivider(label: 'OR LOGIN WITH'),
                const SizedBox(height: 20),
                AuthSocialRow(onTap: _goMain),
                const SizedBox(height: 28),
                GlowOutlinedButton(
                  label: 'CONTINUE AS GUEST',
                  height: 56,
                  onPressed: _goMain,
                ),
                const SizedBox(height: 24),
                AuthFooterLink(
                  prefix: 'New to Luminous? ',
                  action: 'Sign Up',
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
