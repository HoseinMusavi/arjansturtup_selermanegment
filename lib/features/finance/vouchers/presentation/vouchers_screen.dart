import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_placeholder_screen.dart';

class VouchersScreen extends StatelessWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'کدهای تخفیف',
      icon: Icons.local_offer_rounded,
      description: 'مدیریت کدهای تخفیف، نوع و تاریخ انقضا اینجا قرار می‌گیرد.',
    );
  }
}
