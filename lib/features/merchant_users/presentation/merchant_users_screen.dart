import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_placeholder_screen.dart';

class MerchantUsersScreen extends StatelessWidget {
  const MerchantUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'کاربران فروشگاه',
      icon: Icons.group_rounded,
      description: 'مدیریت اعضای تیم و سطح دسترسی آن‌ها اینجا قرار می‌گیرد.',
    );
  }
}
