import 'package:flutter/material.dart';

import 'app_loading_indicator.dart';

/// Button hierarchy of the design system.
///
/// Features pick a semantic [AppButtonVariant] rather than a raw widget, so
/// the visual hierarchy stays consistent and can evolve centrally.
enum AppButtonVariant {
  /// Primary action on the screen (filled).
  primary,

  /// Secondary action (tonal surface).
  secondary,

  /// Outlined action.
  outlined,

  /// Low-emphasis textual action.
  text,

  /// Destructive action (filled red).
  destructive,
}

/// Buttons with built-in submit-state handling.
///
/// When [onPressed] is async, the button disables itself and shows a spinner
/// until the future resolves, which structurally prevents double submission —
/// a requirement for destructive operations such as deleting a product.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.isExpanded = false,
    this.minimumHeight = 48,
    this.isLoading = false,
    this.isEnabled = true,
  });

  /// Visible Persian label.
  final String label;

  /// Tap handler. May be async; the button waits for completion.
  final Future<void> Function()? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional trailing icon.
  final IconData? trailingIcon;

  /// Variant controlling visual weight.
  final AppButtonVariant variant;

  /// Stretches to the full available width.
  final bool isExpanded;

  /// Minimum touch height; kept >= 44 for accessibility.
  final double minimumHeight;

  /// Forces the loading state from the outside (e.g. a submitting BLoC).
  final bool isLoading;

  /// Hard enable/disable independent of the async lifecycle.
  final bool isEnabled;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isSubmitting = false;

  bool get _busy => widget.isLoading || _isSubmitting;

  bool get _canTap => widget.isEnabled && !_busy && widget.onPressed != null;

  Future<void> _handleTap() async {
    if (!_canTap) return;
    setState(() => _isSubmitting = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    final buttonStyle = switch (widget.variant) {
      AppButtonVariant.primary => FilledButton.styleFrom(
        minimumSize: Size.fromHeight(widget.minimumHeight),
        shape: shape,
      ),
      AppButtonVariant.secondary => FilledButton.styleFrom(
        minimumSize: Size.fromHeight(widget.minimumHeight),
        shape: shape,
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
      ),
      AppButtonVariant.outlined => OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(widget.minimumHeight),
        shape: shape,
      ),
      AppButtonVariant.text => TextButton.styleFrom(
        minimumSize: Size.fromHeight(widget.minimumHeight),
        shape: shape,
      ),
      AppButtonVariant.destructive => FilledButton.styleFrom(
        minimumSize: Size.fromHeight(widget.minimumHeight),
        shape: shape,
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
      ),
    };

    // The destructive variant must render as filled; all variants collapse to
    // either FilledButton or OutlinedButton/TextButton for a consistent tree.
    Widget child = _buildContent(context);

    if (widget.variant == AppButtonVariant.outlined) {
      child = OutlinedButton(
        onPressed: _canTap ? _handleTap : null,
        style: buttonStyle,
        child: child,
      );
    } else if (widget.variant == AppButtonVariant.text) {
      child = TextButton(
        onPressed: _canTap ? _handleTap : null,
        style: buttonStyle,
        child: child,
      );
    } else {
      child = FilledButton(
        onPressed: _canTap ? _handleTap : null,
        style: buttonStyle,
        child: child,
      );
    }

    if (widget.isExpanded) {
      child = SizedBox(width: double.infinity, child: child);
    }

    // Communicate the disabled/busy state to assistive technology.
    return Semantics(
      button: true,
      enabled: _canTap,
      label: widget.label,
      child: child,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_busy) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLoadingDot(size: 18),
          const SizedBox(width: 8),
          Text(widget.label),
        ],
      );
    }

    if (widget.icon != null && widget.trailingIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18),
          const SizedBox(width: 8),
          Text(widget.label),
          const SizedBox(width: 8),
          Icon(widget.trailingIcon, size: 18),
        ],
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18),
          const SizedBox(width: 8),
          Text(widget.label),
        ],
      );
    }

    if (widget.trailingIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label),
          const SizedBox(width: 8),
          Icon(widget.trailingIcon, size: 18),
        ],
      );
    }

    return Text(widget.label);
  }
}
