import 'package:flutter/material.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';

// Grouped list card with an optional uppercase header.
class GroupedSection extends StatelessWidget {
  const GroupedSection({
    super.key,
    required this.children,
    this.header,
    this.headerTrailing,
  });

  final List<Widget> children;
  final String? header;
  final String? headerTrailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              0,
              AppSpacing.xs,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    header!.toUpperCase(),
                    style: textTheme.labelSmall,
                  ),
                ),
                if (headerTrailing != null)
                  Text(headerTrailing!, style: textTheme.labelMedium),
              ],
            ),
          ),
        Container(
          decoration: palette.card(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(color: palette.border.withValues(alpha: 0.6)),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class GroupedRow extends StatelessWidget {
  const GroupedRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    this.locked = false,
    this.enabled = true,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? badge;
  final bool locked;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              IconTile(icon: icon),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 6),
                          badge!,
                        ],
                      ],
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (locked) ...[
                Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: palette.tertiaryLabel,
                ),
                const SizedBox(width: 6),
              ],
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: palette.tertiaryLabel,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Neutral rounded-square icon holder.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    this.size = 40,
    this.round = false,
  });

  final IconData icon;
  final double size;
  final bool round;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: palette.fill,
        borderRadius: round ? null : BorderRadius.circular(size * 0.3),
        shape: round ? BoxShape.circle : BoxShape.rectangle,
        border: round
            ? Border.all(color: palette.border.withValues(alpha: 0.6))
            : null,
      ),
      child: Icon(icon, color: palette.label, size: size * 0.48),
    );
  }
}

// Small square tag, e.g. "Pro" or "Soon".
class TagLabel extends StatelessWidget {
  const TagLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: palette.track,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: palette.secondaryLabel,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
