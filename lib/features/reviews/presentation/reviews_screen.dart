import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_placeholder_screen.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'نظرات مشتریان',
      icon: Icons.star_rounded,
      description: 'نظرات، امتیازها و تاریخچه ارزیابی اینجا قرار می‌گیرد.',
    );
  }
}
