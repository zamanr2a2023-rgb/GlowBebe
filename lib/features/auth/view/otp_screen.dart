import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/features/auth/auth_navigation.dart';
import 'package:glowbebe/features/auth/widgets/auth_widgets.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  int _focused = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) setState(() => _focused = i);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  /// Register → OTP → Goals; Forgot password → Main/Login.
  Future<void> _onVerified() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final flow = args is Map ? args['flow'] as String? : null;

    if (flow == 'register') {
      final completed = await AuthNavigation.isGoalsOnboardingComplete();
      if (!mounted) return;

      if (completed) {
        Navigator.pushReplacementNamed(context, RouteNames.mainShell);
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        RouteNames.skinQuestionnaire,
        arguments: const {'fromAuth': true},
      );
      return;
    }

    Navigator.pushReplacementNamed(context, RouteNames.mainShell);
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
                title: 'LUXE',
                showBack: true,
                onBack: () => Navigator.maybePop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    children: [
                      // Branding / shield identity (auth.md)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFDBCE),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF805443)
                                  .withValues(alpha: 0.1),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                              spreadRadius: -15,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 28,
                          color: Color(0xFF805443),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Verify Your Identity',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          height: 34 / 28,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "We've sent a verification code to your email. Please enter it below.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F3F2),
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (i) {
                                final focused = _focused == i;
                                return SizedBox(
                                  width: 52,
                                  height: 64,
                                  child: TextField(
                                    controller: _controllers[i],
                                    focusNode: _focusNodes[i],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (v) => _onChanged(i, v),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      filled: true,
                                      fillColor: focused
                                          ? const Color(0xFFF4DED4)
                                              .withValues(alpha: 0.2)
                                          : const Color(0xFFE5E2E1),
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: focused
                                              ? const Color(0xFF2563EB)
                                              : const Color(0xFFD2C4BE),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFD2C4BE),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF2563EB),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 32),
                            GlowPrimaryButton(
                              label: 'Verify',
                              height: 52,
                              onPressed: _onVerified,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Resend — stacked (auth.md)
                      Text(
                        "Didn't receive the code?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 16 / 12,
                          color: const Color(0xFF4E4540),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Resend Code',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.7,
                            color: const Color(0xFF805443),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Bento footer: mood image + encryption card
                      SizedBox(
                        height: 128,
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  AppAssets.lookOffice,
                                  fit: BoxFit.cover,
                                  height: 128,
                                  width: double.infinity,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 128,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7E1D7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.shield_outlined,
                                      size: 20,
                                      color: Color(0xFF805443),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Secured by Industry-Standard Encryption',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        height: 15 / 12,
                                        color: const Color(0xFF73635B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
