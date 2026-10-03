import 'dart:ui';

import 'package:flutter/material.dart';

// Translucent blurred container (iOS material).
class Frosted extends StatelessWidget {
  const Frosted({
    super.key,
    required this.child,
    this.radius = 100,
    this.tint = const Color(0x33000000),
    this.padding = EdgeInsets.zero,
    this.blur = 20,
  });

  final Widget child;
  final double radius;
  final Color tint;
  final EdgeInsetsGeometry padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: ColoredBox(
          color: tint,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
