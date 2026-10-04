import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';

/// Uniform loading indicator used across all features.
///
/// Centralizing the look keeps loading state consistent and lets a future
/// redesign of the spinner happen in a single place.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 32,
    this.strokeWidth = 3,
    this.label,
    this.padding = const EdgeInsets.all(AppSpacing.xl2),
  });

  /// Diameter of the circular indicator.
  final double size;

  /// Thickness of the progress arc.
  final double strokeWidth;

  /// Optional caption rendered below the indicator.
  final String? label;

  /// Padding around the indicator when centered on screen.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );

    if (label == null) {
      return Center(
        child: Padding(padding: padding, child: indicator),
      );
    }

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator,
            const SizedBox(height: AppSpacing.sm),
            Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline (non-centered) loading marker for small regions such as a button.
class AppLoadingDot extends StatelessWidget {
  const AppLoadingDot({super.key, this.size = 18, this.strokeWidth = 2});

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );
  }
}
