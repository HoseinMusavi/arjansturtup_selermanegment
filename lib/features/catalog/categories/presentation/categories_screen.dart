import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_placeholder_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'دسته‌بندی‌ها',
      icon: Icons.category_rounded,
      description:
          'مدیریت دسته‌بندی‌های منو، مرتب‌سازی و حذف اینجا قرار می‌گیرد.',
    );
  }
}
