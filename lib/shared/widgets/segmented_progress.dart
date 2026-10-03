import 'package:flutter/material.dart';

// Stories-style progress: one segment per item.
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({
    super.key,
    required this.count,
    required this.done,
    required this.color,
    required this.trackColor,
  });

  final int count;
  final int done;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 4,
              decoration: BoxDecoration(
                color: i < done ? color : trackColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
