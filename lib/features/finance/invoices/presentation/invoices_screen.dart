import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_placeholder_screen.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'فاکتورها',
      icon: Icons.description_rounded,
      description: 'لیست فاکتورهای دوره‌ای و وضعیت تسویه اینجا قرار می‌گیرد.',
    );
  }
}
