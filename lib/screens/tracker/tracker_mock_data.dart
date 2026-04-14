import 'package:flutter/material.dart';
import '../../theme/theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TRACKER MODELS & MOCK DATA
// ─────────────────────────────────────────────────────────────────────────────

// ── Activity type — carries its own visual config via enhanced enum ───────────

enum TrackerActivityType {
  sleep(
    label: 'Somn',
    icon: Icons.bedtime_outlined,
    color: Color(0xFF7A6FA8),
    bgColor: Color(0xFFF0EEF8),
  ),
  breastfeeding(
    label: 'Alăptare',
    icon: Icons.favorite_outline_rounded,
    color: BabyMamaColors.primary,
    bgColor: BabyMamaColors.surfaceVariant,
  ),
  bottle(
    label: 'Biberon',
    icon: Icons.local_cafe_outlined,
    color: Color(0xFF5B8DB5),
    bgColor: Color(0xFFECF3FA),
  ),
  diaper(
    label: 'Scutec',
    icon: Icons.change_circle_outlined,
    color: BabyMamaColors.accent,
    bgColor: BabyMamaColors.warningLight,
  ),
  pumping(
    label: 'Pompare',
    icon: Icons.water_drop_outlined,
    color: BabyMamaColors.secondary,
    bgColor: BabyMamaColors.successLight,
  ),
  solid(
    label: 'Solid',
    icon: Icons.restaurant_outlined,
    color: Color(0xFFAA7340),
    bgColor: Color(0xFFF5EDE0),
  );

