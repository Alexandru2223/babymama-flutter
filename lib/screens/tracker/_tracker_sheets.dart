import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import 'tracker_mock_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AddEntryBottomSheet
//
// Universal sheet for logging any activity type.
// Caller opens via showModalBottomSheet with isScrollControlled: true.
//
// onSave receives the built TrackerEntry.
// Special case: sleep entry with endTime == null signals "start active session".
// TrackerScreen interprets this and sets _hasActiveSession = true instead of
// adding a completed entry to the timeline.
// ─────────────────────────────────────────────────────────────────────────────

class AddEntryBottomSheet extends StatefulWidget {
  const AddEntryBottomSheet({
    super.key,
    required this.type,
    required this.onSave,
  });

  final TrackerActivityType type;
  final void Function(TrackerEntry) onSave;

  @override
  State<AddEntryBottomSheet> createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
  // ── Shared ────────────────────────────────────────────────────────────────
  late TimeOfDay _time;

  // ── Sleep ─────────────────────────────────────────────────────────────────
  bool _sleepStartNow = true;
  late TimeOfDay _sleepStart;
  late TimeOfDay _sleepEnd;

  // ── Breastfeeding ─────────────────────────────────────────────────────────
  String _side = 'stânga';
  int _feedMinutes = 10;

  // ── Bottle ────────────────────────────────────────────────────────────────
  int _bottleMl = 120;

  // ── Diaper ────────────────────────────────────────────────────────────────
  String _diaperType = 'ud';

  // ── Pumping ───────────────────────────────────────────────────────────────
  int _pumpMl = 90;
  int _pumpMinutes = 15;

  // ── Solid ─────────────────────────────────────────────────────────────────
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.now();
    _sleepStart = _time;
    _sleepEnd = _time;
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  // ── Entry builder ─────────────────────────────────────────────────────────

  TrackerEntry _build() {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    final start = DateTime(
        now.year, now.month, now.day, _time.hour, _time.minute);

    return switch (widget.type) {
      TrackerActivityType.sleep => _buildSleep(now, id),
      TrackerActivityType.breastfeeding => TrackerEntry(
          id: id,
          type: widget.type,
          startTime: start,
          durationMinutes: _feedMinutes,
          breastSide: _side,
        ),
      TrackerActivityType.bottle => TrackerEntry(
          id: id,
          type: widget.type,
          startTime: start,
          volumeMl: _bottleMl.toDouble(),
        ),
      TrackerActivityType.diaper => TrackerEntry(
          id: id,
          type: widget.type,
          startTime: start,
          diaperType: _diaperType,
        ),
      TrackerActivityType.pumping => TrackerEntry(
          id: id,
          type: widget.type,
          startTime: start,
          volumeMl: _pumpMl.toDouble(),
          durationMinutes: _pumpMinutes,
        ),
      TrackerActivityType.solid => TrackerEntry(
          id: id,
          type: widget.type,
          startTime: start,
          notes: _notesCtrl.text.trim().isEmpty
              ? null
              : _notesCtrl.text.trim(),
        ),
    };
  }

  TrackerEntry _buildSleep(DateTime now, String id) {
    if (_sleepStartNow) {
      // endTime == null → TrackerScreen interprets as "start active session"
      return TrackerEntry(id: id, type: widget.type, startTime: now);
    }
    var s = DateTime(
        now.year, now.month, now.day, _sleepStart.hour, _sleepStart.minute);
    var e = DateTime(
        now.year, now.month, now.day, _sleepEnd.hour, _sleepEnd.minute);
    // Handle overnight sleep
    if (e.isBefore(s)) e = e.add(const Duration(days: 1));
    return TrackerEntry(id: id, type: widget.type, startTime: s, endTime: e);
  }

  // ── Time picker ───────────────────────────────────────────────────────────

