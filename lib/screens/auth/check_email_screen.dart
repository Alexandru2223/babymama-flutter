import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '_auth_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CheckEmailScreen
//
// Shown immediately after successful registration.
// The user is asked to verify their email before logging in.
//
// Route: '/check-email'
// Arguments: String email  (passed via Navigator.pushReplacementNamed)
//
// TODO: wire _onResend()  → authService.resendVerificationEmail(email: email)
// TODO: wire _onUnderstood() → decide flow: keep on this screen until verified,
//       or navigate to login and show a banner
// ─────────────────────────────────────────────────────────────────────────────

class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key, required this.email});

  /// The email address shown on-screen and used for the resend call.
  final String email;

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen>
    with SingleTickerProviderStateMixin {
  // ── Entrance animation ───────────────────────────────────────────────────
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

  void _onUnderstood() {
    // TODO: navigate to login (or keep here until deep-link callback arrives)
    Navigator.pushReplacementNamed(context, '/login');
  }

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

    // Auto-reset the success indicator after 4 seconds.
    await Future<void>.delayed(const Duration(seconds: 4));
    if (mounted) setState(() => _resentSuccess = false);
  }

  void _onChangeEmail() {
    // TODO: optionally clear server-side pending registration before leaving
    Navigator.pushReplacementNamed(context, '/signup');
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      body: Stack(
        children: [
          // ── Decorative background blobs ────────────────────────────────
          Positioned(
            top: -90,
            right: -70,
            child: _Blob(
              size: 300,
              color: BabyMamaColors.primaryLight.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            top: 80,
            right: 20,
            child: _Blob(
              size: 110,
              color: BabyMamaColors.accent.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -90,
            child: _Blob(
              size: 280,
              color: BabyMamaColors.secondary.withValues(alpha: 0.11),
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
                      AuthBackButton(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/signup',
                        ),
                      ),
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
                          child: const _EnvelopeIllustration(),
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
                                  'Verifică adresa\nde email',
                                  textAlign: TextAlign.center,
                                  style:
                                      BabyMamaTypography.displaySmall.copyWith(
                                    fontWeight: FontWeight.w300,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: BabyMamaSpacing.md),
                                Text(
                                  'Ți-am trimis un email de confirmare. Deschide inbox-ul\nși apasă link-ul pentru a-ți activa contul.',
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
                            child: _EmailAddressCard(email: widget.email),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // ── Hint ────────────────────────────────────────
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
                                'Verifică și folderul Spam dacă nu găsești emailul.',
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
                          PrimaryButton(
                            label: 'Am înțeles',
                            onPressed: _onUnderstood,
                          ),

                          const SizedBox(height: BabyMamaSpacing.md),

                          _ResendButton(
                            isLoading: _isResending,
                            isSuccess: _resentSuccess,
                            onPressed: _onResend,
                          ),

                          const SizedBox(height: BabyMamaSpacing.sm),

                          // Change email — text button
                          TextButton(
                            onPressed: _onChangeEmail,
                            style: TextButton.styleFrom(
                              foregroundColor: BabyMamaColors.neutral500,
                              padding: const EdgeInsets.symmetric(
                                horizontal: BabyMamaSpacing.lg,
                                vertical: BabyMamaSpacing.sm,
                              ),
                            ),
                            child: Text(
                              'Schimbă adresa de email',
                              style: BabyMamaTypography.labelMedium.copyWith(
                                color: BabyMamaColors.neutral500,
                                decoration: TextDecoration.underline,
                                decorationColor: BabyMamaColors.neutral300,
                              ),
                            ),
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
// _EnvelopeIllustration
// ─────────────────────────────────────────────────────────────────────────────

class _EnvelopeIllustration extends StatelessWidget {
  const _EnvelopeIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft ring
          Container(
            width: 136,
            height: 136,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BabyMamaColors.primaryLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),

          // Mid ring (dashed effect via small dots)
          ..._orbitDots(),

          // Main circle with gradient
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BabyMamaColors.primaryLight,
                  BabyMamaColors.primary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: BabyMamaColors.primary.withValues(alpha: 0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              size: 40,
              color: BabyMamaColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Three decorative dots placed at fixed positions around the main circle.
  ///
  /// Positions derived from 45°, 160°, and 280° at radius 62 from center (70,70):
  ///   45°  → cos≈0.7071, sin≈0.7071  → (106.8, 106.8)
  ///   160° → cos≈-0.9397, sin≈0.3420 → (11.7, 91.2)
  ///   280° → cos≈0.1736, sin≈-0.9848 → (77.8, 8.7)
  List<Widget> _orbitDots() {
    const dotSize = 6.0;
    const half = dotSize / 2;
    final dots = [
      (left: 106.8 - half, top: 106.8 - half, color: BabyMamaColors.accent),
      (left: 11.7 - half,  top: 91.2 - half,  color: BabyMamaColors.primaryLight),
      (left: 77.8 - half,  top: 8.7 - half,   color: BabyMamaColors.secondary),
    ];
    return dots.map((d) => Positioned(
      left: d.left,
      top: d.top,
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: d.color.withValues(alpha: 0.7),
        ),
      ),
    )).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EmailAddressCard
// ─────────────────────────────────────────────────────────────────────────────

class _EmailAddressCard extends StatelessWidget {
  const _EmailAddressCard({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BabyMamaSpacing.lg,
        vertical: BabyMamaSpacing.md,
      ),
      decoration: BoxDecoration(
        color: BabyMamaColors.surfaceVariant,
        borderRadius: BabyMamaRadius.mdAll,
        border: Border.all(
          color: BabyMamaColors.primaryLight.withValues(alpha: 0.45),
          width: 1,
        ),
        boxShadow: BabyMamaShadows.xs,
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: BabyMamaColors.primary.withValues(alpha: 0.1),
              borderRadius: BabyMamaRadius.smAll,
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              size: 18,
              color: BabyMamaColors.primary,
            ),
          ),

          const SizedBox(width: BabyMamaSpacing.md),

          // Email text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Email trimis la',
                  style: BabyMamaTypography.labelSmall.copyWith(
                    color: BabyMamaColors.neutral300,
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
// _ResendButton
//
// Three visual states:
//   idle    — outlined "Retrimite emailul"
//   loading — spinner (SecondaryButton handles this via isLoading)
//   success — green-tinted container with check icon + "Email retrimis!"
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
    if (isSuccess) {
      return _SuccessBanner();
    }

    return SecondaryButton(
      label: 'Retrimite emailul',
      isLoading: isLoading,
      onPressed: isLoading ? null : onPressed,
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  // ignore: unused_element
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
            color: BabyMamaColors.success.withValues(alpha: 0.3),
            width: 1,
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
// _Blob — reused decorative background circle
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
