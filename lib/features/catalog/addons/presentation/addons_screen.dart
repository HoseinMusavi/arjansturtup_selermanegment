import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_placeholder_screen.dart';

class AddonsScreen extends StatelessWidget {
  const AddonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'افزودنی‌ها',
      icon: Icons.add_circle_outline_rounded,
      description: 'مدیریت افزودنی‌ها و قیمت‌گذاری آن‌ها اینجا قرار می‌گیرد.',
    );
  }
}
