import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/constants/app_constants.dart';
import 'di/di.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';

/// Root widget of the application.
///
/// Responsibilities are deliberately narrow: locale resolution, theming,
/// localization delegates and wiring the router produced by the composition
/// root. Everything else is delegated so this widget never grows into a
/// "god widget".
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouterProvider>().router;

    return MaterialApp.router(
      title: AppTheme.appName,
      debugShowCheckedModeBanner: false,

      // Persian is the primary locale and drives RTL layout.
      locale: const Locale(AppConstants.persianLocale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // TextDirection is resolved per-locale; Persian yields RTL.
      builder: (context, child) {
        final direction = AppLocalizations(
          Localizations.localeOf(context),
        ).textDirection;
        return Directionality(
          textDirection: direction,
          child: child ?? const SizedBox.shrink(),
        );
      },

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
