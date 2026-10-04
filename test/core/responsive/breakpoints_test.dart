import 'package:flutter_test/flutter_test.dart';

import 'package:arjansturtup_selermanegment/core/responsive/breakpoints.dart';

void main() {
  group('WindowSizeClass', () {
    test('resolves compact below 600 dp', () {
      expect(WindowSizeClass.of(0), WindowSizeClass.compact);
      expect(WindowSizeClass.of(359), WindowSizeClass.compact);
      expect(WindowSizeClass.of(599.9), WindowSizeClass.compact);
    });

    test('resolves medium between 600 and 839 dp', () {
      expect(WindowSizeClass.of(600), WindowSizeClass.medium);
      expect(WindowSizeClass.of(768), WindowSizeClass.medium);
      expect(WindowSizeClass.of(839.9), WindowSizeClass.medium);
    });

    test('resolves expanded at 840 dp and above', () {
      expect(WindowSizeClass.of(840), WindowSizeClass.expanded);
      expect(WindowSizeClass.of(1080), WindowSizeClass.expanded);
      expect(WindowSizeClass.of(1920), WindowSizeClass.expanded);
    });

    test('boolean classifiers are mutually exclusive', () {
      for (final sizeClass in WindowSizeClass.values) {
        final flags = [
          sizeClass.isCompact,
          sizeClass.isMedium,
          sizeClass.isExpanded,
        ];
        expect(
          flags.where((isSet) => isSet).length,
          1,
          reason: '$sizeClass must belong to exactly one class',
        );
      }
    });

    test('handheld groups compact and medium', () {
      expect(WindowSizeClass.compact.isHandheld, isTrue);
      expect(WindowSizeClass.medium.isHandheld, isTrue);
      expect(WindowSizeClass.expanded.isHandheld, isFalse);

      expect(WindowSizeClass.expanded.isWide, isTrue);
      expect(WindowSizeClass.compact.isWide, isFalse);
    });

    test('grid columns grow with the viewport', () {
      expect(WindowSizeClass.compact.gridCrossAxisCount, 1);
      expect(WindowSizeClass.medium.gridCrossAxisCount, 2);
      expect(WindowSizeClass.expanded.gridCrossAxisCount, 3);

      final counts = WindowSizeClass.values
          .map((sizeClass) => sizeClass.gridCrossAxisCount)
          .toList();
      for (var i = 1; i < counts.length; i++) {
        expect(counts[i], greaterThan(counts[i - 1]));
      }
    });

    test('navigation paradigm matches Material 3 guidance', () {
      expect(
        WindowSizeClass.compact.navigationParadigm,
        NavigationParadigm.bottomBar,
      );
      expect(
        WindowSizeClass.medium.navigationParadigm,
        NavigationParadigm.rail,
      );
      expect(
        WindowSizeClass.expanded.navigationParadigm,
        NavigationParadigm.sidebar,
      );
    });
  });
}
