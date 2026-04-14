import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────
// CHIP SELECTOR  (single or multi-select tags)
// ─────────────────────────────────────────────

class ChipOption {
  const ChipOption({required this.value, required this.label, this.emoji});
  final String value;
  final String label;
  final String? emoji;
}

class ChipSelector extends StatelessWidget {
  const ChipSelector({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.multiSelect = true,
    this.spacing = BabyMamaSpacing.sm,
    this.runSpacing = BabyMamaSpacing.sm,
  });

  final List<ChipOption> options;
  final Set<String> selectedValues;

  /// Called with the full updated set after each tap.
  final ValueChanged<Set<String>> onChanged;

  /// false = single-select (radio behaviour)
  final bool multiSelect;
  final double spacing;
  final double runSpacing;

  void _handleTap(String value) {
    final next = Set<String>.from(selectedValues);

    if (multiSelect) {
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
    } else {
      next
        ..clear()
        ..add(value);
    }

    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: options.map((option) {
        final selected = selectedValues.contains(option.value);
        return _BabyChip(
          option: option,
          isSelected: selected,
          onTap: () => _handleTap(option.value),
        );
      }).toList(),
    );
  }
}

class _BabyChip extends StatelessWidget {
  const _BabyChip({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final ChipOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? BabyMamaColors.primary : BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.fullAll,
        border: Border.all(
          color: isSelected ? BabyMamaColors.primary : BabyMamaColors.neutral300,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BabyMamaRadius.fullAll,
          splashColor: BabyMamaColors.primaryLight.withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BabyMamaSpacing.lg,
              vertical: BabyMamaSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option.emoji != null) ...[
                  Text(option.emoji!, style: const TextStyle(fontSize: 15)),
                  const SizedBox(width: BabyMamaSpacing.xs),
                ],
                Text(
                  option.label,
                  style: BabyMamaTypography.labelMedium.copyWith(
                    color: isSelected
                        ? BabyMamaColors.onPrimary
                        : BabyMamaColors.neutral700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
