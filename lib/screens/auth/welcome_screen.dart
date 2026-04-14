import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      body: Stack(
        children: [
          // ── Decorative background circles ──
          Positioned(
            top: -80,
            right: -60,
            child: _DecorativeCircle(
              size: 280,
              color: BabyMamaColors.primaryLight.withValues(alpha: 0.25),
            ),
          ),
          Positioned(
            top: 60,
            right: 30,
            child: _DecorativeCircle(
              size: 120,
              color: BabyMamaColors.accent.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _DecorativeCircle(
              size: 260,
              color: BabyMamaColors.secondary.withValues(alpha: 0.15),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.xl2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),

                  // Tag pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BabyMamaSpacing.md,
                      vertical: BabyMamaSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: BabyMamaColors.primaryLight.withValues(alpha: 0.35),
                      borderRadius: BabyMamaRadius.fullAll,
                    ),
                    child: Text(
                      '✦  pentru mame moderne',
                      style: BabyMamaTypography.labelSmall.copyWith(
                        color: BabyMamaColors.primaryDark,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  const SizedBox(height: BabyMamaSpacing.xl2),

                  // App name
                  Text(
                    'babymama',
                    style: BabyMamaTypography.displayLarge.copyWith(
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      color: BabyMamaColors.neutral900,
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: BabyMamaSpacing.lg),

                  // Tagline
                  Text(
                    'Tot ce ai nevoie ca mamă,\nîntr-un singur loc.',
                    style: BabyMamaTypography.bodyLarge.copyWith(
                      color: BabyMamaColors.neutral500,
                      height: 1.7,
                    ),
                  ),

                  const Spacer(flex: 4),

                  // Buttons
                  PrimaryButton(
                    label: 'Creează un cont',
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                  ),

                  const SizedBox(height: BabyMamaSpacing.md),

                  SecondaryButton(
                    label: 'Intră în cont',
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),

                  const SizedBox(height: BabyMamaSpacing.xl2),

                  // Terms note
                  Center(
                    child: Text(
                      'Continuând, ești de acord cu Termenii și\nPolitica de Confidențialitate.',
                      textAlign: TextAlign.center,
                      style: BabyMamaTypography.bodySmall.copyWith(
                        color: BabyMamaColors.neutral300,
                      ),
                    ),
                  ),

                  const SizedBox(height: BabyMamaSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
