import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_placeholder_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'سفارش‌ها',
      icon: Icons.receipt_long_rounded,
      description:
          'فید قابل‌فیلتر سفارش‌ها، جزئیات و تغییر وضعیت اینجا قرار می‌گیرد.',
    );
  }
}
