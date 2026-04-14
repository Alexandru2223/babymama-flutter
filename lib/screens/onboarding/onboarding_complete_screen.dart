import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

// ── Data passed from the last onboarding step ─

class OnboardingCompletionData {
  const OnboardingCompletionData({
    this.babyName,
    this.interests = const {},
    this.communities = const {},
  });

  final String? babyName;
  final Set<String> interests;
  final Set<String> communities;
}

// ── Step 6 / done — Completion ────────────────

class OnboardingCompleteScreen extends StatefulWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  State<OnboardingCompleteScreen> createState() =>
      _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends State<OnboardingCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Staggered intervals (all within 0→1 of _ctrl)
  late final Animation<double> _heroScale;
  late final Animation<double> _heroFade;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _ctaFade;
  late final Animation<Offset> _ctaSlide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    CurvedAnimation curve(double begin, double end, [Curve c = Curves.easeOutCubic]) =>
        CurvedAnimation(parent: _ctrl, curve: Interval(begin, end, curve: c));

    _heroScale = Tween(begin: 0.55, end: 1.0).animate(
        curve(0.0, 0.45, Curves.elasticOut));
    _heroFade  = Tween(begin: 0.0, end: 1.0).animate(curve(0.0, 0.3));

    _headlineFade  = Tween(begin: 0.0, end: 1.0).animate(curve(0.2, 0.5));
    _headlineSlide = Tween(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(curve(0.2, 0.5));

    _cardFade  = Tween(begin: 0.0, end: 1.0).animate(curve(0.4, 0.75));
    _cardSlide = Tween(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(curve(0.4, 0.75));

    _ctaFade  = Tween(begin: 0.0, end: 1.0).animate(curve(0.6, 0.9));
    _ctaSlide = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(curve(0.6, 0.9));

    // Small delay so the screen transition completes first
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments
        as OnboardingCompletionData? ?? const OnboardingCompletionData();

    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      body: Stack(
        children: [
          // ── Decorative background ──
          const _Background(),

          // ── Content ──
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      BabyMamaSpacing.xl2,
                      BabyMamaSpacing.xl5,
                      BabyMamaSpacing.xl2,
                      BabyMamaSpacing.xl6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hero medallion
                        FadeTransition(
                          opacity: _heroFade,
                          child: ScaleTransition(
                            scale: _heroScale,
                            child: const _HeroMedallion(),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // Headline block
                        FadeTransition(
                          opacity: _headlineFade,
                          child: SlideTransition(
                            position: _headlineSlide,
                            child: _HeadlineBlock(babyName: data.babyName),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl4),

                        // Summary card
                        FadeTransition(
                          opacity: _cardFade,
                          child: SlideTransition(
                            position: _cardSlide,
                            child: _SummaryCard(data: data),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // CTA
                FadeTransition(
                  opacity: _ctaFade,
                  child: SlideTransition(
                    position: _ctaSlide,
                    child: _CtaBar(onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (_) => false);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BACKGROUND
// ─────────────────────────────────────────────

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Top-right blush blob
      Positioned(
        top: -100,
        right: -80,
        child: _Blob(
          size: 320,
          color: BabyMamaColors.primaryLight.withValues(alpha: 0.22),
        ),
      ),
      // Left-center accent blob
      Positioned(
        top: 160,
        left: -100,
        child: _Blob(
          size: 220,
          color: BabyMamaColors.accent.withValues(alpha: 0.14),
        ),
      ),
      // Bottom-right sage blob
      Positioned(
        bottom: -80,
        right: -60,
        child: _Blob(
          size: 260,
          color: BabyMamaColors.secondary.withValues(alpha: 0.13),
        ),
      ),
    ]);
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

// ─────────────────────────────────────────────
// HERO MEDALLION
// ─────────────────────────────────────────────

class _HeroMedallion extends StatelessWidget {
  const _HeroMedallion();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      height: 156,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outermost ring — very translucent
          Container(
            width: 156,
            height: 156,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.primary.withValues(alpha: 0.12),
                width: 1,
              ),
              color: BabyMamaColors.primary.withValues(alpha: 0.04),
            ),
          ),
          // Middle ring
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
              color: BabyMamaColors.primary.withValues(alpha: 0.06),
            ),
          ),
          // Inner ring
          Container(
            width: 102,
            height: 102,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
              color: BabyMamaColors.primary.withValues(alpha: 0.08),
            ),
          ),
          // Core gradient circle
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  BabyMamaColors.accent,
                  BabyMamaColors.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40C4847A),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Color(0x20D4B896),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text('✦', style: TextStyle(fontSize: 28, height: 1)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADLINE BLOCK
// ─────────────────────────────────────────────

class _HeadlineBlock extends StatelessWidget {
  const _HeadlineBlock({this.babyName});
  final String? babyName;

  @override
  Widget build(BuildContext context) {
    final hasName = babyName != null && babyName!.isNotEmpty;

    return Column(
      children: [
        Text(
          hasName ? 'Bine ai venit,\n${babyName!}! 🌸' : 'Totul e pregătit! 🌸',
          textAlign: TextAlign.center,
          style: BabyMamaTypography.displayMedium.copyWith(height: 1.15),
        ),

        const SizedBox(height: BabyMamaSpacing.md),

        Text(
          'Profilul tău e creat.\nAventura abia începe.',
          textAlign: TextAlign.center,
          style: BabyMamaTypography.bodyLarge.copyWith(
            color: BabyMamaColors.neutral500,
            height: 1.7,
          ),
        ),

        const SizedBox(height: BabyMamaSpacing.xl2),

        // Ornament
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ornamentDash(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.md),
              child: Text(
                '✦',
                style: BabyMamaTypography.labelSmall.copyWith(
                  color: BabyMamaColors.accent,
                  fontSize: 13,
                ),
              ),
            ),
            _ornamentDash(),
          ],
        ),
      ],
    );
  }

  Widget _ornamentDash() => Container(
        width: 40,
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            BabyMamaColors.accent.withValues(alpha: 0.0),
            BabyMamaColors.accent.withValues(alpha: 0.5),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────
// SUMMARY CARD
// ─────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});
  final OnboardingCompletionData data;

  // Value → display label maps
  static const Map<String, String> _interestLabels = {
    'alaptare':   '🤱 Alăptare',
    'somn':       '😴 Somn',
    'alimentatie':'🍼 Alimentație',
    'dezvoltare': '🧸 Dezvoltare',
    'recuperare': '💪 Recuperare',
    'sanatate':   '🧠 Sănătate mintală',
    'rutine':     '📋 Rutine',
    'ingrijire':  '✨ Îngrijire personală',
  };

  static const Map<String, String> _communityLabels = {
    'nou-nascuti':     '👶 Nou-născuți',
    'bebelusi-mici':   '🌱 Bebeluși mici',
    'bebelusi-activi': '🌟 Bebeluși activi',
    'copii-mici':      '🧒 Copii mici',
    'alapteaza':       '🤱 Alăptare',
    'recuperare':      '💪 Recuperare',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(color: BabyMamaColors.neutral100, width: 1),
        boxShadow: BabyMamaShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              BabyMamaSpacing.xl2,
              BabyMamaSpacing.xl2,
              BabyMamaSpacing.xl2,
              BabyMamaSpacing.lg,
            ),
            child: Text(
              'REZUMATUL TĂU',
              style: BabyMamaTypography.labelSmall.copyWith(
                letterSpacing: 1.2,
                color: BabyMamaColors.neutral300,
              ),
            ),
          ),

          const _CardDivider(),

          // Baby section
          _BabyRow(name: data.babyName),

          const _CardDivider(),

          // Interests section
          _ChipSection(
            icon: Icons.favorite_border_rounded,
            label: 'Interese',
            values: data.interests,
            labelMap: _interestLabels,
            emptyText: 'Poți adăuga din profilul tău',
          ),

          const _CardDivider(),

          // Communities section
          _ChipSection(
            icon: Icons.people_outline_rounded,
            label: 'Comunități',
            values: data.communities,
            labelMap: _communityLabels,
            emptyText: 'Poți alege mai târziu',
          ),

          const SizedBox(height: BabyMamaSpacing.xl2),
        ],
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(color: BabyMamaColors.divider, thickness: 1, height: 1);
}

// ── Baby row inside summary card ──────────────

class _BabyRow extends StatelessWidget {
  const _BabyRow({this.name});
  final String? name;

  @override
  Widget build(BuildContext context) {
    final hasName = name != null && name!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
      ),
      child: Row(
        children: [
          // Avatar bubble
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [BabyMamaColors.primaryLight, BabyMamaColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: hasName
                  ? Text(
                      name![0].toUpperCase(),
                      style: BabyMamaTypography.titleLarge.copyWith(
                        color: BabyMamaColors.onPrimary,
                        height: 1,
                      ),
                    )
                  : const Text('👶', style: TextStyle(fontSize: 20)),
            ),
          ),

          const SizedBox(width: BabyMamaSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasName ? name! : 'Bebelușul tău',
                  style: BabyMamaTypography.titleMedium,
                ),
                const SizedBox(height: BabyMamaSpacing.xs2),
                Text(
                  'Profil creat cu succes',
                  style: BabyMamaTypography.bodySmall.copyWith(
                    color: BabyMamaColors.success,
                  ),
                ),
              ],
            ),
          ),

          // Check badge
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: BabyMamaColors.successLight,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 16,
              color: BabyMamaColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip section inside summary card ──────────

