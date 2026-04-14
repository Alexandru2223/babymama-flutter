import 'package:flutter/material.dart';
import 'tracker_mock_data.dart';
import '_tracker_widgets.dart';
import '_tracker_sheets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TrackerScreen
//
// Lives in HomeScreen's IndexedStack at tab index 1.
// Owns all local tracker state for the current session:
//
//   _entries          — mutable list of logged entries for today
//   _selectedDate     — which day is being viewed
//   _viewIndex        — 0 = Cronologie, 1 = Rezumat
//   _hasActiveSession — whether the sleep session timer is running
//   _activeSession    — the actual session (start time, type)
//
// TODO: replace with a TrackerViewModel / Riverpod provider that syncs
//       with the backend repository.
// ─────────────────────────────────────────────────────────────────────────────

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  // ── State ─────────────────────────────────────────────────────────────────

  DateTime _selectedDate = mockTrackerDate;
  int _viewIndex = 0;
  bool _hasActiveSession = true;
  ActiveSession _activeSession = mockActiveSession;

  /// Mutable entry list — seeded with mock data on first build.
  /// TODO: load from repository keyed by date.
  late final List<TrackerEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = List.of(mockTimelineEntries);
  }

  // ── Date helpers ──────────────────────────────────────────────────────────

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  void _previousDay() =>
      setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)));

  void _nextDay() {
    if (!_isToday) {
      setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)));
    }
  }

  /// Returns entries for the selected date.
  /// TODO: replace with repository.entriesFor(_selectedDate).
  List<TrackerEntry> get _entriesForDate {
    final sel = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final mock = DateTime(mockTrackerDate.year, mockTrackerDate.month, mockTrackerDate.day);
    return sel == mock ? _entries : [];
  }

  // ── Entry mutations ───────────────────────────────────────────────────────

  void _addEntry(TrackerEntry entry) {
    // Sleep with no endTime = "start now" signal
    if (entry.type == TrackerActivityType.sleep && entry.endTime == null) {
      setState(() {
        _hasActiveSession = true;
        _activeSession = ActiveSession(
          type: TrackerActivityType.sleep,
          startTime: entry.startTime,
        );
      });
      return;
    }
    setState(() => _entries.add(entry));
  }

  void _removeEntry(String id) =>
      setState(() => _entries.removeWhere((e) => e.id == id));

  void _replaceEntry(String id, TrackerEntry updated) {
    setState(() {
      final idx = _entries.indexWhere((e) => e.id == id);
      if (idx != -1) _entries[idx] = updated;
    });
  }

  // ── Active session stop ───────────────────────────────────────────────────

  void _stopActiveSession() {
    final now = DateTime.now();
    final completed = TrackerEntry(
      id: now.millisecondsSinceEpoch.toString(),
      type: _activeSession.type,
      startTime: _activeSession.startTime,
      endTime: now,
    );
    setState(() {
      _hasActiveSession = false;
      // Add the completed session to the today list if we're viewing today
      if (_isToday) _entries.add(completed);
    });
  }

  // ── Sheet helpers ─────────────────────────────────────────────────────────

  void _openAddSheet(TrackerActivityType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEntryBottomSheet(
        type: type,
        onSave: _addEntry,
      ),
    );
  }

  void _openEditSheet(TrackerEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEntryBottomSheet(
        type: entry.type,
        onSave: (updated) => _replaceEntry(entry.id, updated),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Fixed header ─────────────────────────────────────────────────
        TrackerHeader(
          babyName: mockBabyNameTracker,
          babyAge: mockBabyAgeTracker,
          selectedDate: _selectedDate,
          canGoForward: !_isToday,
          onPreviousDay: _previousDay,
          onNextDay: _nextDay,
          onCalendarTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2024),
              lastDate: DateTime.now(),
            );
            if (picked != null && mounted) {
              setState(() => _selectedDate = picked);
            }
          },
          onBabySwitcher: () {
            // TODO: show baby switcher bottom sheet (multi-baby support)
          },
        ),

        // ── Scrollable content ───────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Quick add ──────────────────────────────────────────
                QuickAddSection(onActionTap: _openAddSheet),

                // ── Active session ─────────────────────────────────────
                if (_hasActiveSession)
                  ActiveSessionCard(
                    session: _activeSession,
                    onStop: _stopActiveSession,
                  ),

                // ── View switcher ──────────────────────────────────────
                TrackerViewSwitcher(
                  selectedIndex: _viewIndex,
                  onChanged: (i) => setState(() => _viewIndex = i),
                ),

                // ── Content ────────────────────────────────────────────
                if (_viewIndex == 0)
                  TimelineSection(
                    entries: _entriesForDate,
                    onEdit: _openEditSheet,
                    onDelete: _removeEntry,
                  )
                else
                  SummaryTab(entries: _entriesForDate),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
