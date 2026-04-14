import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'tracker_mock_data.dart';
import '_tracker_sheets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. TRACKER HEADER
// ─────────────────────────────────────────────────────────────────────────────

class TrackerHeader extends StatelessWidget {
  const TrackerHeader({
    super.key,
    required this.babyName,
    required this.babyAge,
    required this.selectedDate,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onCalendarTap,
    required this.onBabySwitcher,
    required this.canGoForward,
  });

  final String babyName;
  final String babyAge;
  final DateTime selectedDate;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onCalendarTap;
  final VoidCallback onBabySwitcher;
  final bool canGoForward;

  String get _dateLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sel = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (sel == today) return 'Astăzi';
    if (sel == today.subtract(const Duration(days: 1))) return 'Ieri';

    const months = [
      'ian', 'feb', 'mar', 'apr', 'mai', 'iun',
      'iul', 'aug', 'sep', 'oct', 'nov', 'dec',
    ];
    return '${selectedDate.day} ${months[selectedDate.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.md,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: BabyMamaColors.background,
        border: Border(
          bottom: BorderSide(color: BabyMamaColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // ── Baby switcher ──────────────────────────────────────────────
          GestureDetector(
            onTap: onBabySwitcher,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        BabyMamaColors.primaryLight,
                        BabyMamaColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      babyName[0],
                      style: BabyMamaTypography.titleSmall.copyWith(
                        color: BabyMamaColors.onPrimary,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: BabyMamaSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          babyName,
                          style: BabyMamaTypography.titleMedium,
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: BabyMamaColors.neutral500,
                        ),
                      ],
                    ),
                    Text(babyAge, style: BabyMamaTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Day navigation ─────────────────────────────────────────────
          Row(
            children: [
              _DayNavArrow(
                icon: Icons.chevron_left_rounded,
                onTap: onPreviousDay,
                enabled: true,
              ),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onCalendarTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BabyMamaSpacing.md,
                    vertical: BabyMamaSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: BabyMamaColors.neutral100,
                    borderRadius: BabyMamaRadius.fullAll,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: BabyMamaColors.neutral500,
                      ),
                      const SizedBox(width: BabyMamaSpacing.xs),
                      Text(
                        _dateLabel,
                        style: BabyMamaTypography.labelSmall.copyWith(
                          color: BabyMamaColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 2),
              _DayNavArrow(
                icon: Icons.chevron_right_rounded,
                onTap: onNextDay,
                enabled: canGoForward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayNavArrow extends StatelessWidget {
  const _DayNavArrow({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(
          icon,
          size: 22,
          color: enabled
              ? BabyMamaColors.neutral700
              : BabyMamaColors.neutral300,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. QUICK ADD SECTION
// ─────────────────────────────────────────────────────────────────────────────

class QuickAddSection extends StatelessWidget {
  const QuickAddSection({super.key, required this.onActionTap});

  final void Function(TrackerActivityType) onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adaugă rapid',
            style: BabyMamaTypography.titleMedium.copyWith(
              color: BabyMamaColors.neutral700,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: BabyMamaSpacing.sm,
            crossAxisSpacing: BabyMamaSpacing.sm,
            childAspectRatio: 1.2,
            children: TrackerActivityType.values
                .map(
                  (type) => QuickActionCard(
                    type: type,
                    onTap: () => onActionTap(type),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.type,
    required this.onTap,
  });

  final TrackerActivityType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: type.bgColor,
      borderRadius: BabyMamaRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        // TODO: onTap → open bottom sheet for this activity type
        borderRadius: BabyMamaRadius.mdAll,
        splashColor: type.color.withValues(alpha: 0.10),
        highlightColor: type.color.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: BabyMamaSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon, color: type.color, size: 26),
              const SizedBox(height: BabyMamaSpacing.xs),
              Text(
                type.label,
                style: BabyMamaTypography.labelSmall.copyWith(
                  color: type.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. ACTIVE SESSION CARD — live running timer
// ─────────────────────────────────────────────────────────────────────────────

class ActiveSessionCard extends StatefulWidget {
  const ActiveSessionCard({
    super.key,
    required this.session,
    required this.onStop,
  });

  final ActiveSession session;
  final VoidCallback onStop;

  @override
  State<ActiveSessionCard> createState() => _ActiveSessionCardState();
}

class _ActiveSessionCardState extends State<ActiveSessionCard> {
  late Timer _ticker;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.session.startTime);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(widget.session.startTime);
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  String get _timerLabel {
    final h = _elapsed.inHours;
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    if (h > 0) return '${h}h ${m}m ${s}s';
    return '${_elapsed.inMinutes % 60}m ${s}s';
  }

  String get _startLabel {
    final t = widget.session.startTime;
    return 'început la ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.session.type;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
        BabyMamaSpacing.xl2,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(BabyMamaSpacing.lg),
        decoration: BoxDecoration(
          color: type.bgColor,
          borderRadius: BabyMamaRadius.mdAll,
          border: Border.all(
            color: type.color.withValues(alpha: 0.22),
          ),
          boxShadow: BabyMamaShadows.xs,
        ),
        child: Row(
          children: [
            // Pulsing icon
            _PulsingIcon(color: type.color, bgColor: type.bgColor, icon: type.icon),

            const SizedBox(width: BabyMamaSpacing.md),

            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${type.label} în desfășurare',
                    style: BabyMamaTypography.titleSmall.copyWith(
                      color: type.color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        _timerLabel,
                        style: BabyMamaTypography.labelMedium.copyWith(
                          color: type.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: BabyMamaSpacing.sm),
                      Text(
                        '· $_startLabel',
                        style: BabyMamaTypography.bodySmall.copyWith(
                          color: type.color.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stop button
            GestureDetector(
              onTap: widget.onStop,
              // TODO: onStop → save active session to backend with actual duration
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BabyMamaSpacing.md,
                  vertical: BabyMamaSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: type.color,
                  borderRadius: BabyMamaRadius.fullAll,
                ),
                child: Text(
                  'Oprește',
                  style: BabyMamaTypography.labelSmall.copyWith(
                    color: BabyMamaColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated icon with a fading outer ring to suggest an ongoing process.
class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon({
    required this.color,
    required this.bgColor,
    required this.icon,
  });
  final Color color;
  final Color bgColor;
  final IconData icon;

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _scale = Tween<double>(begin: 1.0, end: 1.55).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.35, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing ring
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) => Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: _opacity.value),
                ),
              ),
            ),
          ),
          // Icon circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.18),
            ),
            child: Icon(widget.icon, size: 18, color: widget.color),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. VIEW SWITCHER  (Cronologie / Rezumat)
// ─────────────────────────────────────────────────────────────────────────────

class TrackerViewSwitcher extends StatelessWidget {
  const TrackerViewSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final void Function(int) onChanged;

  static const _labels = ['Cronologie', 'Rezumat'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
        0,
      ),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: BabyMamaColors.neutral100,
          borderRadius: BabyMamaRadius.fullAll,
        ),
        child: Row(
          children: List.generate(_labels.length, (i) {
            final selected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: selected
                        ? BabyMamaColors.surface
                        : Colors.transparent,
                    borderRadius: BabyMamaRadius.fullAll,
                    boxShadow:
                        selected ? BabyMamaShadows.xs : BabyMamaShadows.none,
                  ),
                  child: Center(
                    child: Text(
                      _labels[i],
                      style: BabyMamaTypography.labelMedium.copyWith(
                        color: selected
                            ? BabyMamaColors.neutral900
                            : BabyMamaColors.neutral500,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. TIMELINE SECTION
// ─────────────────────────────────────────────────────────────────────────────

class TimelineSection extends StatelessWidget {
  const TimelineSection({
    super.key,
    required this.entries,
    this.onEdit,
    this.onDelete,
  });

  final List<TrackerEntry> entries;

  /// Called with the full entry when the user taps "Editează".
  final void Function(TrackerEntry)? onEdit;

  /// Called with the entry id when the user confirms "Șterge".
  final void Function(String id)? onDelete;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(BabyMamaSpacing.xl4),
        child: Center(
          child: Text(
            'Nicio activitate înregistrată.',
            style: BabyMamaTypography.bodyMedium.copyWith(
              color: BabyMamaColors.neutral300,
            ),
          ),
        ),
      );
    }

    // Most recent first
    final sorted = [...entries]
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${sorted.length} ${sorted.length == 1 ? 'activitate' : 'activități'}',
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.neutral300,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.md),

          for (int i = 0; i < sorted.length; i++) ...[
            TimelineEntryCard(
              entry: sorted[i],
              onEdit: onEdit == null ? null : () => onEdit!(sorted[i]),
              onDelete: onDelete == null ? null : () => onDelete!(sorted[i].id),
            ),
            if (i < sorted.length - 1) const SizedBox(height: BabyMamaSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class TimelineEntryCard extends StatelessWidget {
  const TimelineEntryCard({
    super.key,
    required this.entry,
    this.onEdit,
    this.onDelete,
  });

  final TrackerEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => EntryActionsSheet(
        entry: entry,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = entry.type;

    return Material(
      color: BabyMamaColors.surface,
      borderRadius: BabyMamaRadius.mdAll,
      child: InkWell(
        onTap: () => _showActions(context),
        borderRadius: BabyMamaRadius.mdAll,
        splashColor: type.color.withValues(alpha: 0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: BabyMamaSpacing.lg,
            vertical: BabyMamaSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BabyMamaRadius.mdAll,
            boxShadow: BabyMamaShadows.xs,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: type.bgColor,
                  borderRadius: BabyMamaRadius.smAll,
                ),
                child: Icon(type.icon, size: 20, color: type.color),
              ),

              const SizedBox(width: BabyMamaSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          type.label,
                          style: BabyMamaTypography.titleSmall.copyWith(
                            color: BabyMamaColors.neutral900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          entry.timeLabel,
                          style: BabyMamaTypography.bodySmall.copyWith(
                            color: BabyMamaColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                    if (entry.detailLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        entry.detailLabel,
                        style: BabyMamaTypography.bodySmall.copyWith(
                          color: BabyMamaColors.neutral500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: BabyMamaSpacing.sm),

              GestureDetector(
                onTap: () => _showActions(context),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(BabyMamaSpacing.xs),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: BabyMamaColors.neutral300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. SUMMARY TAB — computed day statistics
// ─────────────────────────────────────────────────────────────────────────────

class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key, required this.entries});

  final List<TrackerEntry> entries;

  @override
  Widget build(BuildContext context) {
    final s = DaySummary.fromEntries(entries);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.lg,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rezumat zi',
            style: BabyMamaTypography.titleMedium.copyWith(
              color: BabyMamaColors.neutral700,
            ),
          ),
          const SizedBox(height: BabyMamaSpacing.md),

          // 2-column summary grid
          _SummaryRow(children: [
            _SummaryCard(
              type: TrackerActivityType.sleep,
              value: s.sleepLabel,
              subLabel: '${s.sleepSessions} sesiuni',
            ),
            _SummaryCard(
              type: TrackerActivityType.breastfeeding,
              value: '${s.breastfeedingSessions}×',
              subLabel: s.breastfeedingTotalMinutes > 0
                  ? '${s.breastfeedingTotalMinutes} min total'
                  : '–',
            ),
          ]),
          const SizedBox(height: BabyMamaSpacing.sm),
          _SummaryRow(children: [
            _SummaryCard(
              type: TrackerActivityType.bottle,
              value: s.bottleTotalMl > 0 ? '${s.bottleTotalMl} ml' : '–',
              subLabel: '${s.bottleSessions} biberon',
            ),
            _SummaryCard(
              type: TrackerActivityType.diaper,
              value: '${s.diaperChanges}×',
              subLabel: 'schimbări',
            ),
          ]),
          const SizedBox(height: BabyMamaSpacing.sm),
          _SummaryRow(children: [
            _SummaryCard(
              type: TrackerActivityType.pumping,
              value: s.pumpingTotalMl > 0 ? '${s.pumpingTotalMl} ml' : '–',
              subLabel: '${s.pumpingSessions} sesiuni',
            ),
            _SummaryCard(
              type: TrackerActivityType.solid,
              value: '${s.solidMeals}×',
              subLabel: 'mese solide',
            ),
          ]),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children
          .expand(
            (w) => [
              Expanded(child: w),
              const SizedBox(width: BabyMamaSpacing.sm),
            ],
          )
          .take(children.length * 2 - 1)
          .toList(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.type,
    required this.value,
    required this.subLabel,
  });

  final TrackerActivityType type;
  final String value;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BabyMamaSpacing.md),
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.mdAll,
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: type.bgColor,
            ),
            child: Icon(type.icon, size: 18, color: type.color),
          ),
          const SizedBox(width: BabyMamaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: BabyMamaTypography.titleMedium.copyWith(
                    color: BabyMamaColors.neutral900,
                  ),
                ),
                Text(
                  subLabel,
                  style: BabyMamaTypography.labelSmall.copyWith(
                    color: BabyMamaColors.neutral500,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
