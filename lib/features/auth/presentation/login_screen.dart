import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_placeholder_screen.dart';

/// Temporary login placeholder.
///
/// The real login experience (mobile number + password, session bootstrap and
/// secure credential storage) is delivered in the authentication phase.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'ورود به حساب',
      icon: Icons.lock_outline_rounded,
      description:
          'فرم ورود با شماره موبایل در فاز احراز هویت پیاده‌سازی می‌شود.',
    );
  }
}
