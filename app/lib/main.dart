import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/feed/screens/feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hasSession = false;
  // Inicializa o Supabase com tratamento de fallback
  try {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    hasSession = Supabase.instance.client.auth.currentSession != null;
  } catch (e) {
    debugPrint('Aviso Supabase.initialize: $e');
  }

  runApp(PegaBodeApp(initialRoute: hasSession ? '/feed' : '/login'));
}

class PegaBodeApp extends StatelessWidget {
  final String initialRoute;
  const PegaBodeApp({super.key, this.initialRoute = '/login'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pega Bode',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/feed': (context) => const FeedScreen(),
      },
    );
  }
}
