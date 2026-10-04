import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../responsive/responsive_builder.dart';

/// Generic "section scaffold" used while a feature's UI is being built.
///
/// Phase 0 wires the full navigation graph so the adaptive shell is testable
/// end to end; each feature screen starts from this scaffold and is replaced
/// feature-by-feature in later phases without touching navigation.
class AppPlaceholderScreen extends StatelessWidget {
  const AppPlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    this.description,
    this.actions,
  });

  final String title;
  final IconData icon;
  final String? description;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: ResponsiveBuilder(
        builder: (context, sizeClass, _) {
          final maxContentWidth = sizeClass.isHandheld
              ? double.infinity
              : 720.0;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 44,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
