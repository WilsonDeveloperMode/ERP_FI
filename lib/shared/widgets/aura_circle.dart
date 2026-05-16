import 'package:flutter/material.dart';

class AuraCircle extends StatelessWidget {
  const AuraCircle({required this.size, required this.colors, super.key});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
