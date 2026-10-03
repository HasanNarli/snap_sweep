import 'dart:ui';

import 'package:flutter/material.dart';

// Translucent blurred container (iOS material).
class Frosted extends StatelessWidget {
  const Frosted({
    super.key,
    required this.child,
    this.radius = 100,
    this.tint = const Color(0x66000000),
    this.borderColor,
    this.padding = EdgeInsets.zero,
    this.blur = 12,
  });

  final Widget child;
  final double radius;
  final Color tint;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: shape,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint,
            borderRadius: shape,
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
