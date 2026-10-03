import 'package:flutter/material.dart';

import '../../core/extensions/context_x.dart';

// Circular action button used under the swipe card stack.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
    this.size = 64,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: context.theme.colorScheme.surface,
        shape: CircleBorder(side: BorderSide(color: context.palette.border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: Icon(icon, color: color, size: size * 0.45),
          ),
        ),
      ),
    );
  }
}
