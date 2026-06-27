import 'package:flutter/material.dart';

import '../widgets/erp_panel.dart';

class PlaceholderWorkspacePage extends StatelessWidget {
  const PlaceholderWorkspacePage({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ErpPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 18),
              Text(
                'This module is ready for the next implementation pass in the same ERP shell.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
