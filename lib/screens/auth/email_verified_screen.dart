import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EmailVerifiedScreen
//
// Shown after the user successfully verifies their email address, typically
// triggered by a deep link (e.g. /auth/verify?token=...).
//
// Route     : '/email-verified'
// Arguments : String? email  (optional — available when the deep link carries
//             the address, but the screen works fine without it)
//
// Navigation decision (wire up once deep-link handling is implemented):
//   "Continuă"              → /onboarding/interese  (new user, first login)
//                           → /home                 (returning user already onboarded)
//   "Mergi la autentificare"→ /login                (always safe fallback)
//
// TODO: accept a nextRoute argument from the deep-link handler so this screen
//       can navigate correctly without knowing the account state itself.
// ─────────────────────────────────────────────────────────────────────────────

class EmailVerifiedScreen extends StatefulWidget {
  const EmailVerifiedScreen({super.key, this.email});

  /// The verified email address. Shown in the confirmation card when present.
  final String? email;

  @override
  State<EmailVerifiedScreen> createState() => _EmailVerifiedScreenState();
}

class _EmailVerifiedScreenState extends State<EmailVerifiedScreen>
    with SingleTickerProviderStateMixin {
  // ── Entrance animations ──────────────────────────────────────────────────
  late final AnimationController _ctrl;
  late final Animation<double> _iconScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _buttonsFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _iconScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );
    _titleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    ));
    _cardFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
    ));
    _buttonsFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _onContinue() {
    // TODO: navigate to /onboarding/interese (new user) or /home (returning).
    // Decide based on the deep-link context passed as route arguments.
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onGoToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      body: Stack(
        children: [
          // ── Decorative blobs — sage / success tint ─────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: _Blob(
              size: 280,
              color: BabyMamaColors.secondary.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: _Blob(
              size: 100,
              color: BabyMamaColors.success.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -70,
            left: -80,
            child: _Blob(
              size: 260,
              color: BabyMamaColors.accent.withValues(alpha: 0.12),
            ),
          ),

          // ── Screen content ─────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Brand watermark (no back button — this is a terminal state)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    BabyMamaSpacing.xl2,
                    BabyMamaSpacing.lg,
                    BabyMamaSpacing.xl2,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'babymama',
                      style: BabyMamaTypography.titleMedium.copyWith(
                        color: BabyMamaColors.neutral300,
                        fontFamily: 'Cormorant Garamond',
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BabyMamaSpacing.xl2,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: BabyMamaSpacing.xl4),

                        // ── Illustration ────────────────────────────────
                        ScaleTransition(
                          scale: _iconScale,
                          child: const _VerifiedIllustration(),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Title + subtitle ────────────────────────────
                        FadeTransition(
                          opacity: _titleFade,
                          child: SlideTransition(
                            position: _titleSlide,
                            child: Column(
                              children: [
                                Text(
                                  'Email confirmat',
                                  textAlign: TextAlign.center,
                                  style:
                                      BabyMamaTypography.displaySmall.copyWith(
                                    fontWeight: FontWeight.w300,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: BabyMamaSpacing.md),
                                Text(
                                  'Contul tău este acum activ. Te poți autentifica\nși continua în BabyMama.',
                                  textAlign: TextAlign.center,
                                  style: BabyMamaTypography.bodyMedium.copyWith(
                                    color: BabyMamaColors.neutral500,
                                    height: 1.65,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Confirmation card ───────────────────────────
                        FadeTransition(
                          opacity: _cardFade,
                          child: SlideTransition(
                            position: _cardSlide,
                            child: _ConfirmationCard(email: widget.email),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl5),
                      ],
                    ),
                  ),
                ),

                // ── Fixed bottom actions ─────────────────────────────────
                FadeTransition(
                  opacity: _buttonsFade,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        BabyMamaSpacing.xl2,
                        0,
                        BabyMamaSpacing.xl2,
                        BabyMamaSpacing.xl2,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton(
                            label: 'Continuă',
                            onPressed: _onContinue,
                          ),
                          const SizedBox(height: BabyMamaSpacing.md),
                          SecondaryButton(
                            label: 'Mergi la autentificare',
                            onPressed: _onGoToLogin,
                          ),
                        ],
                      ),
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// _VerifiedIllustration
//
// Two concentric outer rings + 96px sage green gradient circle + check icon.
// Orbit dots in sage/success palette. Distinct from the rose (CheckEmail) and
// amber (UnverifiedEmail) illustrations through colour alone — same geometry.
// ─────────────────────────────────────────────────────────────────────────────

class _VerifiedIllustration extends StatelessWidget {
  const _VerifiedIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      height: 148,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 144,
            height: 144,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.success.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
          ),

          // Middle ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.secondary.withValues(alpha: 0.22),
                width: 1,
              ),
            ),
          ),

          // Orbit dots
          // Pre-computed at radius 66 from center (74,74):
          //   60°  → cos=0.500, sin=0.866 → (107, 131.1)
          //   200° → cos=-0.940, sin=-0.342 → (11.9, 51.4)  (y-down: sin negative = upward)
          //   320° → cos=0.766, sin=-0.643 → (124.6, 31.6)
          const Positioned(
            left: 107.0 - 3,
            top: 131.1 - 3,
            child: _Dot(color: BabyMamaColors.secondary),
          ),
          const Positioned(
            left: 11.9 - 3,
            top: 51.4 - 3,
            child: _Dot(color: BabyMamaColors.success),
          ),
          const Positioned(
            left: 124.6 - 3,
            top: 31.6 - 3,
            child: _Dot(color: BabyMamaColors.accent),
          ),

          // Main sage circle
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BabyMamaColors.secondary,     // muted sage
                  BabyMamaColors.secondaryDark,  // deep sage
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: BabyMamaColors.secondary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 42,
              color: BabyMamaColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConfirmationCard
//
// White card with a subtle success-green border.
// Header: live green status dot + "Cont activat" + brand watermark.
// Body: three checklist items confirming what the account now has.
// Footer (optional): verified email address.
// ─────────────────────────────────────────────────────────────────────────────

class _ConfirmationCard extends StatelessWidget {
  const _ConfirmationCard({this.email});
  final String? email;

  static const _checkItems = [
    'Profil creat',
    'Email verificat',
    'Gata de utilizare',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BabyMamaColors.surface,
        borderRadius: BabyMamaRadius.mdAll,
        border: Border.all(
          color: BabyMamaColors.success.withValues(alpha: 0.22),
        ),
        boxShadow: BabyMamaShadows.sm,
      ),
      child: Column(
        children: [
          // ── Header row ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BabyMamaSpacing.lg,
              vertical: BabyMamaSpacing.md,
            ),
            child: Row(
              children: [
                // Glowing status dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BabyMamaColors.success,
                    boxShadow: [
                      BoxShadow(
                        color: BabyMamaColors.success.withValues(alpha: 0.45),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: BabyMamaSpacing.sm),
                Text(
                  'Cont activat',
                  style: BabyMamaTypography.titleSmall.copyWith(
                    color: BabyMamaColors.success,
                  ),
                ),
                const Spacer(),
                Text(
                  'babymama',
                  style: BabyMamaTypography.bodySmall.copyWith(
                    fontFamily: 'Cormorant Garamond',
                    color: BabyMamaColors.neutral300,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Divider(
            height: 1,
            thickness: 1,
            color: BabyMamaColors.divider,
          ),

          // ── Checklist ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(BabyMamaSpacing.lg),
            child: Column(
              children: List.generate(_checkItems.length, (i) {
                final isLast = i == _checkItems.length - 1;
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: isLast ? 0 : BabyMamaSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: BabyMamaColors.successLight,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: BabyMamaColors.success,
                        ),
                      ),
                      const SizedBox(width: BabyMamaSpacing.md),
                      Text(
                        _checkItems[i],
                        style: BabyMamaTypography.bodyMedium.copyWith(
                          color: BabyMamaColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // ── Footer: verified email (optional) ─────────────────────────
          if (email != null) ...[
            const Divider(
              height: 1,
              thickness: 1,
              color: BabyMamaColors.divider,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: BabyMamaSpacing.lg,
                vertical: BabyMamaSpacing.md,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.mail_outline_rounded,
                    size: 14,
                    color: BabyMamaColors.neutral300,
                  ),
                  const SizedBox(width: BabyMamaSpacing.sm),
                  Expanded(
                    child: Text(
                      email!,
                      overflow: TextOverflow.ellipsis,
                      style: BabyMamaTypography.bodySmall.copyWith(
                        color: BabyMamaColors.neutral500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BabyMamaSpacing.sm,
                      vertical: BabyMamaSpacing.xs2,
                    ),
                    decoration: BoxDecoration(
                      color: BabyMamaColors.successLight,
                      borderRadius: BabyMamaRadius.fullAll,
                    ),
                    child: Text(
                      'verificat',
                      style: BabyMamaTypography.labelSmall.copyWith(
                        color: BabyMamaColors.success,
                        fontSize: 10,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Local helpers
// ─────────────────────────────────────────────────────────────────────────────

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

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.6),
        ),
      );
}
