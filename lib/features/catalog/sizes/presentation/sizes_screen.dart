import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_placeholder_screen.dart';

class SizesScreen extends StatelessWidget {
  const SizesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'سایزها و ویژگی‌ها',
      icon: Icons.straighten_rounded,
      description: 'مدیریت سایزها و ویژگی‌های آیتم اینجا قرار می‌گیرد.',
    );
  }
}
