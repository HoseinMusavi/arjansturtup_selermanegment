import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arjansturtup_selermanegment/app/app.dart';
import 'package:arjansturtup_selermanegment/app/bootstrap/bootstrap.dart';
import 'package:arjansturtup_selermanegment/app/di/di.dart';
import 'package:arjansturtup_selermanegment/core/config/app_config.dart';

void main() {
  // Each test re-runs the composition root, so the container must be empty
  // between them.
  setUp(() async {
    await resetDependencies();
  });

  testWidgets('bootstrap produces the App widget with Persian RTL direction', (
    tester,
  ) async {
    final app = await bootstrap(config: const AppConfig.test());

    expect(app, isA<App>());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // Persian locale resolves to right-to-left layout direction.
    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);

    // The router lands on the dashboard branch of the adaptive shell.
    expect(find.text('داشبورد'), findsAtLeastNWidgets(1));
  });

  testWidgets('compact viewports render the bottom navigation bar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final app = await bootstrap(config: const AppConfig.test());
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('medium viewports render the navigation rail', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final app = await bootstrap(config: const AppConfig.test());
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('expanded viewports render the extended navigation rail', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final app = await bootstrap(config: const AppConfig.test());
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
  });
}
