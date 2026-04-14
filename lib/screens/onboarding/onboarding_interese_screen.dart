import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import '_onboarding_widgets.dart';

// ── Step 1 / 5 — Interese principale ──────────

class OnboardingIntereseScreen extends StatefulWidget {
  const OnboardingIntereseScreen({super.key});

  @override
  State<OnboardingIntereseScreen> createState() =>
      _OnboardingIntereseScreenState();
}

class _OnboardingIntereseScreenState extends State<OnboardingIntereseScreen> {
  final Set<String> _selected = {};
  bool _isLoading = false;

  static const _interests = [
    _Interest('🤱', 'Alăptare',           'alaptare'),
    _Interest('😴', 'Somn',               'somn'),
    _Interest('🍼', 'Alimentație',         'alimentatie'),
    _Interest('🧸', 'Dezvoltare',          'dezvoltare'),
    _Interest('💪', 'Recuperare',          'recuperare'),
    _Interest('🧠', 'Sănătate mintală',    'sanatate'),
    _Interest('📋', 'Rutine',              'rutine'),
    _Interest('✨', 'Îngrijire personală', 'ingrijire'),
  ];

  Future<void> _continue() async {
    setState(() => _isLoading = true);
    try {
      await onboardingService
          .savePreferences({'mainInterests': _selected.toList()});
      if (mounted) Navigator.pushNamed(context, '/onboarding/baby');
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
                currentStep: 1,
                totalSteps: 5,
                title: 'Ce te\ninteresează?',
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
                      'Alege tot ce te definește. Poți schimba oricând.',
                      style: BabyMamaTypography.bodyMedium,
                    ),

                    const SizedBox(height: BabyMamaSpacing.xl3),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: BabyMamaSpacing.md,
                        crossAxisSpacing: BabyMamaSpacing.md,
                        childAspectRatio: 1.25,
                      ),
                      itemCount: _interests.length,
                      itemBuilder: (_, i) {
                        final item = _interests[i];
                        final selected = _selected.contains(item.value);
                        return _InterestTile(
                          interest: item,
                          isSelected: selected,
                          onTap: () => setState(() {
                            selected
                                ? _selected.remove(item.value)
                                : _selected.add(item.value);
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom button ──
            OnboardingBottomAction(
              label: 'Continuă',
              isLoading: _isLoading,
              onPressed: _selected.isNotEmpty ? _continue : null,
              hint: _selected.isEmpty ? 'Alege cel puțin un interes' : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────

class _Interest {
  const _Interest(this.emoji, this.label, this.value);
  final String emoji;
  final String label;
  final String value;
}

// ── 2-column compact interest tile ───────────

class _InterestTile extends StatelessWidget {
  const _InterestTile({
    required this.interest,
    required this.isSelected,
    required this.onTap,
  });

  final _Interest interest;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? BabyMamaColors.surfaceVariant
            : BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.card,
        border: Border.all(
          color:
              isSelected ? BabyMamaColors.primary : BabyMamaColors.neutral100,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  interest.emoji,
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(height: BabyMamaSpacing.sm),
                Text(
                  interest.label,
                  textAlign: TextAlign.center,
                  style: BabyMamaTypography.titleSmall.copyWith(
                    color: isSelected
                        ? BabyMamaColors.primaryDark
                        : BabyMamaColors.neutral700,
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