  Future<void> _pickTime(
      TimeOfDay initial, void Function(TimeOfDay) onPicked) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && mounted) setState(() => onPicked(picked));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  bool get _isSleepStartNow =>
      widget.type == TrackerActivityType.sleep && _sleepStartNow;

  String get _saveLabel => _isSleepStartNow ? 'Pornește' : 'Adaugă';

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BabyMamaColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetHandle(),
              _SheetHeader(type: widget.type),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  BabyMamaSpacing.xl2,
                  BabyMamaSpacing.sm,
                  BabyMamaSpacing.xl2,
                  BabyMamaSpacing.lg,
                ),
                child: _buildForm(),
              ),
              _SheetFooter(
                saveLabel: _saveLabel,
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  widget.onSave(_build());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return switch (widget.type) {
      TrackerActivityType.sleep => _buildSleepForm(),
      TrackerActivityType.breastfeeding => _buildBreastfeedingForm(),
      TrackerActivityType.bottle => _buildBottleForm(),
      TrackerActivityType.diaper => _buildDiaperForm(),
      TrackerActivityType.pumping => _buildPumpingForm(),
      TrackerActivityType.solid => _buildSolidForm(),
    };
  }

  // ── Per-type forms ────────────────────────────────────────────────────────

  Widget _buildSleepForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SegmentedPicker(
          options: const ['Pornit acum', 'Adaugă trecut'],
          selectedIndex: _sleepStartNow ? 0 : 1,
          color: TrackerActivityType.sleep.color,
          onChanged: (i) => setState(() => _sleepStartNow = i == 0),
        ),
        const SizedBox(height: BabyMamaSpacing.md),
        if (_sleepStartNow)
          _formCard([
            _InfoRow(
              label: 'Pornit la',
              value: _fmt(TimeOfDay.now()),
            ),
          ])
        else
          _formCard([
            _TimePickerRow(
              label: 'Start',
              time: _sleepStart,
              color: TrackerActivityType.sleep.color,
              onTap: () => _pickTime(
                _sleepStart,
                (t) => _sleepStart = t,
              ),
            ),
            _TimePickerRow(
              label: 'Sfârșit',
              time: _sleepEnd,
              color: TrackerActivityType.sleep.color,
              onTap: () => _pickTime(
                _sleepEnd,
                (t) => _sleepEnd = t,
              ),
            ),
          ]),
      ],
    );
  }

  Widget _buildBreastfeedingForm() {
    final t = TrackerActivityType.breastfeeding;
    return _formCard([
      _TimePickerRow(
        label: 'Ora',
        time: _time,
        color: t.color,
        onTap: () => _pickTime(_time, (v) => _time = v),
      ),
      _OptionRow(
        label: 'Parte',
        options: const ['stânga', 'dreapta', 'ambele'],
        selected: _side,
        color: t.color,
        onSelected: (s) => setState(() => _side = s),
      ),
      _CounterRow(
        label: 'Durată',
        value: _feedMinutes,
        unit: 'min',
        min: 1,
        max: 120,
        color: t.color,
        bgColor: t.bgColor,
        onDecrement: () => setState(() => _feedMinutes = (_feedMinutes - 1).clamp(1, 120)),
        onIncrement: () => setState(() => _feedMinutes = (_feedMinutes + 1).clamp(1, 120)),
      ),
    ]);
  }

  Widget _buildBottleForm() {
    final t = TrackerActivityType.bottle;
    return _formCard([
      _TimePickerRow(
        label: 'Ora',
        time: _time,
        color: t.color,
        onTap: () => _pickTime(_time, (v) => _time = v),
      ),
      _CounterRow(
        label: 'Cantitate',
        value: _bottleMl,
        unit: 'ml',
        min: 10,
        max: 350,
        step: 10,
        color: t.color,
        bgColor: t.bgColor,
        onDecrement: () => setState(() => _bottleMl = (_bottleMl - 10).clamp(10, 350)),
        onIncrement: () => setState(() => _bottleMl = (_bottleMl + 10).clamp(10, 350)),
      ),
    ]);
  }

  Widget _buildDiaperForm() {
    final t = TrackerActivityType.diaper;
    return _formCard([
      _TimePickerRow(
        label: 'Ora',
        time: _time,
        color: t.color,
        onTap: () => _pickTime(_time, (v) => _time = v),
      ),
      _OptionRow(
        label: 'Tip',
        options: const ['ud', 'murdar', 'mixt'],
        selected: _diaperType,
        color: t.color,
        onSelected: (s) => setState(() => _diaperType = s),
      ),
    ]);
  }

  Widget _buildPumpingForm() {
    final t = TrackerActivityType.pumping;
    return _formCard([
      _TimePickerRow(
        label: 'Ora',
        time: _time,
        color: t.color,
        onTap: () => _pickTime(_time, (v) => _time = v),
      ),
      _CounterRow(
        label: 'Cantitate',
        value: _pumpMl,
        unit: 'ml',
        min: 10,
        max: 500,
        step: 10,
        color: t.color,
        bgColor: t.bgColor,
        onDecrement: () => setState(() => _pumpMl = (_pumpMl - 10).clamp(10, 500)),
        onIncrement: () => setState(() => _pumpMl = (_pumpMl + 10).clamp(10, 500)),
      ),
      _CounterRow(
        label: 'Durată',
        value: _pumpMinutes,
        unit: 'min',
        min: 1,
        max: 60,
        color: t.color,
        bgColor: t.bgColor,
        onDecrement: () => setState(() => _pumpMinutes = (_pumpMinutes - 1).clamp(1, 60)),
        onIncrement: () => setState(() => _pumpMinutes = (_pumpMinutes + 1).clamp(1, 60)),
      ),
    ]);
  }

  Widget _buildSolidForm() {
    final t = TrackerActivityType.solid;
    return _formCard([
      _TimePickerRow(
        label: 'Ora',
        time: _time,
        color: t.color,
        onTap: () => _pickTime(_time, (v) => _time = v),
      ),
      _TextInputRow(
        label: 'Aliment',
        hint: 'ex: piure de morcov',
        controller: _notesCtrl,
      ),
    ]);
  }

  // ── Form card container ───────────────────────────────────────────────────

  Widget _formCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.mdAll,
        boxShadow: BabyMamaShadows.xs,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: BabyMamaColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EntryActionsSheet
