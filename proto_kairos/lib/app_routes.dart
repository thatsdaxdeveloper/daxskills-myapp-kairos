import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/views/pages/home_page.dart';
import 'package:proto_kairos/views/pages/onboarding_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => OnboardingPage(),),
    GoRoute(path: '/home', pageBuilder: (context, state) => buildFadeTransitionPage(HomePage()),),
  ]
);

// Faire un fade sur la transition
CustomTransitionPage buildFadeTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage buildSlideTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0), // de droite
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}