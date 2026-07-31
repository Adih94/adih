import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';

/// Transisi halus dari WelcomeScreen ke HomeScreen —
/// fade + slide naik + scale ringan, terasa seperti masuk ke dunia belajar.
class WelcomeToHomeRoute extends PageRouteBuilder<void> {
  WelcomeToHomeRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 750),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );

            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
                  child: child,
                ),
              ),
            );
          },
        );
}
