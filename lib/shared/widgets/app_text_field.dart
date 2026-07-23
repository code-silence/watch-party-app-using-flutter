import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.validator,
    this.isPassword = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: const OutlineInputBorder(),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              )
            : null,
      ),
    );
  }
}