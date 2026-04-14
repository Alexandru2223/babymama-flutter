import 'package:flutter/material.dart';
import '../../theme/theme.dart';

// Internal shared widgets for auth screens.

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, required this.onTap});
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

class SwitchAuthRow extends StatelessWidget {
  const SwitchAuthRow({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onTap,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$message ',
          style: BabyMamaTypography.bodyMedium.copyWith(
            color: BabyMamaColors.neutral500,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: BabyMamaTypography.labelMedium.copyWith(
              color: BabyMamaColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: BabyMamaColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
