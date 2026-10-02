import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pa2/features/auth/screens/login_screen.dart';
import 'package:pa2/features/dashboard/screens/main_screen.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> with TickerProviderStateMixin {
  late AnimationController _smokeController;
  bool _showSmoke = false;

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // Mostra o logo estático por 2s (mais tempo na tela branca)
    await Future.delayed(const Duration(milliseconds: 2000));

    // A fumaça preenchendo a tela (mais rápida)
    setState(() {
      _showSmoke = true;
    });
    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _smokeController.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // Carrega o App imediatamente sem a transição padrão do Android
    _checkSessionAndNavigate();
  }

  void _checkSessionAndNavigate() {
    final hasSession = Supabase.instance.client.auth.currentSession != null;
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return hasSession ? const MainScreen() : const LoginScreen();
        },
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_showSmoke) _smokeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fundo com a logo central
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.jpg', width: 120),
                const SizedBox(height: 16),
                const Text(
                  'AchaNaRua',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Fumaça (Smoke Explosion)
          if (_showSmoke)
            AnimatedBuilder(
              animation: _smokeController,
              builder: (context, child) {
                final scale = _smokeController.value * 50; // Cresce 50x o tamanho original
                return Positioned.fill(
                  child: Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

