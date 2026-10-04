import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/theme/app_spacing.dart';

/// Skeleton placeholder used while real content is being fetched.
///
/// Skeletons communicate the *shape* of upcoming content, which feels faster
/// and less jarring than a full-screen spinner for structured layouts.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainerLow,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// A circular skeleton for avatars and thumbnails.
class AppSkeletonCircle extends StatelessWidget {
  const AppSkeletonCircle({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainerLow,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Skeleton of a dashboard metric card.
class AppSkeletonMetricCard extends StatelessWidget {
  const AppSkeletonMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeleton(width: 90, height: 12),
            SizedBox(height: AppSpacing.sm),
            AppSkeleton(width: 130, height: 24),
          ],
        ),
      ),
    );
  }
}

/// Skeleton of a single list row.
class AppSkeletonListRow extends StatelessWidget {
  const AppSkeletonListRow({super.key, this.showThumbnail = true});

  final bool showThumbnail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            if (showThumbnail) ...[
              AppSkeletonCircle(size: 44),
              const SizedBox(width: AppSpacing.md),
            ],
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton(width: 160, height: 14),
                  SizedBox(height: AppSpacing.xs),
                  AppSkeleton(width: 100, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A page-level skeleton that fills the viewport with shimmering rows.
class AppSkeletonListPage extends StatelessWidget {
  const AppSkeletonListPage({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, __) => const AppSkeletonListRow(),
    );
  }
}

/// Skeleton for a header section.
class AppSkeletonHeader extends StatelessWidget {
  const AppSkeletonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: 180, height: 20),
          SizedBox(height: AppSpacing.xs),
          AppSkeleton(width: 120, height: 14),
        ],
      ),
    );
  }
}
