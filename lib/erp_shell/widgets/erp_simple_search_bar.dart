import 'package:flutter/material.dart';

class ErpSimpleSearchBar extends StatelessWidget {
  const ErpSimpleSearchBar({
    required this.hint,
    this.controller,
    this.onChanged,
    super.key,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
