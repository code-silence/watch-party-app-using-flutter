import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _required(
    String? value,
    String message,
  ) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    final username = value.trim();

    if (username.length < 3 || username.length > 20) {
      return 'Username must be 3-20 characters';
    }

    final regex = RegExp(r'^[a-zA-Z0-9_]+$');

    if (!regex.hasMatch(username)) {
      return 'Only letters, numbers and _';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final regex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!regex.hasMatch(value.trim())) {
      return 'Invalid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Minimum 6 characters';
    }

    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);

    try {
      await controller.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        displayName: _displayNameController.text.trim(),
      );

      if (!mounted) return;

      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.red,
                  size: 90,
                ),

                const SizedBox(height: 30),

                AppTextField(
                  controller: _displayNameController,
                  label: 'Display Name',
                  validator: (value) =>
                      _required(value, 'Display name is required'),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _usernameController,
                  label: 'Username',
                  validator: _validateUsername,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  isPassword: true,
                  validator: _validatePassword,
                ),

                const SizedBox(height: 30),

                AppButton(
                  text: 'Create Account',
                  isLoading: authState.isLoading,
                  onPressed: _register,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}