import 'package:flutter/material.dart';
import 'services/theme_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'common_widgets/main_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ThemeService so saved theme preference is available before app builds.
  await ThemeService.init();

  runApp(const EduFriendsEntrypoint());
}

class EduFriendsEntrypoint extends StatelessWidget {
  const EduFriendsEntrypoint({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to ThemeService.themeModeNotifier (same pattern you used in app.dart).
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'EduFriends Global',
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          themeMode: themeMode,
          // Minimal Material 3 themed defaults. If you have AppTheme.light()/dark(), swap these.
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.blue),
          // Routes: Splash decides next route (onboarding or main)
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/main': (context) => const MainScaffold(),
          },
        );
      },
    );
  }
}
