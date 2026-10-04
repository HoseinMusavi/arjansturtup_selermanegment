import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'تنظیمات',
      icon: Icons.settings_rounded,
      description: 'تنظیمات اعلان‌ها و پیکربندی فروشگاه اینجا قرار می‌گیرد.',
    );
  }
}
