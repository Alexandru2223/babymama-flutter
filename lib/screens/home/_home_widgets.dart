import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import 'home_models.dart';

// ─────────────────────────────────────────────
// 1. HOME HEADER
// ─────────────────────────────────────────────

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.subgreeting,
  });

  /// Server-rendered Romanian greeting, e.g. "Bună dimineața, Sofia!"
  final String greeting;

  /// Secondary line, e.g. "Iată cum se descurcă Ana astăzi"
  final String subgreeting;

  /// Extracts the user's initial from "Bună dimineața, Sofia!" → "S"
  String get _avatarLetter {
    final parts = greeting.split(', ');
    if (parts.length >= 2) {
      final name = parts.last.replaceAll('!', '').trim();
      if (name.isNotEmpty) return name[0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        greeting,
                        style: BabyMamaTypography.headlineLarge,
                      ),
                    ),
                    const SizedBox(width: BabyMamaSpacing.xs),
                    const Text(
                      '✦',
                      style: TextStyle(
                        color: BabyMamaColors.accent,
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: BabyMamaSpacing.xs2),
                Text(
                  subgreeting,
                  style: BabyMamaTypography.bodyMedium.copyWith(
                    color: BabyMamaColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: BabyMamaSpacing.lg),
          _UserAvatar(letter: _avatarLetter),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [BabyMamaColors.primaryLight, BabyMamaColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: BabyMamaShadows.sm,
      ),
      child: Center(
        child: Text(
          letter,
          style: BabyMamaTypography.titleLarge.copyWith(
            color: BabyMamaColors.onPrimary,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 2. NO BABY PROMPT
// ─────────────────────────────────────────────

/// Shown when currentBaby is null (new user hasn't added a baby yet).
class NoBabyPrompt extends StatelessWidget {
  const NoBabyPrompt({super.key, this.onAddBaby});

  final VoidCallback? onAddBaby;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(BabyMamaSpacing.xl2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFAF2EE), Color(0xFFF0DFDA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(
          color: BabyMamaColors.primary.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: BabyMamaShadows.sm,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: BabyMamaColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.child_care_rounded,
              size: 30,
              color: BabyMamaColors.primary,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.lg),
          Text(
            'Adaugă bebelușul tău',
            style: BabyMamaTypography.titleLarge.copyWith(
              color: BabyMamaColors.neutral900,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.sm),
          Text(
            'Înregistrează-l pe bebe pentru a urmări creșterea și activitățile zilnice.',
            textAlign: TextAlign.center,
            style: BabyMamaTypography.bodyMedium.copyWith(
              color: BabyMamaColors.neutral500,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.xl2),
          PrimaryButton(
            label: 'Adaugă bebe',
            onPressed: onAddBaby ?? () {},
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 3. BABY SUMMARY CARD
// ─────────────────────────────────────────────

class BabySummaryCard extends StatelessWidget {
  const BabySummaryCard({
    super.key,
    required this.baby,
    required this.babySummary,
    this.insight,
    this.onStartTracking,
  });

  final CurrentBaby baby;
  final BabySummary babySummary;
  final DevelopmentInsight? insight;
  final VoidCallback? onStartTracking;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl2),
      decoration: BoxDecoration(
        borderRadius: BabyMamaRadius.lgAll,
        boxShadow: const [
          BoxShadow(
            color: Color(0x18C4847A),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x08C4847A),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BabyMamaRadius.lgAll,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFAF2EE), Color(0xFFF0DFDA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BabyMamaRadius.lgAll,
            border: Border.all(
              color: BabyMamaColors.primary.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Decorative bloom — top right
              Positioned(
                top: -55,
                right: -55,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BabyMamaColors.primaryLight.withValues(alpha: 0.18),
                  ),
                ),
              ),
              // Decorative bloom — bottom left
              Positioned(
                bottom: -35,
                left: -25,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BabyMamaColors.accent.withValues(alpha: 0.12),
                  ),
                ),
              ),
              // Card content
              Padding(
                padding: const EdgeInsets.all(BabyMamaSpacing.xl2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Age pill + ornament
                    Row(
                      children: [
                        _AgePill(label: baby.ageLabel),
                        const Spacer(),
                        const Text(
                          '✦',
                          style: TextStyle(
                            color: BabyMamaColors.accent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BabyMamaSpacing.xl),
                    // Baby name
                    Text(
                      baby.firstName,
                      style:
                          BabyMamaTypography.displayMedium.copyWith(height: 1.0),
                    ),
                    const SizedBox(height: BabyMamaSpacing.sm),
                    // Time-of-day tagline
                    Text(
                      baby.dailyTagline,
                      style: BabyMamaTypography.bodyMedium.copyWith(
                        color: BabyMamaColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: BabyMamaSpacing.xl2),
                    // ── Today's activity status ──────────────────────────
                    Container(
                      height: 1,
                      color: BabyMamaColors.primary.withValues(alpha: 0.12),
                    ),
                    const SizedBox(height: BabyMamaSpacing.md),
                    if (babySummary.isEmpty)
                      _TrackingNudge(onTap: onStartTracking)
                    else
                      _LastActivitiesRow(summary: babySummary),
                    // ── Milestone row (from insight) ─────────────────────
                    if (insight != null) ...[
                      const SizedBox(height: BabyMamaSpacing.md),
                      Container(
                        height: 1,
                        color: BabyMamaColors.primary.withValues(alpha: 0.12),
                      ),
                      const SizedBox(height: BabyMamaSpacing.md),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Text('🌱',
                                style: TextStyle(fontSize: 13)),
                            const SizedBox(width: BabyMamaSpacing.sm),
                            Expanded(
                              child: Text(
                                'La ${insight!.ageRangeLabel} · ${insight!.title}',
                                style:
                                    BabyMamaTypography.labelSmall.copyWith(
                                  color: BabyMamaColors.primaryDark,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 13,
                              color: BabyMamaColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackingNudge extends StatelessWidget {
  const _TrackingNudge({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            size: 14,
            color: BabyMamaColors.primary.withValues(alpha: 0.70),
          ),
          const SizedBox(width: BabyMamaSpacing.xs),
          Text(
            'Nicio activitate înregistrată astăzi',
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.neutral500,
            ),
          ),
          const Spacer(),
          Text(
            'Urmărește',
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: BabyMamaSpacing.xs2),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 13,
            color: BabyMamaColors.primary,
          ),
        ],
      ),
    );
  }
}

class _LastActivitiesRow extends StatelessWidget {
  const _LastActivitiesRow({required this.summary});
  final BabySummary summary;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String)>[
      if (summary.lastFeed != null)
        (Icons.favorite_outline_rounded, 'Masă', summary.lastFeed!),
      if (summary.lastSleep != null)
        (Icons.bedtime_outlined, 'Somn', summary.lastSleep!),
      if (summary.lastDiaper != null)
        (Icons.change_circle_outlined, 'Scutec', summary.lastDiaper!),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: BabyMamaSpacing.sm,
      runSpacing: BabyMamaSpacing.xs,
      children: items
          .map((item) => _ActivityPill(icon: item.$1, label: item.$2, time: item.$3))
          .toList(),
    );
  }
}

class _ActivityPill extends StatelessWidget {
  const _ActivityPill({
    required this.icon,
    required this.label,
    required this.time,
  });

  final IconData icon;
  final String label;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BabyMamaSpacing.md,
        vertical: BabyMamaSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: BabyMamaColors.primary.withValues(alpha: 0.08),
        borderRadius: BabyMamaRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: BabyMamaColors.primaryDark),
          const SizedBox(width: BabyMamaSpacing.xs2),
          Text(
            '$label · $time',
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.primaryDark,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgePill extends StatelessWidget {
  const _AgePill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BabyMamaSpacing.md,
        vertical: BabyMamaSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: BabyMamaColors.primary.withValues(alpha: 0.10),
        borderRadius: BabyMamaRadius.fullAll,
      ),
      child: Text(
        label,
        style: BabyMamaTypography.labelSmall.copyWith(
          color: BabyMamaColors.primaryDark,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4. QUICK ACTIONS
// ─────────────────────────────────────────────

/// Identifies a quick-log action on the Home tab.
enum QuickAction {
  sleep(emoji: '🌙', label: 'Somn', bgColor: Color(0xFFD4E8D4)),
  breastfeed(emoji: '🤱', label: 'Alăptare', bgColor: Color(0xFFEDD8D5)),
  bottle(emoji: '🍼', label: 'Biberon', bgColor: Color(0xFFEEDCC6)),
  diaper(emoji: '🧷', label: 'Scutec', bgColor: Color(0xFFF0EAE7)),
  medicine(emoji: '💊', label: 'Medicament', bgColor: Color(0xFFDDD5E8));

  const QuickAction({
    required this.emoji,
    required this.label,
    required this.bgColor,
  });

  final String emoji;
  final String label;
  final Color bgColor;
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key, required this.onActionTap});

  final ValueChanged<QuickAction> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Adaugă rapid'),
          const SizedBox(height: BabyMamaSpacing.lg),
          Row(
            children: QuickAction.values.map((action) {
              return Expanded(
                child: _QuickActionItem(
                  action: action,
                  onTap: () => onActionTap(action),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({required this.action, required this.onTap});
  final QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: action.bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.neutral100,
                width: 1,
              ),
              boxShadow: BabyMamaShadows.xs,
            ),
            child: Center(
              child: Text(
                action.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.xs),
          Text(
            action.label,
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.neutral700,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 5. TODAY SUMMARY CARD
// ─────────────────────────────────────────────

class TodaySummaryCard extends StatelessWidget {
  const TodaySummaryCard({
    super.key,
    required this.summary,
    this.onStartTracking,
  });

  final TodaySummary summary;
  final VoidCallback? onStartTracking;

  String get _dateLabel {
    final now = DateTime.now();
    const months = [
      'ian', 'feb', 'mar', 'apr', 'mai', 'iun',
      'iul', 'aug', 'sep', 'oct', 'nov', 'dec',
    ];
    return '${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl2),
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(color: BabyMamaColors.neutral100, width: 1),
        boxShadow: BabyMamaShadows.sm,
      ),
      child: Column(
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              BabyMamaSpacing.xl2,
              BabyMamaSpacing.lg,
              BabyMamaSpacing.xl2,
              BabyMamaSpacing.lg,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  size: 14,
                  color: BabyMamaColors.accent,
                ),
                const SizedBox(width: BabyMamaSpacing.xs),
                Text(
                  'REZUMATUL ZILEI',
                  style: BabyMamaTypography.labelSmall.copyWith(
                    letterSpacing: 1.2,
                    color: BabyMamaColors.neutral300,
                  ),
                ),
                const Spacer(),
                Text(
                  _dateLabel,
                  style: BabyMamaTypography.labelSmall.copyWith(
                    color: BabyMamaColors.neutral300,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: BabyMamaColors.divider,
            height: 1,
            thickness: 1,
          ),
          // Content: empty state or stats
          if (summary.isEmpty)
            _TodayEmptyState(onStartTracking: onStartTracking)
          else
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.bedtime_outlined,
                      label: 'Somn',
                      value: summary.sleep.label,
                      iconColor: BabyMamaColors.secondary,
                      dot: summary.sleep.hasOngoingSession,
                    ),
                  ),
                  const VerticalDivider(
                    color: BabyMamaColors.divider,
                    width: 1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.restaurant_outlined,
                      label: 'Mese',
                      value: '${summary.feedCount}',
                      iconColor: BabyMamaColors.accent,
                    ),
                  ),
                  const VerticalDivider(
                    color: BabyMamaColors.divider,
                    width: 1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.baby_changing_station_rounded,
                      label: 'Scutece',
                      value: '${summary.diaperCount}',
                      iconColor: BabyMamaColors.primaryLight,
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

class _TodayEmptyState extends StatelessWidget {
  const _TodayEmptyState({this.onStartTracking});
  final VoidCallback? onStartTracking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BabyMamaSpacing.xl2),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BabyMamaColors.accent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              size: 22,
              color: BabyMamaColors.accent,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.md),
          Text(
            'Nicio activitate astăzi',
            style: BabyMamaTypography.titleSmall.copyWith(
              color: BabyMamaColors.neutral700,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.xs),
          Text(
            'Deschide tracker-ul pentru a începe urmărirea.',
            textAlign: TextAlign.center,
            style: BabyMamaTypography.bodyMedium.copyWith(
              color: BabyMamaColors.neutral500,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.lg),
          SecondaryButton(
            label: 'Deschide tracker',
            onPressed: onStartTracking ?? () {},
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.dot = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  /// Shows a live-session indicator dot on the icon.
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: BabyMamaSpacing.lg,
        horizontal: BabyMamaSpacing.md,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.14),
                  borderRadius: BabyMamaRadius.smAll,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              if (dot)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: BabyMamaColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: BabyMamaSpacing.sm),
          Text(
            value,
            style: BabyMamaTypography.titleLarge.copyWith(letterSpacing: 0),
          ),
          const SizedBox(height: BabyMamaSpacing.xs2),
          Text(label, style: BabyMamaTypography.labelSmall),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 6. DEVELOPMENT INSIGHT CARD
// ─────────────────────────────────────────────

class DevelopmentInsightCard extends StatelessWidget {
  const DevelopmentInsightCard({super.key, required this.insight});
  final DevelopmentInsight insight;

  /// Maps category key to emoji for the insight card header.
  static String _emojiForCategory(String cat) => switch (cat) {
        'motor'     => '🤸',
        'cognitive' => '🧠',
        'social'    => '👶',
        'language'  => '💬',
        'sensory'   => '👀',
        'nutrition' => '🥦',
        _           => '🌱',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BabyMamaColors.accent.withValues(alpha: 0.11),
            BabyMamaColors.accent.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(
          color: BabyMamaColors.accent.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(BabyMamaSpacing.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Text(
                _emojiForCategory(insight.category),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: BabyMamaSpacing.sm),
              Text(
                insight.category.toUpperCase(),
                style: BabyMamaTypography.labelSmall.copyWith(
                  color: BabyMamaColors.neutral500,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BabyMamaSpacing.sm,
                  vertical: BabyMamaSpacing.xs2,
                ),
                decoration: BoxDecoration(
                  color: BabyMamaColors.accent.withValues(alpha: 0.20),
                  borderRadius: BabyMamaRadius.fullAll,
                ),
                child: Text(
                  insight.ageRangeLabel,
                  style: BabyMamaTypography.labelSmall.copyWith(
                    color: BabyMamaColors.neutral700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: BabyMamaSpacing.md),

          // Title
          Text(
            insight.title,
            style: BabyMamaTypography.titleSmall.copyWith(
              color: BabyMamaColors.neutral900,
            ),
          ),

          const SizedBox(height: BabyMamaSpacing.sm),

          // Body text
          Text(
            '"${insight.body}"',
            style: BabyMamaTypography.bodyLarge.copyWith(
              fontStyle: FontStyle.italic,
              color: BabyMamaColors.neutral700,
              height: 1.65,
            ),
          ),

          const SizedBox(height: BabyMamaSpacing.md),

          // Read more
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Află mai mult',
                  style: BabyMamaTypography.labelMedium.copyWith(
                    color: BabyMamaColors.primary,
                  ),
                ),
                const SizedBox(width: BabyMamaSpacing.xs),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: BabyMamaColors.primary,
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
// 7. COMMUNITY PREVIEW
// ─────────────────────────────────────────────

class CommunityPreviewSection extends StatelessWidget {
  const CommunityPreviewSection({
    super.key,
    required this.preview,
    required this.onViewAll,
  });

  final CommunityPreview preview;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl2),
          child: const _SectionHeader(title: 'Din comunitate'),
        ),
        const SizedBox(height: BabyMamaSpacing.md),
        if (preview.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.xl2),
            child: _CommunityEmptyCard(onExplore: onViewAll),
          )
        else ...[
          for (final post in preview.posts) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: BabyMamaSpacing.xl2),
              child: _CommunityPostCard(post: post),
            ),
            const SizedBox(height: BabyMamaSpacing.md),
          ],
          const SizedBox(height: BabyMamaSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.xl2),
            child: SecondaryButton(
              label: 'Vezi comunitatea',
              onPressed: onViewAll,
            ),
          ),
        ],
      ],
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  const _CommunityPostCard({required this.post});
  final CommunityPostPreview post;

  static Color _tagColor(String tag) => switch (tag) {
        'somn'       => const Color(0xFF7A6FA8),
        'alaptare'   => BabyMamaColors.primary,
        'dezvoltare' => BabyMamaColors.secondary,
        'sanatate'   => const Color(0xFF5B8DB5),
        'nutritie'   => const Color(0xFFAA7340),
        _            => BabyMamaColors.neutral500,
      };

  @override
  Widget build(BuildContext context) {
    final tagColor = _tagColor(post.tag);

    return Container(
      padding: const EdgeInsets.all(BabyMamaSpacing.lg),
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(color: BabyMamaColors.neutral100, width: 1),
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BabyMamaSpacing.sm,
                  vertical: BabyMamaSpacing.xs2,
                ),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.12),
                  borderRadius: BabyMamaRadius.fullAll,
                ),
                child: Text(
                  '#${post.tag}',
                  style: BabyMamaTypography.labelSmall.copyWith(
                    color: tagColor,
                    fontSize: 11,
                  ),
                ),
              ),
              if (post.isPinned) ...[
                const SizedBox(width: BabyMamaSpacing.xs),
                Icon(
                  Icons.push_pin_rounded,
                  size: 13,
                  color: BabyMamaColors.accent,
                ),
              ],
            ],
          ),

          const SizedBox(height: BabyMamaSpacing.sm),

          // Title
          Text(
            post.title,
            style: BabyMamaTypography.titleSmall.copyWith(
              color: BabyMamaColors.neutral900,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: BabyMamaSpacing.xs),

          // Excerpt
          Text(
            post.excerpt,
            style: BabyMamaTypography.bodyMedium.copyWith(
              color: BabyMamaColors.neutral500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: BabyMamaSpacing.md),

          // Engagement row
          Row(
            children: [
              const Icon(
                Icons.favorite_border_rounded,
                size: 14,
                color: BabyMamaColors.neutral300,
              ),
              const SizedBox(width: BabyMamaSpacing.xs),
              Text(
                '${post.likeCount}',
                style: BabyMamaTypography.labelSmall,
              ),
              const SizedBox(width: BabyMamaSpacing.md),
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 14,
                color: BabyMamaColors.neutral300,
              ),
              const SizedBox(width: BabyMamaSpacing.xs),
              Text(
                '${post.commentCount} '
                '${post.commentCount == 1 ? 'comentariu' : 'comentarii'}',
                style: BabyMamaTypography.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommunityEmptyCard extends StatelessWidget {
  const _CommunityEmptyCard({this.onExplore});
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(BabyMamaSpacing.xl2),
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(color: BabyMamaColors.neutral100, width: 1),
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BabyMamaColors.primaryLight.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_outline_rounded,
              size: 24,
              color: BabyMamaColors.primary,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.md),
          Text(
            'Comunitatea te așteaptă',
            style: BabyMamaTypography.titleSmall.copyWith(
              color: BabyMamaColors.neutral700,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.xs),
          Text(
            'Fii prima care postează astăzi.',
            style: BabyMamaTypography.bodyMedium.copyWith(
              color: BabyMamaColors.neutral500,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.lg),
          SecondaryButton(
            label: 'Explorează comunitatea',
            onPressed: onExplore ?? () {},
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 8. TIPS SECTION
// ─────────────────────────────────────────────

class TipsSection extends StatelessWidget {
  const TipsSection({
    super.key,
    required this.preview,
    required this.onTipTap,
  });

  final TipsPreview preview;
  final ValueChanged<Tip> onTipTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: BabyMamaSpacing.xl2),
          child:
              const _SectionHeader(title: 'Recomandări pentru tine'),
        ),
        const SizedBox(height: BabyMamaSpacing.md),
        if (preview.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.xl2),
            child: const _TipsEmptyCard(),
          )
        else
          SizedBox(
            height: 176,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: BabyMamaSpacing.xl2),
              itemCount: preview.items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: BabyMamaSpacing.md),
              itemBuilder: (_, i) => _TipCard(
                tip: preview.items[i],
                onTap: () => onTipTap(preview.items[i]),
              ),
            ),
          ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, required this.onTap});
  final Tip tip;
  final VoidCallback onTap;

  static IconData _iconForKey(String key) => switch (key) {
        'moon'  => Icons.bedtime_outlined,
        'drop'  => Icons.water_drop_outlined,
        'baby'  => Icons.child_care_outlined,
        'heart' => Icons.favorite_outline_rounded,
        'leaf'  => Icons.eco_outlined,
        'sound' => Icons.volume_up_outlined,
        'hands' => Icons.back_hand_outlined,
        'sun'   => Icons.wb_sunny_outlined,
        _       => Icons.info_outline_rounded,
      };

  static Color _categoryColor(String cat) => switch (cat) {
        'somn'       => const Color(0xFF7A6FA8),
        'alaptare'   => BabyMamaColors.primary,
        'dezvoltare' => BabyMamaColors.secondary,
        'sanatate'   => const Color(0xFF5B8DB5),
        'nutritie'   => const Color(0xFFAA7340),
        _            => BabyMamaColors.neutral500,
      };

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(tip.category);
    final icon = _iconForKey(tip.icon);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: BabyMamaColors.surface,
          borderRadius: BabyMamaRadius.lgAll,
          border: Border.all(color: BabyMamaColors.neutral100, width: 1),
          boxShadow: BabyMamaShadows.sm,
        ),
        padding: const EdgeInsets.all(BabyMamaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BabyMamaRadius.smAll,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: BabyMamaSpacing.sm),
            // Title
            Expanded(
              child: Text(
                tip.title,
                style: BabyMamaTypography.titleSmall.copyWith(
                  color: BabyMamaColors.neutral900,
                  height: 1.45,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.xs),
            // Category chip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.sm,
                vertical: BabyMamaSpacing.xs2,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BabyMamaRadius.fullAll,
              ),
              child: Text(
                tip.category,
                style: BabyMamaTypography.labelSmall.copyWith(
                  color: color,
                  fontSize: 11,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipsEmptyCard extends StatelessWidget {
  const _TipsEmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(BabyMamaSpacing.xl2),
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(color: BabyMamaColors.neutral100, width: 1),
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: BabyMamaColors.accent.withValues(alpha: 0.14),
              borderRadius: BabyMamaRadius.smAll,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 22,
              color: BabyMamaColors.accent,
            ),
          ),
          const SizedBox(width: BabyMamaSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recomandări în curând',
                  style: BabyMamaTypography.titleSmall.copyWith(
                    color: BabyMamaColors.neutral700,
                  ),
                ),
                const SizedBox(height: BabyMamaSpacing.xs2),
                Text(
                  'Vom personaliza sfaturile pentru vârsta bebelușului tău.',
                  style: BabyMamaTypography.bodyMedium.copyWith(
                    color: BabyMamaColors.neutral500,
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
// 9. BOTTOM NAVIGATION
// ─────────────────────────────────────────────

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BabyMamaColors.surface,
        border: Border(
          top: BorderSide(color: BabyMamaColors.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C2D2420),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: BabyMamaSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Acasă',
                selected: selectedIndex == 0,
                onTap: () => onIndexChanged(0),
              ),
              _NavItem(
                icon: Icons.bar_chart_outlined,
                selectedIcon: Icons.bar_chart_rounded,
                label: 'Tracker',
                selected: selectedIndex == 1,
                onTap: () => onIndexChanged(1),
              ),
              _NavItem(
                icon: Icons.people_outline_rounded,
                selectedIcon: Icons.people_rounded,
                label: 'Comunitate',
                selected: selectedIndex == 2,
                onTap: () => onIndexChanged(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Profil',
                selected: selectedIndex == 3,
                onTap: () => onIndexChanged(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? BabyMamaColors.primary : BabyMamaColors.neutral500;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.md,
                vertical: BabyMamaSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? BabyMamaColors.primary.withValues(alpha: 0.10)
                    : Colors.transparent,
                borderRadius: BabyMamaRadius.fullAll,
              ),
              child: Icon(
                selected ? selectedIcon : icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.xs2),
            Text(
              label,
              style: BabyMamaTypography.labelSmall.copyWith(
                color: color,
                letterSpacing: 0.2,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRIVATE SHARED HELPERS
// ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: BabyMamaTypography.titleLarge);
  }
}
