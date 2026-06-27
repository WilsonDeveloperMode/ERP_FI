import 'package:flutter/material.dart';

import 'package:erp_fi/theme/app_colors.dart';
import 'erp_status_badge.dart';

class ErpDataTableCard extends StatelessWidget {
  const ErpDataTableCard({
    required this.columns,
    required this.rows,
    this.statusColumn,
    super.key,
  });

  final List<String> columns;
  final List<List<String>> rows;
  final int? statusColumn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          dataTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.ink,
          ),
          columns: columns
              .map((column) => DataColumn(label: Text(column)))
              .toList(),
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value;

                    if (statusColumn == index) {
                      return DataCell(ErpStatusBadge(value: value));
                    }
                    return DataCell(Text(value));
                  }).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