class _ChipSection extends StatelessWidget {
  const _ChipSection({
    required this.icon,
    required this.label,
    required this.values,
    required this.labelMap,
    required this.emptyText,
  });

  final IconData icon;
  final String label;
  final Set<String> values;
  final Map<String, String> labelMap;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final isEmpty = values.isEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Icon(icon, size: 14, color: BabyMamaColors.neutral500),
              const SizedBox(width: BabyMamaSpacing.xs),
              Text(
                label,
                style: BabyMamaTypography.labelSmall.copyWith(
                  color: BabyMamaColors.neutral500,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),

          const SizedBox(height: BabyMamaSpacing.sm),

          if (isEmpty)
            Text(
              emptyText,
              style: BabyMamaTypography.bodySmall.copyWith(
                color: BabyMamaColors.neutral300,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: BabyMamaSpacing.sm,
              runSpacing: BabyMamaSpacing.sm,
              children: values.map((v) {
                final display = labelMap[v] ?? v;
                return _SummaryChip(label: display);
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BabyMamaSpacing.md,
        vertical: BabyMamaSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: BabyMamaColors.surfaceVariant,
        borderRadius: BabyMamaRadius.fullAll,
        border: Border.all(
          color: BabyMamaColors.primaryLight.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: BabyMamaTypography.labelSmall.copyWith(
          color: BabyMamaColors.primaryDark,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CTA BAR
// ─────────────────────────────────────────────

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.onPressed});
  final VoidCallback onPressed;

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
      child: PrimaryButton(
        label: 'Intră în aplicație  ✦',
        onPressed: onPressed,
      ),
    );
  }
}

