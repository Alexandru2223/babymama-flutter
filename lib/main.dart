import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/theme.dart';
import 'screens/auth/auth.dart';
import 'screens/onboarding/onboarding.dart';

void main() {
  runApp(const BabyMamaApp());
}

class BabyMamaApp extends StatelessWidget {
  const BabyMamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyMama',
      debugShowCheckedModeBanner: false,
      theme: BabyMamaTheme.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ro'),
        Locale('en'),
      ],
      initialRoute: '/',
      routes: {
        // Auth
        '/':       (_) => const WelcomeScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/login':  (_) => const LoginScreen(),

        // Onboarding
        '/onboarding/interese':   (_) => const OnboardingIntereseScreen(),
        '/onboarding/baby':       (_) => const OnboardingBabyScreen(),
        '/onboarding/tracking':   (_) => const OnboardingTrackingScreen(),
        '/onboarding/notificari': (_) => const OnboardingNotificariScreen(),
        '/onboarding/comunitati': (_) => const OnboardingComunitatiScreen(),
        '/onboarding/complete':   (_) => const OnboardingCompleteScreen(),
      },
    );
  }
}
