import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '_auth_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UnverifiedEmailScreen
//
// Shown when the user tries to log in but hasn't verified their email yet.
// Triggered from LoginScreen when the backend returns an "email not verified"
// error (see _isUnverifiedEmailError() in login_screen.dart).
//
// Route     : '/unverified-email'
// Arguments : String email  (the address the user just tried to log in with)
//
// TODO: wire _onResend() → authService.resendVerificationEmail(email: email)
// ─────────────────────────────────────────────────────────────────────────────

class UnverifiedEmailScreen extends StatefulWidget {
  const UnverifiedEmailScreen({super.key, required this.email});

  /// The email address the user attempted to log in with.
  final String email;

  @override
  State<UnverifiedEmailScreen> createState() => _UnverifiedEmailScreenState();
}

class _UnverifiedEmailScreenState extends State<UnverifiedEmailScreen>
    with SingleTickerProviderStateMixin {
  // ── Entrance animations ──────────────────────────────────────────────────
  late final AnimationController _ctrl;
  late final Animation<double> _iconScale;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _emailFade;
  late final Animation<Offset> _emailSlide;
  late final Animation<double> _buttonsFade;

  // ── Resend state ─────────────────────────────────────────────────────────
  bool _isResending = false;
  bool _resentSuccess = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _iconScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );
    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.2, 0.75, curve: Curves.easeOut),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.2, 0.75, curve: Curves.easeOut),
    ));
    _emailFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
    );
    _emailSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
    ));
    _buttonsFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _onResend() async {
    if (_isResending) return;
    setState(() {
      _isResending = true;
      _resentSuccess = false;
    });

    // TODO: await authService.resendVerificationEmail(email: widget.email);
    await Future<void>.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;
    setState(() {
      _isResending = false;
      _resentSuccess = true;
    });

    // Auto-reset the success banner after 4 s so the user can resend again.
    await Future<void>.delayed(const Duration(seconds: 4));
    if (mounted) setState(() => _resentSuccess = false);
  }

  void _onBackToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      body: Stack(
        children: [
          // ── Decorative blobs (amber-tinted to match the warning palette) ──
          Positioned(
            top: -80,
            right: -70,
            child: _Blob(
              size: 290,
              color: BabyMamaColors.accent.withValues(alpha: 0.15),
            ),
          ),
          Positioned(
            top: 70,
            right: 24,
            child: _Blob(
              size: 100,
              color: BabyMamaColors.warning.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -70,
            left: -80,
            child: _Blob(
              size: 270,
              color: BabyMamaColors.secondary.withValues(alpha: 0.10),
            ),
          ),

          // ── Screen content ─────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Back button + brand
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    BabyMamaSpacing.xl2,
                    BabyMamaSpacing.lg,
                    BabyMamaSpacing.xl2,
                    0,
                  ),
                  child: Row(
                    children: [
                      AuthBackButton(onTap: _onBackToLogin),
                      const Spacer(),
                      Text(
                        'babymama',
                        style: BabyMamaTypography.titleMedium.copyWith(
                          color: BabyMamaColors.neutral300,
                          fontFamily: 'Cormorant Garamond',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ],
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
                          child: const _UnverifiedIllustration(),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Title + subtitle ────────────────────────────
                        FadeTransition(
                          opacity: _contentFade,
                          child: SlideTransition(
                            position: _contentSlide,
                            child: Column(
                              children: [
                                Text(
                                  'Email\nneconfirmat',
                                  textAlign: TextAlign.center,
                                  style:
                                      BabyMamaTypography.displaySmall.copyWith(
                                    fontWeight: FontWeight.w300,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: BabyMamaSpacing.md),
                                Text(
                                  'Trebuie să îți confirmi adresa de email\nînainte să te poți autentifica.',
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

                        // ── Email address card ──────────────────────────
                        FadeTransition(
                          opacity: _emailFade,
                          child: SlideTransition(
                            position: _emailSlide,
                            child: _UnverifiedEmailCard(email: widget.email),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl2),

                        // ── Spam hint ───────────────────────────────────
                        FadeTransition(
                          opacity: _emailFade,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 13,
                                color: BabyMamaColors.neutral300,
                              ),
                              const SizedBox(width: BabyMamaSpacing.xs),
                              Text(
                                'Verifică și folderul Spam sau Promotions.',
                                style: BabyMamaTypography.bodySmall.copyWith(
                                  color: BabyMamaColors.neutral300,
                                  fontSize: 11,
                                ),
                              ),
                            ],
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
                          // Resend — primary action on this screen
                          _ResendButton(
                            isLoading: _isResending,
                            isSuccess: _resentSuccess,
                            onPressed: _onResend,
                          ),

                          const SizedBox(height: BabyMamaSpacing.md),

                          SecondaryButton(
                            label: 'Înapoi la login',
                            onPressed: _onBackToLogin,
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
// _UnverifiedIllustration
//
// Amber-tinted circle (accent → warning gradient) with a mail icon and a
// small warning badge at the top-right — visually distinct from the blush
// circle in CheckEmailScreen.
// ─────────────────────────────────────────────────────────────────────────────

class _UnverifiedIllustration extends StatelessWidget {
  const _UnverifiedIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft amber ring
          Container(
            width: 136,
            height: 136,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.warning.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
          ),

          // Orbit dots (amber palette)
          // Pre-computed positions at 30°, 155°, 265° at radius 62 from (70,70):
          //   30°  → cos≈0.866, sin≈0.500  → (123.7, 101.0)
          //   155° → cos≈-0.906, sin≈0.423 → (13.8, 96.2)
          //   265° → cos≈-0.087, sin≈-0.996 → (64.6, 8.2)
          Positioned(
            left: 123.7 - 3,
            top: 101.0 - 3,
            child: _Dot(color: BabyMamaColors.accent.withValues(alpha: 0.65)),
          ),
          Positioned(
            left: 13.8 - 3,
            top: 96.2 - 3,
            child: _Dot(color: BabyMamaColors.warning.withValues(alpha: 0.55)),
          ),
          Positioned(
            left: 64.6 - 3,
            top: 8.2 - 3,
            child: _Dot(color: BabyMamaColors.secondary.withValues(alpha: 0.55)),
          ),

          // Main amber circle
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BabyMamaColors.accent,      // warm champagne
                  BabyMamaColors.warning,     // amber
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: BabyMamaColors.warning.withValues(alpha: 0.30),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              size: 38,
              color: BabyMamaColors.onPrimary,
            ),
          ),

          // Warning badge — top-right of the main circle
          // Circle center at (70,70), radius 48 → top-right at ~(104, 36)
          Positioned(
            left: 91,
            top: 23,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BabyMamaColors.warning,
                border: Border.all(
                  color: BabyMamaColors.background,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: BabyMamaColors.warning.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.priority_high_rounded,
                size: 13,
                color: BabyMamaColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _UnverifiedEmailCard
//
// Amber-tinted variant of the email card — same structure as in
// CheckEmailScreen but uses warningLight background and warning border to
// reinforce the "action needed" state.
// ─────────────────────────────────────────────────────────────────────────────

class _UnverifiedEmailCard extends StatelessWidget {
  const _UnverifiedEmailCard({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BabyMamaSpacing.lg,
        vertical: BabyMamaSpacing.md,
      ),
      decoration: BoxDecoration(
        color: BabyMamaColors.warningLight,
        borderRadius: BabyMamaRadius.mdAll,
        border: Border.all(
          color: BabyMamaColors.warning.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Row(
        children: [
          // Amber icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: BabyMamaColors.warning.withValues(alpha: 0.14),
              borderRadius: BabyMamaRadius.smAll,
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              size: 18,
              color: BabyMamaColors.warning,
            ),
          ),

          const SizedBox(width: BabyMamaSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Adresă neverificată',
                  style: BabyMamaTypography.labelSmall.copyWith(
                    color: BabyMamaColors.warning,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: BabyMamaTypography.titleSmall.copyWith(
                    color: BabyMamaColors.neutral900,
                    fontWeight: FontWeight.w600,
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
// _ResendButton — idle / loading / success states
// ─────────────────────────────────────────────────────────────────────────────

class _ResendButton extends StatelessWidget {
  const _ResendButton({
    required this.isLoading,
    required this.isSuccess,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isSuccess;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isSuccess) return const _SuccessBanner();

    return PrimaryButton(
      label: 'Retrimite emailul',
      isLoading: isLoading,
      onPressed: isLoading ? null : onPressed,
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BabyMamaSpacing.lg,
          vertical: BabyMamaSpacing.md,
        ),
        decoration: BoxDecoration(
          color: BabyMamaColors.successLight,
          borderRadius: BabyMamaRadius.fullAll,
          border: Border.all(
            color: BabyMamaColors.success.withValues(alpha: 0.30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 18,
              color: BabyMamaColors.success,
            ),
            const SizedBox(width: BabyMamaSpacing.sm),
            Text(
              'Email retrimis cu succes!',
              style: BabyMamaTypography.labelMedium.copyWith(
                color: BabyMamaColors.success,
              ),
            ),
          ],
        ),
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
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