//
// Small action sheet shown when tapping ··· on a timeline entry.
// ─────────────────────────────────────────────────────────────────────────────

class EntryActionsSheet extends StatelessWidget {
  const EntryActionsSheet({
    super.key,
    required this.entry,
    this.onEdit,
    this.onDelete,
  });

  final TrackerEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final type = entry.type;

    return Container(
      decoration: const BoxDecoration(
        color: BabyMamaColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),

            // Entry summary header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                BabyMamaSpacing.xl2,
                BabyMamaSpacing.md,
                BabyMamaSpacing.xl2,
                BabyMamaSpacing.md,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type.label,
                        style: BabyMamaTypography.titleSmall,
                      ),
                      Text(
                        entry.detailLabel.isNotEmpty
                            ? '${entry.timeLabel} · ${entry.detailLabel}'
                            : entry.timeLabel,
                        style: BabyMamaTypography.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: BabyMamaColors.divider),

            _ActionRow(
              icon: Icons.edit_outlined,
              label: 'Editează',
              onTap: onEdit == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      onEdit!();
                    },
            ),

            const Divider(height: 1, color: BabyMamaColors.divider),

            _ActionRow(
              icon: Icons.delete_outline_rounded,
              label: 'Șterge intrarea',
              color: BabyMamaColors.error,
              onTap: onDelete == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      onDelete!();
                    },
            ),

            const SizedBox(height: BabyMamaSpacing.xl2),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sheet components
// ─────────────────────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: BabyMamaSpacing.md, bottom: BabyMamaSpacing.sm),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: BabyMamaColors.neutral300,
          borderRadius: BabyMamaRadius.fullAll,
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.type});
  final TrackerActivityType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.sm,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.md,
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
          Text(
            'Adaugă ${type.label.toLowerCase()}',
            style: BabyMamaTypography.titleLarge,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: BabyMamaColors.neutral100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: BabyMamaColors.neutral500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter({
    required this.saveLabel,
    required this.onCancel,
    required this.onSave,
  });
  final String saveLabel;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        0,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
      ),
      child: Row(
        children: [
          Expanded(
            child: SecondaryButton(label: 'Anulează', onPressed: onCancel),
          ),
          const SizedBox(width: BabyMamaSpacing.md),
          Expanded(
            child: PrimaryButton(label: saveLabel, onPressed: onSave),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = color ?? BabyMamaColors.neutral700;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BabyMamaSpacing.xl2,
          vertical: BabyMamaSpacing.lg,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: c),
            const SizedBox(width: BabyMamaSpacing.md),
            Text(
              label,
              style: BabyMamaTypography.bodyMedium.copyWith(color: c),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form row widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Shared padding + label + trailing widget layout.
class _FormRowShell extends StatelessWidget {
  const _FormRowShell({required this.label, required this.trailing});
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BabyMamaSpacing.lg,
        vertical: BabyMamaSpacing.md,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: BabyMamaTypography.bodyMedium.copyWith(
              color: BabyMamaColors.neutral700,
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

/// Tappable row that opens a time picker.
class _TimePickerRow extends StatelessWidget {
  const _TimePickerRow({
    required this.label,
    required this.time,
    required this.color,
    required this.onTap,
  });
  final String label;
  final TimeOfDay time;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return InkWell(
      onTap: onTap,
      child: _FormRowShell(
        label: label,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              display,
              style: BabyMamaTypography.titleSmall.copyWith(color: color),
            ),
            const SizedBox(width: BabyMamaSpacing.xs),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: BabyMamaColors.neutral300,
            ),
          ],
        ),
      ),
    );
  }
}

