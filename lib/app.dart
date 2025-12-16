import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'common_widgets/main_scaffold.dart';
import 'services/theme_service.dart';
import 'screens/splash_screen.dart';

class EduFriendsApp extends StatelessWidget {
  const EduFriendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'EduFriends Global',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,

          // Start at splash screen; SplashScreen will decide whether to go to onboarding or main.
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),

            // Provide a temporary onboarding placeholder here so the app compiles.
            // Replace this route later with your real onboarding screen import.
            '/onboarding': (context) => const _OnboardingPlaceholder(),

            // Main route uses your MainScaffold from common_widgets/main_scaffold.dart
            '/main': (context) => const MainScaffold(),
          },
        );
      },
    );
  }
}

/// Temporary placeholder onboarding screen used only to prevent missing-file errors.
/// Replace this with your real 'lib/screens/onboarding_screen.dart' implementation.
class _OnboardingPlaceholder extends StatelessWidget {
  const _OnboardingPlaceholder({super.key});

  Future<void> _completeAndGo(BuildContext context) async {
    // Mark onboarding complete and go to main; using SharedPreferences is optional.
    // If you prefer not to import shared_preferences here, we simply navigate.
    // When you add the real onboarding screen, it should set the SharedPreferences flag.
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome — Onboarding (placeholder)')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'This is a temporary onboarding placeholder.\n\n'
              'Replace _OnboardingPlaceholder with your real onboarding screen when ready.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Skip directly to main for quick testing
                    Navigator.of(context).pushReplacementNamed('/main');
                  },
                  child: const Text('Skip'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _completeAndGo(context),
                  child: const Text('Get Started'),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
