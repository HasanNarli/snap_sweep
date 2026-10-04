import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/extensions/context_x.dart';

// Translucent blurred container (iOS material).
class Frosted extends StatelessWidget {
  const Frosted({
    super.key,
    required this.child,
    this.radius = 100,
    this.tint,
    this.borderColor,
    this.padding = EdgeInsets.zero,
    this.blur = 12,
  });

  final Widget child;
  final double radius;
  // Defaults to the dark photo glass.
  final Color? tint;
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
            color: tint ?? context.palette.photoGlass,
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
