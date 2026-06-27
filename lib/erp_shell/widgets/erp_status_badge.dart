import 'package:flutter/material.dart';

import 'package:erp_fi/theme/app_colors.dart';

class ErpStatusBadge extends StatelessWidget {
  const ErpStatusBadge({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    final color = switch (value) {
      'Active' => AppColors.success,
      'Paid' => AppColors.success,
      'Completed' => AppColors.success,
      'Pending' => AppColors.warning,
      'Prospect' => AppColors.warning,
      'Onboarding' => AppColors.secondary,
      _ => AppColors.secondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}
