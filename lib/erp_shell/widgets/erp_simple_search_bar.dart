import 'package:flutter/material.dart';

class ErpSimpleSearchBar extends StatelessWidget {
  const ErpSimpleSearchBar({required this.hint, super.key});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
