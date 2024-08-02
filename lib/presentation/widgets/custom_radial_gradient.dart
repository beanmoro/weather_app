import 'package:flutter/material.dart';

class CustomRadialGradient extends StatelessWidget {
  final List<double>? stops;
  final List<Color> colors;

  const CustomRadialGradient({super.key, required this.colors, this.stops});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