/// Non-tappable info row (e.g. "Pornit la 14:32").
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _FormRowShell(
      label: label,
      trailing: Text(
        value,
        style: BabyMamaTypography.titleSmall.copyWith(
          color: BabyMamaColors.neutral700,
        ),
      ),
    );
  }
}

/// +/- counter row for numeric fields (volume, duration).
class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    this.step = 1,
    required this.color,
    required this.bgColor,
    required this.onDecrement,
    required this.onIncrement,
  });
  final String label;
  final int value;
  final String unit;
  final int min;
  final int max;
  final int step;
  final Color color;
  final Color bgColor;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return _FormRowShell(
      label: label,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterBtn(
            icon: Icons.remove_rounded,
            color: color,
            bgColor: bgColor,
            enabled: value > min,
            onTap: onDecrement,
          ),
          const SizedBox(width: BabyMamaSpacing.sm),
          SizedBox(
            width: 62,
            child: Text(
              '$value $unit',
              textAlign: TextAlign.center,
              style: BabyMamaTypography.titleSmall.copyWith(
                color: BabyMamaColors.neutral900,
              ),
            ),
          ),
          const SizedBox(width: BabyMamaSpacing.sm),
          _CounterBtn(
            icon: Icons.add_rounded,
            color: color,
            bgColor: bgColor,
            enabled: value < max,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  const _CounterBtn({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.enabled,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? bgColor : BabyMamaColors.neutral100,
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? color : BabyMamaColors.neutral300,
        ),
      ),
    );
  }
}

/// Horizontal chip selector for enumerated options (side, diaper type).
class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.options,
    required this.selected,
    required this.color,
    required this.onSelected,
  });
  final String label;
  final List<String> options;
  final String selected;
  final Color color;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return _FormRowShell(
      label: label,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: BabyMamaSpacing.xs),
            _OptionChip(
              label: options[i],
              selected: options[i] == selected,
              color: color,
              onTap: () => onSelected(options[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: BabyMamaSpacing.md,
          vertical: BabyMamaSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          border: Border.all(
            color: selected ? color : BabyMamaColors.neutral300,
          ),
          borderRadius: BabyMamaRadius.fullAll,
        ),
        child: Text(
          label,
          style: BabyMamaTypography.labelSmall.copyWith(
            color: selected ? BabyMamaColors.onPrimary : BabyMamaColors.neutral700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Free-text input row (Solid food name).
class _TextInputRow extends StatelessWidget {
  const _TextInputRow({
    required this.label,
    required this.hint,
    required this.controller,
  });
  final String label;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BabyMamaSpacing.lg,
        vertical: BabyMamaSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: BabyMamaTypography.bodyMedium.copyWith(
              color: BabyMamaColors.neutral700,
            ),
          ),
          const SizedBox(width: BabyMamaSpacing.md),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.end,
              textCapitalization: TextCapitalization.sentences,
              style: BabyMamaTypography.titleSmall.copyWith(
                color: BabyMamaColors.neutral900,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: BabyMamaTypography.bodySmall.copyWith(
                  color: BabyMamaColors.neutral300,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented picker — used in sleep form to switch between modes.
class _SegmentedPicker extends StatelessWidget {
  const _SegmentedPicker({
    required this.options,
    required this.selectedIndex,
    required this.color,
    required this.onChanged,
  });
  final List<String> options;
  final int selectedIndex;
  final Color color;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: BabyMamaColors.neutral100,
        borderRadius: BabyMamaRadius.fullAll,
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: selected
                      ? color.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BabyMamaRadius.fullAll,
                ),
                child: Center(
                  child: Text(
                    options[i],
                    style: BabyMamaTypography.labelMedium.copyWith(
                      color: selected ? color : BabyMamaColors.neutral500,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
