import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/models/erp_record_models.dart';
import 'package:erp_fi/theme/app_colors.dart';

class ErpKeyValueGrid extends StatelessWidget {
  const ErpKeyValueGrid({required this.entries, super.key});

  final List<KeyValueEntry> entries;

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.sizeOf(context).width >= 900 ? 2 : 1;

    return GridView.builder(
      itemCount: entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.2,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceTint,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(entry.value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      },
    );
  }
}
