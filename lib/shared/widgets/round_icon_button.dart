import 'package:flutter/material.dart';

import '../../core/extensions/context_x.dart';

// Tactile circular control: white disc, hairline border, soft shadow.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
    this.size = 60,
    this.iconSize,
    this.plain = false,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final double? iconSize;

  // No disc, border or shadow (toolbar use).
  final bool plain;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Tooltip(
      message: tooltip,
      child: AnimatedOpacity(
        opacity: onPressed == null ? 0.4 : 1,
        duration: const Duration(milliseconds: 150),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: plain ? null : palette.buttonShadow,
          ),
          child: Material(
            color: plain ? Colors.transparent : palette.surface,
            shape: CircleBorder(
              side: plain
                  ? BorderSide.none
                  : BorderSide(color: palette.border.withValues(alpha: 0.7)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox.square(
                dimension: size,
                child: Icon(icon, color: color, size: iconSize ?? size * 0.36),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
