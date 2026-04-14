import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../services/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();

    // Run the auth check concurrently with a minimum display delay so the
    // splash never flashes too briefly on fast devices.
    Future.wait([
      _resolveRoute(),
      Future<void>.delayed(const Duration(milliseconds: 900)),
    ]).then((_) {
      /* handled inside _resolveRoute */
    });
  }

  Future<void> _resolveRoute() async {
    try {
      final token = await storageService.getAccessToken();

      if (token == null) {
        _go('/');
        return;
      }

      // ApiClient will auto-refresh a stale access token.
      // If both tokens are dead it throws ApiException(401) and clears storage.
      final user = await authService.me();

      if (user.onboardingCompleted) {
        _go('/home');
      } else {
        _go('/onboarding/interese');
      }
    } on ApiException {
      // Refresh failed or other auth error — storage already cleared by ApiClient.
      _go('/');
    } catch (_) {
      // Network / unexpected error — send to welcome so the user can retry.
      _go('/');
    }
  }

  void _go(String route) {
    if (mounted) Navigator.pushReplacementNamed(context, route);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      body: Stack(
        children: [
          // ── Decorative background (mirrors WelcomeScreen) ──
          Positioned(
            top: -80,
            right: -60,
            child: _Blob(
              size: 280,
              color: BabyMamaColors.primaryLight.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            top: 60,
            right: 30,
            child: _Blob(
              size: 120,
              color: BabyMamaColors.accent.withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _Blob(
              size: 260,
              color: BabyMamaColors.secondary.withValues(alpha: 0.13),
            ),
          ),

          // ── Brand + loader ──
          FadeTransition(
            opacity: _fade,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Ornament
                  Text(
                    '✦',
                    style: TextStyle(
                      fontSize: 28,
                      color: BabyMamaColors.accent,
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: BabyMamaSpacing.lg),

                  // App name
                  Text(
                    'babymama',
                    style: BabyMamaTypography.displayLarge.copyWith(
                      fontSize: 52,
                      fontWeight: FontWeight.w300,
                      color: BabyMamaColors.neutral900,
                      height: 1.0,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: BabyMamaSpacing.md),

                  Text(
                    'pentru fiecare clipă',
                    style: BabyMamaTypography.bodySmall.copyWith(
                      color: BabyMamaColors.neutral300,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Minimal loading indicator
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: BabyMamaColors.primary.withValues(alpha: 0.5),
                    ),
                  ),

                  const SizedBox(height: BabyMamaSpacing.xl5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
