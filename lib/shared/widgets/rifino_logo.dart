import 'package:flutter/material.dart';

class RifinoLogo extends StatelessWidget {
  const RifinoLogo({
    this.width = 128,
    this.height = 88,
    super.key,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logoapp.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Text(
        'Rifino',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}

