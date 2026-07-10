import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_strings.dart';
import 'package:glowbebe/core/utils/helpers.dart';
import 'package:glowbebe/core/utils/validators.dart';
import 'package:glowbebe/core/widgets/custom_button.dart';
import 'package:glowbebe/core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.forgotPassword)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _emailController,
                label: AppStrings.email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Send Reset Link',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Helpers.showSnackBar(
                      context,
                      'Reset link sent to ${_emailController.text}',
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
