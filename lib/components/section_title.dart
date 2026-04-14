import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.alignment = CrossAxisAlignment.start,
  });

  final String title;
  final String? subtitle;

  /// Optional widget anchored to the far right (e.g. "See all" TextButton).
  final Widget? trailing;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(title, style: BabyMamaTypography.headlineMedium);

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailing != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: titleWidget),
              trailing!,
            ],
          )
        else
          titleWidget,
        if (subtitle != null) ...[
          const SizedBox(height: BabyMamaSpacing.xs),
          Text(
            subtitle!,
            style: BabyMamaTypography.bodyMedium,
          ),
        ],
      ],
    );
  }
}
