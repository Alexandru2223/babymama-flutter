import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import '_onboarding_widgets.dart';

// ── Step 2 / 5 — Profil bebeluș ───────────────

class OnboardingBabyScreen extends StatefulWidget {
  const OnboardingBabyScreen({super.key});

  @override
  State<OnboardingBabyScreen> createState() => _OnboardingBabyScreenState();
}

class _OnboardingBabyScreenState extends State<OnboardingBabyScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtr    = TextEditingController();
  final _weightCtr  = TextEditingController();

  String   _liveName = '';
  DateTime? _birthDate;
  String?  _gender;        // 'boy' | 'girl' | null
  bool     _prematur = false;
  bool     _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtr.addListener(
      () => setState(() => _liveName = _nameCtr.text.trim()),
    );
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _weightCtr.dispose();
    super.dispose();
  }

  // ── Date picker ────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      locale: const Locale('ro'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: BabyMamaColors.primary,
            onPrimary: BabyMamaColors.onPrimary,
            surface: BabyMamaColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  // ── Submit ─────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selectează data nașterii')),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      // Convert kg string to grams integer (e.g. "3.2" → 3200)
      int? weightGrams;
      final weightText = _weightCtr.text.trim().replaceAll(',', '.');
      if (weightText.isNotEmpty) {
        final kg = double.tryParse(weightText);
        if (kg != null) weightGrams = (kg * 1000).round();
      }

      // Map local gender values to API enum
      final String? apiGender = switch (_gender) {
        'boy' => 'MALE',
        'girl' => 'FEMALE',
        _ => null,
      };

      await onboardingService.createBaby(
        firstName: _nameCtr.text.trim(),
        birthDate: _birthDate!,
        birthWeightGrams: weightGrams,
        gender: apiGender,
        isPremature: _prematur,
      );

      if (mounted) Navigator.pushNamed(context, '/onboarding/tracking');
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
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: BabyMamaColors.background,
        body: SafeArea(
          child: Column(
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
                  currentStep: 2,
                  totalSteps: 5,
                  title: 'Profil\nbebeluș',
                  onBack: () => Navigator.pop(context),
                ),
              ),

              // ── Scrollable body ──
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      BabyMamaSpacing.xl2,
                      BabyMamaSpacing.xl2,
                      BabyMamaSpacing.xl2,
                      BabyMamaSpacing.xl6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Avatar + live name ──
                        _BabyAvatar(name: _liveName),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Decorative divider ──
                        _OrnamantDivider(),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Prenume ──
                        TextInputField(
                          label: 'Prenumele copilului',
                          hint: 'ex: Sofia, Luca…',
                          controller: _nameCtr,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Prenumele este obligatoriu'
                              : null,
                        ),

                        const SizedBox(height: BabyMamaSpacing.lg),

                        // ── Data nașterii ──
                        _DateField(
                          date: _birthDate,
                          onTap: _pickDate,
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Sex ──
                        _FieldLabel(label: 'Sex', optional: true),
                        const SizedBox(height: BabyMamaSpacing.sm),
                        _GenderSelector(
                          selected: _gender,
                          onChanged: (v) => setState(() => _gender = v),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Greutate ──
                        TextInputField(
                          label: 'Greutate la naștere',
                          hint: 'ex: 3.2  (opțional)',
                          controller: _weightCtr,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*[.,]?\d{0,2}'),
                            ),
                          ],
                          suffix: Text(
                            'kg',
                            style: BabyMamaTypography.bodyMedium.copyWith(
                              color: BabyMamaColors.neutral500,
                            ),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Prematur ──
                        _PrematurCard(
                          value: _prematur,
                          onChanged: (v) => setState(() => _prematur = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Bottom CTA ──
              OnboardingBottomAction(
                label: 'Salvează și continuă',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SUBWIDGETS
// ─────────────────────────────────────────────

// ── Baby avatar with live name preview ────────

class _BabyAvatar extends StatelessWidget {
  const _BabyAvatar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final hasName = name.isNotEmpty;

    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer decorative ring
              Container(
                width: 116,
                height: 116,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: BabyMamaColors.primaryLight.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
              ),

              // Secondary ring
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: BabyMamaColors.primaryLight.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
              ),

              // Avatar circle
              Container(
                width: 86,
                height: 86,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      BabyMamaColors.primaryLight,
                      BabyMamaColors.accent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: hasName
                        ? Text(
                            name[0].toUpperCase(),
                            key: const ValueKey('letter'),
                            style: BabyMamaTypography.displaySmall.copyWith(
                              color: BabyMamaColors.onPrimary,
                              height: 1,
                            ),
                          )
                        : const Icon(
                            Icons.child_care_rounded,
                            key: ValueKey('icon'),
                            color: BabyMamaColors.onPrimary,
                            size: 34,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: BabyMamaSpacing.lg),

        // Live name preview
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: BabyMamaTypography.headlineMedium.copyWith(
            color: hasName
                ? BabyMamaColors.neutral900
                : BabyMamaColors.neutral300,
          ),
          child: Text(
            hasName ? name : 'Bebelușul tău',
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: BabyMamaSpacing.xs),

        Text(
          'Primul profil. Primul pas.',
          style: BabyMamaTypography.bodySmall.copyWith(
            color: BabyMamaColors.neutral300,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Decorative ornament divider ───────────────

class _OrnamantDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: BabyMamaColors.divider, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.md),
          child: Text(
            '✦',
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.neutral300,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: BabyMamaColors.divider, thickness: 1),
        ),
      ],
    );
  }
}

// ── Section label with optional tag ──────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.optional = false});
  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: BabyMamaTypography.titleSmall),
        if (optional) ...[
          const SizedBox(width: BabyMamaSpacing.sm),
          Text(
            'opțional',
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.neutral300,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Date field ────────────────────────────────

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});
  final DateTime? date;
  final VoidCallback onTap;

  static const _months = [
    'ianuarie', 'februarie', 'martie', 'aprilie', 'mai', 'iunie',
    'iulie', 'august', 'septembrie', 'octombrie', 'noiembrie', 'decembrie',
  ];

  String _format(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: BabyMamaSpacing.inputHorizontal,
          vertical: BabyMamaSpacing.inputVertical + 4,
        ),
        decoration: BoxDecoration(
          color: BabyMamaColors.neutral50,
          borderRadius: BabyMamaRadius.input,
          border: Border.all(
            color: hasDate ? BabyMamaColors.primary : BabyMamaColors.neutral300,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: hasDate
                  ? BabyMamaColors.primary
                  : BabyMamaColors.neutral500,
            ),
            const SizedBox(width: BabyMamaSpacing.sm),
            Expanded(
              child: Text(
                hasDate ? _format(date!) : 'Data nașterii',
                style: BabyMamaTypography.bodyLarge.copyWith(
                  color: hasDate
                      ? BabyMamaColors.neutral900
                      : BabyMamaColors.neutral300,
                ),
              ),
            ),
            if (hasDate)
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: BabyMamaColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Gender selector ───────────────────────────

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.selected,
    required this.onChanged,
  });
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderPill(
            label: 'Băiat',
            emoji: '💙',
            value: 'boy',
            isSelected: selected == 'boy',
            onTap: () => onChanged(selected == 'boy' ? null : 'boy'),
          ),
        ),
        const SizedBox(width: BabyMamaSpacing.md),
        Expanded(
          child: _GenderPill(
            label: 'Fată',
            emoji: '🩷',
            value: 'girl',
            isSelected: selected == 'girl',
            onTap: () => onChanged(selected == 'girl' ? null : 'girl'),
          ),
        ),
      ],
    );
  }
}

