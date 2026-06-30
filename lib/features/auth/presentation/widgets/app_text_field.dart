import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomsync/core/theme/app_theme.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.enabled = true,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      autocorrect: false,
      enableSuggestions: !widget.isPassword,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.textCharcoal,
        fontSize: 14
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.borderSubtle,
                size: 20,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
              tooltip: _obscureText ? 'Tampilkan password' : 'Sembunyikan password',
            )
          : null,
      ),
    );
  }
}