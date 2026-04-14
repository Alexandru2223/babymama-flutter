import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import '_onboarding_widgets.dart';

// ── Step 4 / 5 — Notificări ───────────────────

class OnboardingNotificariScreen extends StatefulWidget {
  const OnboardingNotificariScreen({super.key});

  @override
  State<OnboardingNotificariScreen> createState() =>
      _OnboardingNotificariScreenState();
}

class _OnboardingNotificariScreenState
    extends State<OnboardingNotificariScreen> {
  bool _isLoading = false;

  final Map<String, bool> _enabled = {
    'hranire':    true,
    'somn':       true,
    'sfat':       true,
    'articole':   false,
    'comunitate': false,
  };

  static const _options = [
    _NotifOption(
      Icons.restaurant_outlined,
      'Memento hrănire',
      'Reminder la intervalul ales de tine',
      'hranire',
    ),
    _NotifOption(
      Icons.bedtime_outlined,
      'Memento somn',
      'Te anunțăm când e ora somnului',
      'somn',
    ),
    _NotifOption(
      Icons.lightbulb_outline_rounded,
      'Sfat zilnic',
      'Un sfat util în fiecare dimineață',
      'sfat',
    ),
    _NotifOption(
      Icons.article_outlined,
      'Articole noi',
      'Conținut relevant pentru vârsta bebelușului',
      'articole',
    ),
    _NotifOption(
      Icons.people_outline_rounded,
      'Activitate în comunitate',
      'Mesaje și răspunsuri noi',
      'comunitate',
    ),
  ];

  Future<void> _continue() async {
    setState(() => _isLoading = true);
    try {
      final anyEnabled = _enabled.values.any((v) => v);
      await onboardingService
          .savePreferences({'notificationsEnabled': anyEnabled});
      if (mounted) Navigator.pushNamed(context, '/onboarding/comunitati');
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
                currentStep: 4,
                totalSteps: 5,
                title: 'Rămâi\nla curent',
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
                      'Alege ce notificări primești. Poți modifica oricând din setări.',
                      style: BabyMamaTypography.bodyMedium,
                    ),

                    const SizedBox(height: BabyMamaSpacing.xl3),

                    ..._options.map((opt) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: BabyMamaSpacing.md),
                          child: _NotifCard(
                            option: opt,
                            isEnabled: _enabled[opt.value] ?? false,
                            onToggle: (val) =>
                                setState(() => _enabled[opt.value] = val),
                          ),
                        )),
                  ],
                ),
              ),
            ),

            // ── Bottom button ──
            OnboardingBottomAction(
              label: 'Continuă',
              isLoading: _isLoading,
              onPressed: _continue,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────

class _NotifOption {
  const _NotifOption(this.icon, this.label, this.description, this.value);
  final IconData icon;
  final String label;
  final String description;
  final String value;
}

// ── Notification toggle card ──────────────────

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.option,
    required this.isEnabled,
    required this.onToggle,
  });

  final _NotifOption option;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isEnabled ? BabyMamaColors.surfaceVariant : BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.card,
        border: Border.all(
          color: isEnabled ? BabyMamaColors.primary : BabyMamaColors.neutral100,
          width: isEnabled ? 1.5 : 1,
        ),
        boxShadow: isEnabled ? BabyMamaShadows.sm : BabyMamaShadows.xs,
      ),
      child: InkWell(
        onTap: () => onToggle(!isEnabled),
        borderRadius: BabyMamaRadius.card,
        splashColor: BabyMamaColors.primaryLight.withValues(alpha: 0.15),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BabyMamaSpacing.lg,
            vertical: BabyMamaSpacing.md + 2,
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? BabyMamaColors.primaryLight.withValues(alpha: 0.3)
                      : BabyMamaColors.neutral100,
                  borderRadius: BabyMamaRadius.smAll,
                ),
                child: Icon(
                  option.icon,
                  size: 20,
                  color: isEnabled
                      ? BabyMamaColors.primaryDark
                      : BabyMamaColors.neutral500,
                ),
              ),

              const SizedBox(width: BabyMamaSpacing.md),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: BabyMamaTypography.titleMedium.copyWith(
                        color: isEnabled
                            ? BabyMamaColors.primaryDark
                            : BabyMamaColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: BabyMamaSpacing.xs2),
                    Text(
                      option.description,
                      style: BabyMamaTypography.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: BabyMamaSpacing.sm),

              // Toggle
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