class _GenderPill extends StatelessWidget {
  const _GenderPill({
    required this.label,
    required this.emoji,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final String value;
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
            padding: const EdgeInsets.symmetric(
              vertical: BabyMamaSpacing.md + 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: BabyMamaSpacing.xs),
                Text(
                  label,
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

// ── Prematur toggle card ──────────────────────

class _PrematurCard extends StatelessWidget {
  const _PrematurCard({
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: value ? BabyMamaColors.surfaceVariant : BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.card,
        border: Border.all(
          color: value ? BabyMamaColors.primary : BabyMamaColors.neutral100,
          width: value ? 1.5 : 1,
        ),
        boxShadow: value ? BabyMamaShadows.sm : BabyMamaShadows.xs,
      ),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BabyMamaRadius.card,
        splashColor: BabyMamaColors.primaryLight.withValues(alpha: 0.15),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            BabyMamaSpacing.lg,
            BabyMamaSpacing.md,
            BabyMamaSpacing.sm, // less padding right — Switch has its own margin
            BabyMamaSpacing.md,
          ),
          child: Row(
            children: [
              // Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: value
                      ? BabyMamaColors.primaryLight.withValues(alpha: 0.35)
                      : BabyMamaColors.neutral100,
                  borderRadius: BabyMamaRadius.smAll,
                ),
                child: Icon(
                  Icons.child_friendly_rounded,
                  size: 22,
                  color: value
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
                      'Prematur',
                      style: BabyMamaTypography.titleMedium.copyWith(
                        color: value
                            ? BabyMamaColors.primaryDark
                            : BabyMamaColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: BabyMamaSpacing.xs2),
                    Text(
                      'Născut înainte de 37 de săptămâni',
                      style: BabyMamaTypography.bodySmall,
                    ),
                  ],
                ),
              ),

              // Switch
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
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
