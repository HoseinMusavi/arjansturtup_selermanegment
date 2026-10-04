import 'package:flutter/material.dart';

import 'app/bootstrap/bootstrap.dart';

/// Application entry point.
///
/// Keeps no logic of its own: startup orchestration lives in [bootstrap] so
/// that the same sequence can be exercised by integration tests.
void main() {
  runApp(_BootstrapApp());
}

/// Runs [bootstrap] and displays a neutral placeholder until the first frame
/// of the real [App] is ready.
class _BootstrapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }

        // Startup is fast; a plain splash keeps the launch calm and avoids
        // a flash of unstyled content while dependencies resolve.
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ارجان مرچنت',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // A single shared future so a rebuild never restarts bootstrap.
  static final Future<Widget> _future = bootstrap();
}