  const TrackerActivityType({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
}

// ── TrackerEntry ──────────────────────────────────────────────────────────────

class TrackerEntry {
  const TrackerEntry({
    required this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    this.durationMinutes,
    this.volumeMl,
    this.notes,
    this.diaperType,
    this.breastSide,
  });

  final String id;
  final TrackerActivityType type;
  final DateTime startTime;
  final DateTime? endTime;

  // Type-specific fields — null when not applicable
  final int? durationMinutes;  // sleep, breastfeeding, pumping
  final double? volumeMl;      // bottle, pumping
  final String? notes;         // solid
  final String? diaperType;    // 'ud', 'murdar', 'mixt'
  final String? breastSide;    // 'stânga', 'dreapta', 'ambele'

  // ── Computed display strings ──────────────────────────────────────────────

  String get timeLabel {
    final h = _pad(startTime.hour);
    final m = _pad(startTime.minute);
    if (endTime != null) {
      return '$h:$m – ${_pad(endTime!.hour)}:${_pad(endTime!.minute)}';
    }
    return '$h:$m';
  }

  String get detailLabel {
    switch (type) {
      case TrackerActivityType.sleep:
        if (endTime != null) {
          final mins = endTime!.difference(startTime).inMinutes;
          return _formatDuration(mins);
        }
        return 'în desfășurare';

      case TrackerActivityType.breastfeeding:
        final parts = <String>[
          ?breastSide,
          if (durationMinutes != null) '$durationMinutes min',
        ];
        return parts.join(' · ');

      case TrackerActivityType.bottle:
        return volumeMl != null ? '${volumeMl!.toInt()} ml' : '';

      case TrackerActivityType.diaper:
        return diaperType ?? '';

      case TrackerActivityType.pumping:
        final parts = <String>[
          if (volumeMl != null) '${volumeMl!.toInt()} ml',
          if (durationMinutes != null) '$durationMinutes min',
        ];
        return parts.join(' · ');

      case TrackerActivityType.solid:
        return notes ?? '';
    }
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static String _formatDuration(int totalMinutes) {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h > 0 && m > 0) return '$h h $m min';
    if (h > 0) return '$h h';
    return '$m min';
  }
}

// ── ActiveSession ─────────────────────────────────────────────────────────────

class ActiveSession {
  const ActiveSession({required this.type, required this.startTime});
  final TrackerActivityType type;
  final DateTime startTime;
}

// ── DaySummary — computed from entries ───────────────────────────────────────

class DaySummary {
  DaySummary.fromEntries(List<TrackerEntry> entries) {
    for (final e in entries) {
      switch (e.type) {
        case TrackerActivityType.sleep:
          sleepSessions++;
          if (e.endTime != null) {
            sleepTotalMinutes += e.endTime!.difference(e.startTime).inMinutes;
          }
        case TrackerActivityType.breastfeeding:
          breastfeedingSessions++;
          breastfeedingTotalMinutes += e.durationMinutes ?? 0;
        case TrackerActivityType.bottle:
          bottleSessions++;
          bottleTotalMl += (e.volumeMl ?? 0).toInt();
        case TrackerActivityType.diaper:
          diaperChanges++;
        case TrackerActivityType.pumping:
          pumpingSessions++;
          pumpingTotalMl += (e.volumeMl ?? 0).toInt();
        case TrackerActivityType.solid:
          solidMeals++;
      }
    }
  }

  int sleepSessions = 0;
  int sleepTotalMinutes = 0;
  int breastfeedingSessions = 0;
  int breastfeedingTotalMinutes = 0;
  int bottleSessions = 0;
  int bottleTotalMl = 0;
  int diaperChanges = 0;
  int pumpingSessions = 0;
  int pumpingTotalMl = 0;
  int solidMeals = 0;

  String get sleepLabel => sleepTotalMinutes > 0
      ? TrackerEntry._formatDuration(sleepTotalMinutes)
      : '–';
}

// ── Mock data ─────────────────────────────────────────────────────────────────

const String mockBabyNameTracker = 'Maya';
const String mockBabyAgeTracker = '2 luni și 5 zile';

final DateTime mockTrackerDate = DateTime(2026, 4, 14);

/// Active session started ~1 h 23 min ago so the live timer shows a realistic value.
final ActiveSession mockActiveSession = ActiveSession(
  type: TrackerActivityType.sleep,
  startTime: DateTime.now().subtract(
    const Duration(hours: 1, minutes: 23, seconds: 17),
  ),
);

final List<TrackerEntry> mockTimelineEntries = [
  TrackerEntry(
    id: 'e1',
    type: TrackerActivityType.breastfeeding,
    startTime: DateTime(2026, 4, 14, 7, 40),
    durationMinutes: 12,
    breastSide: 'stânga',
  ),
  TrackerEntry(
    id: 'e2',
    type: TrackerActivityType.diaper,
    startTime: DateTime(2026, 4, 14, 9, 5),
    diaperType: 'ud',
  ),
  TrackerEntry(
    id: 'e3',
    type: TrackerActivityType.sleep,
    startTime: DateTime(2026, 4, 14, 9, 10),
    endTime: DateTime(2026, 4, 14, 10, 25),
  ),
  TrackerEntry(
    id: 'e4',
    type: TrackerActivityType.breastfeeding,
    startTime: DateTime(2026, 4, 14, 11, 0),
    durationMinutes: 15,
    breastSide: 'dreapta',
  ),
  TrackerEntry(
    id: 'e5',
    type: TrackerActivityType.bottle,
    startTime: DateTime(2026, 4, 14, 11, 30),
    volumeMl: 120,
  ),
  TrackerEntry(
    id: 'e6',
    type: TrackerActivityType.diaper,
    startTime: DateTime(2026, 4, 14, 12, 10),
    diaperType: 'ud',
  ),
  TrackerEntry(
    id: 'e7',
    type: TrackerActivityType.pumping,
    startTime: DateTime(2026, 4, 14, 14, 0),
    volumeMl: 90,
    durationMinutes: 15,
  ),
  TrackerEntry(
    id: 'e8',
    type: TrackerActivityType.solid,
    startTime: DateTime(2026, 4, 14, 17, 20),
    notes: 'piure de morcov',
  ),
];
