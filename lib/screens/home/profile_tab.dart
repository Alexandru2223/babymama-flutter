import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../services/services.dart';

// ── Mock profile data ─────────────────────────
// Replace these constants with a real UserModel / auth state later.
const _kName        = 'Ana Maria';
const _kEmail       = 'ana.maria@example.com';
const _kMemberSince = 'Aprilie 2026';
const _kBabyName    = 'Maya';
const _kBabyAge     = '2 luni și 5 zile';

// ─────────────────────────────────────────────
// PROFILE TAB
// ─────────────────────────────────────────────

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isLoggingOut = false;

  Future<void> _onLogoutTap() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _LogoutDialog(),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);
    try {
      await authService.logout();
    } catch (_) {
      // If the server call fails the tokens are still cleared locally,
      // so we proceed to the welcome screen regardless.
    } finally {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          _ProfileHeader(),

          // ── Baby ──
          _SectionLabel('Bebelușul meu'),
          _BabyCard(),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Account ──
          _SectionLabel('Cont'),
          _SettingsGroup(
            rows: [
              _SettingsRow(
                icon: Icons.notifications_none_rounded,
                iconColor: BabyMamaColors.primary,
                iconBg: Color(0xFFEDD8D5),
                label: 'Notificări',
              ),
              _SettingsRow(
                icon: Icons.tune_rounded,
                iconColor: BabyMamaColors.secondary,
                iconBg: Color(0xFFD4E8D4),
                label: 'Preferințe',
              ),
              _SettingsRow(
                icon: Icons.language_rounded,
                iconColor: BabyMamaColors.accent,
                iconBg: Color(0xFFEEDCC6),
                label: 'Limbă',
                value: 'Română',
              ),
              _SettingsRow(
                icon: Icons.workspace_premium_outlined,
                iconColor: Color(0xFF8B75AB),
                iconBg: Color(0xFFDDD5E8),
                label: 'Abonament',
                value: 'Gratuit',
              ),
            ],
          ),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Community ──
          _SectionLabel('Comunitate'),
          _SettingsGroup(
            rows: [
              _SettingsRow(
                icon: Icons.person_outline_rounded,
                iconColor: BabyMamaColors.primaryDark,
                iconBg: Color(0xFFEDD8D5),
                label: 'Profil public',
              ),
              _SettingsRow(
                icon: Icons.people_outline_rounded,
                iconColor: BabyMamaColors.secondaryDark,
                iconBg: Color(0xFFD4E8D4),
                label: 'Comunități înscrise',
              ),
            ],
          ),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Support ──
          _SectionLabel('Suport'),
          _SettingsGroup(
            rows: [
              _SettingsRow(
                icon: Icons.help_outline_rounded,
                iconColor: BabyMamaColors.neutral700,
                iconBg: BabyMamaColors.neutral100,
                label: 'Ajutor & FAQ',
              ),
              _SettingsRow(
                icon: Icons.mail_outline_rounded,
                iconColor: BabyMamaColors.neutral700,
                iconBg: BabyMamaColors.neutral100,
                label: 'Contactează-ne',
              ),
              _SettingsRow(
                icon: Icons.shield_outlined,
                iconColor: BabyMamaColors.neutral700,
                iconBg: BabyMamaColors.neutral100,
                label: 'Confidențialitate',
              ),
            ],
          ),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Logout ──
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.xl2),
            child: _isLoggingOut
                ? const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: BabyMamaSpacing.lg),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: BabyMamaColors.error,
                        ),
                      ),
                    ),
                  )
                : _LogoutRow(onTap: _onLogoutTap),
          ),

          const SizedBox(height: BabyMamaSpacing.xl2),

          // ── Version ──
          Center(
            child: Text(
              'babymama · versiunea 1.0.0',
              style: BabyMamaTypography.labelSmall.copyWith(
                color: BabyMamaColors.neutral300,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: BabyMamaSpacing.xl5),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE HEADER
// ─────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl3,
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [BabyMamaColors.primaryLight, BabyMamaColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x20C4847A),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _kName[0].toUpperCase(),
                style: BabyMamaTypography.displaySmall.copyWith(
                  color: BabyMamaColors.onPrimary,
                  height: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: BabyMamaSpacing.lg),

          // Name
          Text(
            _kName,
            style: BabyMamaTypography.headlineMedium,
          ),

          const SizedBox(height: BabyMamaSpacing.xs),

          // Email
          Text(
            _kEmail,
            style: BabyMamaTypography.bodySmall.copyWith(
              color: BabyMamaColors.neutral300,
            ),
          ),

          const SizedBox(height: BabyMamaSpacing.xs2),

          // Member since
          Text(
            'Membră din $_kMemberSince',
            style: BabyMamaTypography.labelSmall.copyWith(
              color: BabyMamaColors.neutral300,
            ),
          ),

          const SizedBox(height: BabyMamaSpacing.lg),

          // Edit button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: BabyMamaColors.primary,
              side: const BorderSide(
                  color: BabyMamaColors.primary, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BabyMamaRadius.fullAll),
              padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.xl2,
                vertical: BabyMamaSpacing.sm,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: BabyMamaTypography.labelMedium,
            ),
            child: const Text('Editează profil'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BABY CARD
// ─────────────────────────────────────────────

class _BabyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl2),
      padding: const EdgeInsets.all(BabyMamaSpacing.lg),
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(color: BabyMamaColors.neutral100, width: 1),
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Row(
        children: [
          // Baby avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [BabyMamaColors.primaryLight, BabyMamaColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                _kBabyName[0].toUpperCase(),
                style: BabyMamaTypography.titleLarge.copyWith(
                  color: BabyMamaColors.onPrimary,
                  height: 1,
                ),
              ),
            ),
          ),

          const SizedBox(width: BabyMamaSpacing.md),

          // Baby info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_kBabyName, style: BabyMamaTypography.titleMedium),
                const SizedBox(height: BabyMamaSpacing.xs2),
                Text(
                  _kBabyAge,
                  style: BabyMamaTypography.bodySmall,
                ),
              ],
            ),
          ),

          // Edit icon
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: BabyMamaColors.neutral50,
                borderRadius: BabyMamaRadius.smAll,
              ),
              child: const Icon(
                Icons.edit_outlined,
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

// ─────────────────────────────────────────────
// SETTINGS GROUP
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.xl3,
        BabyMamaSpacing.xl2,
        BabyMamaSpacing.sm,
      ),
      child: Text(
        text.toUpperCase(),
        style: BabyMamaTypography.labelSmall.copyWith(
          letterSpacing: 1.2,
          color: BabyMamaColors.neutral300,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.rows});
  final List<_SettingsRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl2),
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(color: BabyMamaColors.neutral100, width: 1),
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: BabyMamaSpacing.lg),
                child: Divider(
                  color: BabyMamaColors.divider,
                  height: 1,
                  thickness: 1,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BabyMamaRadius.lgAll,
      splashColor: BabyMamaColors.primaryLight.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BabyMamaSpacing.lg,
          vertical: BabyMamaSpacing.md,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BabyMamaRadius.smAll,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),

            const SizedBox(width: BabyMamaSpacing.md),

            // Label
            Expanded(
              child: Text(label, style: BabyMamaTypography.bodyMedium),
            ),

            // Optional value
            if (value != null) ...[
              Text(
                value!,
                style: BabyMamaTypography.labelMedium.copyWith(
                  color: BabyMamaColors.neutral300,
                ),
              ),
              const SizedBox(width: BabyMamaSpacing.xs),
            ],

            // Arrow
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: BabyMamaColors.neutral300,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOGOUT ROW
// ─────────────────────────────────────────────

class _LogoutRow extends StatelessWidget {
  const _LogoutRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BabyMamaColors.errorLight,
        borderRadius: BabyMamaRadius.lgAll,
        border: Border.all(
          color: BabyMamaColors.error.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BabyMamaRadius.lgAll,
        splashColor: BabyMamaColors.error.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BabyMamaSpacing.lg,
            vertical: BabyMamaSpacing.md + 2,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: BabyMamaColors.error.withValues(alpha: 0.12),
                  borderRadius: BabyMamaRadius.smAll,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 18,
                  color: BabyMamaColors.error,
                ),
              ),
              const SizedBox(width: BabyMamaSpacing.md),
              Expanded(
                child: Text(
                  'Deconectare',
                  style: BabyMamaTypography.bodyMedium.copyWith(
                    color: BabyMamaColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: BabyMamaColors.error.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOGOUT CONFIRMATION DIALOG
// ─────────────────────────────────────────────

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deconectare'),
      content: const Text(
        'Ești sigură că vrei să ieși din cont?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Anulează'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: BabyMamaColors.error,
          ),
          child: const Text('Deconectează-te'),
        ),
      ],
    );
  }
}
