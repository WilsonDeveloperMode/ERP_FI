import 'package:flutter/material.dart';

import 'package:erp_fi/theme/app_colors.dart';

class BrandPanel extends StatelessWidget {
  const BrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return Container(
      padding: EdgeInsets.all(isCompact ? 24 : 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6EFE7), Color(0xFFEFE4D6), Color(0xFFE5D4C2)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x33FFFFFF),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0x55B19174)),
            ),
            child: Text(
              'Francis Interior ERP',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Image.asset(
            'assets/images/francis-interior-logo.png',
            fit: BoxFit.contain,
            height: isCompact ? 130 : 160,
          ),
          const SizedBox(height: 26),
          Text(
            'Francis Interior',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: isCompact ? 40 : 52,
              color: AppColors.ink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Interior ERP',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Designed for premium interior operations with one workflow from customer onboarding to installation.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
