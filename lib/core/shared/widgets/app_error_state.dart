import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../error/app_failure.dart';

/// Recoverable error state shown when a section fails to load.
///
/// The user never sees an exception or a blank screen: [AppFailure.message]
/// is always displayed in Persian, and [onRetry] is offered whenever the
/// failure declares itself retryable. A subtle technical caption is shown only
/// in debug builds to aid diagnosis without leaking internals to merchants.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.failure,
    this.onRetry,
    this.icon = Icons.cloud_off_rounded,
  });

  /// Human friendly Persian message to display.
  final String message;

  /// The originating failure; used to decide retry availability and to show
  /// technical context in debug builds.
  final AppFailure? failure;

  /// Invoked by the retry button when the failure is retryable.
  final VoidCallback? onRetry;

  /// Decorative icon for the error illustration.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canRetry = failure?.isRetryable ?? onRetry != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (canRetry) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _subtitle(context),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('تلاش مجدد'),
              ),
            ],
            if (_debugCaption(context) != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _debugCaption(context)!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _subtitle(BuildContext context) {
    if (failure != null && failure!.requiresReauthentication) {
      return 'لطفاً دوباره وارد حساب کاربری خود شوید.';
    }
    return 'مجدداً تلاش کنید؛ اگر مشکل پابرجا بود، کمی صبر کنید.';
  }

  String? _debugCaption(BuildContext context) {
    // Technical context is only ever surfaced to developers; merchants always
    // see the friendly Persian message above.
    if (!kDebugMode || failure == null) return null;
    final parts = <String>[failure!.typeLabel];
    if (failure!.code != null) parts.add('code=${failure!.code}');
    return parts.join(' · ');
  }

  /// Constructs an error state directly from an [AppFailure].
  factory AppErrorState.fromFailure(
    AppFailure failure, {
    Key? key,
    VoidCallback? onRetry,
    IconData icon = Icons.cloud_off_rounded,
  }) {
    return AppErrorState(
      key: key,
      message: failure.message,
      failure: failure,
      onRetry: onRetry,
      icon: icon,
    );
  }
}
