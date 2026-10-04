import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';

/// Surface container used to group related content.
///
/// Thin wrapper over [Card] that applies the design-system radius, padding
/// and tonal elevation, so feature screens stay declarative.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.shadow = true,
    this.borderRadius = AppRadius.card,
  });

  /// Content of the card.
  final Widget child;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Makes the card tappable (ripple included).
  final VoidCallback? onTap;

  /// Outer margin; defaults to a small vertical gap in lists.
  final EdgeInsetsGeometry? margin;

  /// Overrides the surface color.
  final Color? backgroundColor;

  /// Draws a hairline border in the given color.
  final Color? borderColor;

  /// Whether the soft elevation shadow is applied.
  final bool shadow;

  /// Corner radius.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: borderRadius,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        boxShadow: shadow ? AppShadows.card : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Labeled section that groups several cards or fields on a screen.
class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (actionLabel != null && onAction != null)
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

/// Thin separator used between stacked cards.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.indent = AppSpacing.md});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(indent: indent, endIndent: indent, color: AppColors.divider);
  }
}
