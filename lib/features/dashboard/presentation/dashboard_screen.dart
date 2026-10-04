import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_placeholder_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'داشبورد',
      icon: Icons.dashboard_rounded,
      description:
          'خلاصه عملیات روز، وضعیت فروشگاه و شاخص‌های فروش اینجا نمایش داده می‌شوند.',
    );
  }
}
