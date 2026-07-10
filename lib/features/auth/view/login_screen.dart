import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_strings.dart';
import 'package:glowbebe/core/utils/validators.dart';
import 'package:glowbebe/core/widgets/custom_button.dart';
import 'package:glowbebe/core/widgets/custom_text_field.dart';
import 'package:glowbebe/routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.login)),
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
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: AppStrings.password,
                obscureText: true,
                validator: Validators.password,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: AppStrings.login,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, RouteNames.home);
                  }
                },
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.forgotPassword),
                child: const Text(AppStrings.forgotPassword),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.register),
                child: const Text(AppStrings.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
