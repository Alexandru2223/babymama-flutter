import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────
// SELECTABLE CARD  (interests, options)
// ─────────────────────────────────────────────

class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.emoji,
    this.icon,
    this.imageUrl,
  }) : assert(
          emoji != null || icon != null || imageUrl != null || true,
          'Provide at most one of emoji, icon, or imageUrl',
        );

  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final String? subtitle;

  /// Mutually exclusive visual options — priority: imageUrl > emoji > icon
  final String? emoji;
  final IconData? icon;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? BabyMamaColors.surfaceVariant : BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.card,
        border: Border.all(
          color: isSelected ? BabyMamaColors.primary : BabyMamaColors.neutral100,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected ? BabyMamaShadows.sm : BabyMamaShadows.xs,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BabyMamaRadius.card,
          splashColor: BabyMamaColors.primaryLight.withValues(alpha: 0.2),
          highlightColor: BabyMamaColors.primaryLight.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(BabyMamaSpacing.lg),
            child: Row(
              children: [
                _Leading(emoji: emoji, icon: icon, imageUrl: imageUrl, selected: isSelected),
                const SizedBox(width: BabyMamaSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: BabyMamaTypography.titleMedium.copyWith(
                          color: isSelected
                              ? BabyMamaColors.primaryDark
                              : BabyMamaColors.neutral900,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: BabyMamaSpacing.xs2),
                        Text(subtitle!, style: BabyMamaTypography.bodySmall),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: BabyMamaSpacing.sm),
                _Checkmark(visible: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({this.emoji, this.icon, this.imageUrl, required this.selected});
  final String? emoji;
  final IconData? icon;
  final String? imageUrl;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (imageUrl != null) {
      content = ClipOval(
        child: Image.network(imageUrl!, width: 40, height: 40, fit: BoxFit.cover),
      );
    } else if (emoji != null) {
      content = Text(emoji!, style: const TextStyle(fontSize: 24));
    } else if (icon != null) {
      content = Icon(
        icon,
        size: 22,
        color: selected ? BabyMamaColors.primary : BabyMamaColors.neutral500,
      );
    } else {
      return const SizedBox.shrink();
    }

    return SizedBox(width: 40, height: 40, child: Center(child: content));
  }
}

class _Checkmark extends StatelessWidget {
  const _Checkmark({required this.visible});
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.elasticOut,
      child: Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: BabyMamaColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, size: 14, color: BabyMamaColors.onPrimary),
      ),
    );
  }
}
