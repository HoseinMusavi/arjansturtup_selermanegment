import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Rebuilds its subtree whenever the viewport crosses a breakpoint.
///
/// Widgets subscribe to adaptive changes by reading [WindowSizeClass] through
/// [ResponsiveBuilder] or the [BuildContext] extension below, so no widget
/// needs to know pixel thresholds itself.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder, this.child});

  /// Receives the resolved size class and an optional shared [child].
  final Widget Function(
    BuildContext context,
    WindowSizeClass sizeClass,
    Widget? child,
  )
  builder;

  /// Optional subtree that must not rebuild when the size class changes.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final sizeClass = WindowSizeClass.of(width);
    return builder(context, sizeClass, child);
  }
}

/// Convenience extensions for reading adaptive values from [BuildContext].
extension ResponsiveContext on BuildContext {
  /// The semantic size class of the current viewport.
  WindowSizeClass get windowSizeClass {
    final width = MediaQuery.sizeOf(this).width;
    return WindowSizeClass.of(width);
  }

  /// `true` when the viewport is phone-like.
  bool get isHandheld => windowSizeClass.isHandheld;

  /// `true` when the viewport is tablet-or-larger.
  bool get isWide => windowSizeClass.isWide;

  /// Recommended navigation chrome for the current viewport.
  NavigationParadigm get navigationParadigm =>
      windowSizeClass.navigationParadigm;

  /// Available content width, respecting platform safe areas.
  double get contentWidth => MediaQuery.sizeOf(this).width;
}
