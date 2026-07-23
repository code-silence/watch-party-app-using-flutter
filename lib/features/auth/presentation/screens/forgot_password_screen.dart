import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final regex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authControllerProvider.notifier).forgotPassword(
            _emailController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset email sent.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_reset,
                    color: Colors.red,
                    size: 90,
                  ),

                  const SizedBox(height: 30),

                  AppTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 30),

                  AppButton(
                    text: 'Send Reset Email',
                    isLoading: authState.isLoading,
                    onPressed: _resetPassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}