import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────
// PROGRESS HEADER  (onboarding steps)
// ─────────────────────────────────────────────

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.title,
    this.onBack,
  }) : assert(currentStep >= 1 && currentStep <= totalSteps);

  final int currentStep;
  final int totalSteps;
  final String? title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Back button + step label row
        Row(
          children: [
            if (onBack != null)
              _BackButton(onTap: onBack!)
            else
              const SizedBox(width: 40),
            const Spacer(),
            Text(
              '$currentStep of $totalSteps',
              style: BabyMamaTypography.labelSmall.copyWith(
                color: BabyMamaColors.neutral500,
              ),
            ),
          ],
        ),

        const SizedBox(height: BabyMamaSpacing.md),

        // Segmented progress bar
        _StepBar(current: currentStep, total: totalSteps),

        if (title != null) ...[
          const SizedBox(height: BabyMamaSpacing.xl3),
          Text(title!, style: BabyMamaTypography.displaySmall),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: BabyMamaColors.neutral100,
          borderRadius: BabyMamaRadius.fullAll,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: BabyMamaColors.neutral700,
        ),
      ),
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isFilled = index < current;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 3,
            margin: EdgeInsets.only(right: index < total - 1 ? BabyMamaSpacing.xs : 0),
            decoration: BoxDecoration(
              color: isFilled ? BabyMamaColors.primary : BabyMamaColors.neutral100,
              borderRadius: BabyMamaRadius.fullAll,
            ),
          ),
        );
      }),
    );
  }
}
