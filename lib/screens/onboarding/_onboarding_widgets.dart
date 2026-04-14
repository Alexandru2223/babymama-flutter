import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

// Shared bottom action bar used across all onboarding screens.

class OnboardingBottomAction extends StatelessWidget {
  const OnboardingBottomAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.hint,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? hint;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: BabyMamaColors.background,
        border: Border(
          top: BorderSide(color: BabyMamaColors.divider, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hint != null) ...[
            Text(
              hint!,
              style: BabyMamaTypography.bodySmall.copyWith(
                color: BabyMamaColors.neutral300,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.sm),
          ],
          PrimaryButton(label: label, onPressed: onPressed, isLoading: isLoading),
        ],
      ),
    );
  }
}
