import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import '_onboarding_widgets.dart';

// ── Step 3 / 5 — Ce vrei să urmărești ────────

class OnboardingTrackingScreen extends StatefulWidget {
  const OnboardingTrackingScreen({super.key});

  @override
  State<OnboardingTrackingScreen> createState() =>
      _OnboardingTrackingScreenState();
}

class _OnboardingTrackingScreenState extends State<OnboardingTrackingScreen> {
  final Set<String> _selected = {};
  bool _isLoading = false;

  static const _options = [
    _TrackOption('🤱', 'Alăptare & hrănire',    'Ore, cantitate, biberon vs. sân',      'alaptat'),
    _TrackOption('😴', 'Somn',                   'Durata și calitatea somnului',          'somn'),
    _TrackOption('🚿', 'Schimbat scutec',         'Frecvență și observații',               'scutec'),
    _TrackOption('⚖️', 'Greutate',               'Curba de creștere',                     'greutate'),
    _TrackOption('📏', 'Înălțime',               'Evoluție lunară',                       'inaltime'),
    _TrackOption('💊', 'Medicamente',             'Doze și orare',                         'medicamente'),
    _TrackOption('🌟', 'Etape de dezvoltare',    'Prima zâmbetă, primii pași…',           'etape'),
  ];

  Future<void> _continue() async {
    setState(() => _isLoading = true);
    try {
      await onboardingService
          .savePreferences({'trackingPreferences': _selected.toList()});
      if (mounted) Navigator.pushNamed(context, '/onboarding/notificari');
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
                currentStep: 3,
                totalSteps: 5,
                title: 'Ce vrei să\nurmărești?',
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
                      'Selectează ce vrei să monitorizezi zilnic.',
                      style: BabyMamaTypography.bodyMedium,
                    ),

                    const SizedBox(height: BabyMamaSpacing.xl3),

                    ..._options.map((opt) {
                      final selected = _selected.contains(opt.value);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: BabyMamaSpacing.md),
                        child: SelectableCard(
                          title: opt.label,
                          subtitle: opt.description,
                          emoji: opt.emoji,
                          isSelected: selected,
                          onTap: () => setState(() {
                            selected
                                ? _selected.remove(opt.value)
                                : _selected.add(opt.value);
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
              label: 'Continuă',
              isLoading: _isLoading,
              onPressed: _selected.isNotEmpty ? _continue : null,
              hint: _selected.isEmpty ? 'Alege cel puțin o opțiune' : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackOption {
  const _TrackOption(this.emoji, this.label, this.description, this.value);
  final String emoji;
  final String label;
  final String description;
  final String value;
}
