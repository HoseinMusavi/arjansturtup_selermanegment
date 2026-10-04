import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

/// Compact tag used for statuses, categories and metadata.
///
/// Accessibility: status is never conveyed by color alone. [AppStatusChip]
/// always pairs its color with a shape marker (dot or icon) *and* a Persian
/// label, so color-blind users and screen readers receive the same
/// information.
enum AppChipTone { neutral, success, warning, error, info, brand }

extension AppChipToneX on AppChipTone {
  Color get foreground => switch (this) {
    AppChipTone.neutral => AppColors.neutral700,
    AppChipTone.success => AppColors.success,
    AppChipTone.warning => AppColors.warning,
    AppChipTone.error => AppColors.error,
    AppChipTone.info => AppColors.info,
    AppChipTone.brand => AppColors.brandPrimary,
  };

  Color get background => switch (this) {
    AppChipTone.neutral => AppColors.neutral100,
    AppChipTone.success => AppColors.successContainer,
    AppChipTone.warning => AppColors.warningContainer,
    AppChipTone.error => AppColors.errorContainer,
    AppChipTone.info => AppColors.infoContainer,
    AppChipTone.brand => AppColors.brandPrimaryLight.withValues(alpha: 0.35),
  };
}

/// Status chip pairing a color with a marker dot and a text label.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    this.tone = AppChipTone.neutral,
    this.icon,
    this.isEnabled = true,
  });

  /// Persian label shown next to the marker.
  final String label;

  /// Semantic tone driving the color; a marker dot is always rendered too.
  final AppChipTone tone;

  /// Optional explicit icon; when omitted a dot marker is used.
  final IconData? icon;

  /// Dimmed appearance for inactive rows.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = tone.foreground;
    final bg = tone.background;

    return Semantics(
      label: label,
      button: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isEnabled ? bg : bg.withValues(alpha: 0.5),
          borderRadius: AppRadius.small,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: 13, color: isEnabled ? fg : AppColors.disabled)
            else
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isEnabled ? fg : AppColors.disabled,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isEnabled ? fg : AppColors.disabled,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Plain informational chip without a status marker.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.tone = AppChipTone.neutral,
    this.onTap,
    this.selected = false,
  });

  final String label;
  final AppChipTone tone;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: selected ? colorScheme.onPrimary : tone.foreground,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );

    final decoration = BoxDecoration(
      color: selected ? colorScheme.primary : tone.background,
      borderRadius: AppRadius.small,
    );

    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.small,
        child: DecoratedBox(decoration: decoration, child: content),
      ),
    );
  }
}
