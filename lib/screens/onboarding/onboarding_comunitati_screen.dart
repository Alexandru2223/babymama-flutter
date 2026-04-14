import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import '_onboarding_widgets.dart';
import 'onboarding_complete_screen.dart';

// ── Step 5 / 5 — Comunități ───────────────────

class OnboardingComunitatiScreen extends StatefulWidget {
  const OnboardingComunitatiScreen({super.key});

  @override
  State<OnboardingComunitatiScreen> createState() =>
      _OnboardingComunitatiScreenState();
}

class _OnboardingComunitatiScreenState
    extends State<OnboardingComunitatiScreen> {
  final Set<String> _selected = {};
  bool _isLoading = false;

  static const _communities = [
    _Community('👶', 'Nou-născuți',              '0 – 3 luni',       '2.4k mămici',  'nou-nascuti'),
    _Community('🌱', 'Bebeluși mici',            '3 – 6 luni',       '3.1k mămici',  'bebelusi-mici'),
    _Community('🌟', 'Bebeluși activi',          '6 – 12 luni',      '4.8k mămici',  'bebelusi-activi'),
    _Community('🧒', 'Copii mici',               '1 – 2 ani',        '3.6k mămici',  'copii-mici'),
    _Community('🤱', 'Mame care alăptează',      'La orice vârstă',  '5.2k mămici',  'alapteaza'),
    _Community('💪', 'Recuperare postnatală',    'Corp & minte',     '1.9k mămici',  'recuperare'),
  ];

  Future<void> _finish() async {
    setState(() => _isLoading = true);
    try {
      await onboardingService
          .savePreferences({'joinedCommunities': _selected.toList()});
      final snapshot = await onboardingService.complete();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/onboarding/complete',
          (_) => false,
          arguments: OnboardingCompletionData(
            babyName: snapshot.babyName,
            interests: snapshot.interests,
            communities: snapshot.communities,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eroare de rețea. Încearcă din nou.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Progress header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                BabyMamaSpacing.xl2,
                BabyMamaSpacing.lg,
                BabyMamaSpacing.xl2,
                0,
              ),
              child: ProgressHeader(
                currentStep: 5,
                totalSteps: 5,
                title: 'Alătură-te\ncomunității',
                onBack: () => Navigator.pop(context),
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  BabyMamaSpacing.xl2,
                  BabyMamaSpacing.lg,
                  BabyMamaSpacing.xl2,
                  BabyMamaSpacing.xl6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Găsești mame ca tine, gata să se susțină reciproc.',
                      style: BabyMamaTypography.bodyMedium,
                    ),

                    const SizedBox(height: BabyMamaSpacing.xl3),

                    ..._communities.map((c) {
                      final selected = _selected.contains(c.value);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: BabyMamaSpacing.md),
                        child: _CommunityCard(
                          community: c,
                          isSelected: selected,
                          onTap: () => setState(() {
                            selected
                                ? _selected.remove(c.value)
                                : _selected.add(c.value);
                          }),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ── Bottom button ──
            OnboardingBottomAction(
              label: 'Hai să începem! ✦',
              isLoading: _isLoading,
              onPressed: _finish,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────

class _Community {
  const _Community(
      this.emoji, this.name, this.subtitle, this.members, this.value);
  final String emoji;
  final String name;
  final String subtitle;
  final String members;
  final String value;
}

// ── Community card ────────────────────────────

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({
    required this.community,
    required this.isSelected,
    required this.onTap,
  });

  final _Community community;
  final bool isSelected;
  final VoidCallback onTap;

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
          child: Padding(
            padding: const EdgeInsets.all(BabyMamaSpacing.lg),
            child: Row(
              children: [
                // Emoji bubble
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? BabyMamaColors.primaryLight.withValues(alpha: 0.35)
                        : BabyMamaColors.neutral50,
                    borderRadius: BabyMamaRadius.smAll,
                  ),
                  child: Center(
                    child: Text(
                      community.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),

                const SizedBox(width: BabyMamaSpacing.md),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: BabyMamaTypography.titleMedium.copyWith(
                          color: isSelected
                              ? BabyMamaColors.primaryDark
                              : BabyMamaColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: BabyMamaSpacing.xs2),
                      Text(
                        community.subtitle,
                        style: BabyMamaTypography.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Members pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BabyMamaSpacing.sm,
                    vertical: BabyMamaSpacing.xs2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? BabyMamaColors.primary.withValues(alpha: 0.12)
                        : BabyMamaColors.neutral100,
                    borderRadius: BabyMamaRadius.fullAll,
                  ),
                  child: Text(
                    community.members,
                    style: BabyMamaTypography.labelSmall.copyWith(
                      color: isSelected
                          ? BabyMamaColors.primaryDark
                          : BabyMamaColors.neutral500,
                    ),
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
