import 'package:flutter/material.dart';

/// Form text field conforming to the design system.
///
/// Wraps [TextField] so feature forms stay declarative and consistent.
/// Validation errors surface through [errorText], which the Material input
/// theme renders under the field.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofillHints,
    this.textAlignVertical,
    this.expands = false,
  });

  /// Floating label shown above the field.
  final String label;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Placeholder shown when the field is empty.
  final String? hint;

  /// Validation message rendered under the field.
  final String? errorText;

  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final TextAlignVertical? textAlignVertical;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        filled: true,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      autofillHints: autofillHints,
      textAlignVertical: textAlignVertical,
      expands: expands,
      style: theme.textTheme.bodyLarge,
    );
  }
}
