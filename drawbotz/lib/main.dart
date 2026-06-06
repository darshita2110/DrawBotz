import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/ar_screen.dart';
import 'screens/my_zoo_screen.dart';

void main() {
  runApp(const DrawBotzApp());
}

class DrawBotzApp extends StatelessWidget {
  const DrawBotzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrawBotz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const OnboardingScreen(),
      routes: {
        '/camera': (context) => const CameraScreen(),
        '/ar': (context) => const ARScreen(),
        '/zoo': (context) => const MyZooScreen(),
      },
    );
  }
}
