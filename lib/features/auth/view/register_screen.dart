import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_strings.dart';
import 'package:glowbebe/core/utils/validators.dart';
import 'package:glowbebe/core/widgets/custom_button.dart';
import 'package:glowbebe/core/widgets/custom_text_field.dart';
import 'package:glowbebe/routes/route_names.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) => Validators.required(value, fieldName: 'Name'),
              ),
              const SizedBox(height: 16),
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
                label: AppStrings.register,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, RouteNames.home);
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
