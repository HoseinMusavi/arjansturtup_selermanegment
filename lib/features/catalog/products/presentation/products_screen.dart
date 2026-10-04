import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_placeholder_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'محصولات',
      icon: Icons.fastfood_rounded,
      description:
          'لیست کالاها، ویرایشگر بخش‌بندی‌شده و بارگذاری تصاویر اینجا قرار می‌گیرد.',
    );
  }
}
