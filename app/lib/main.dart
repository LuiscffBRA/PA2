import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/feed/screens/feed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PegaBodeApp());
}

class PegaBodeApp extends StatelessWidget {
  const PegaBodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pega Bode',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/register',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/feed': (context) => const FeedScreen(),
      },
    );
  }
}
