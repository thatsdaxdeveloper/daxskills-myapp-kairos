import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/controllers/providers/onboarding_provider.dart';
import 'package:proto_kairos/controllers/scaffold_control.dart';
import 'package:proto_kairos/views/pages/acting_pages/add_event_page.dart';
import 'package:proto_kairos/views/pages/acting_pages/edit_event_page.dart';
import 'package:proto_kairos/views/pages/onboarding_page.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext _context) {
    final bool isOnboardingCompleted = _context.watch<OnboardingProvider>().isOnboardingCompleted;
    return isOnboardingCompleted ? const ScaffoldControl() : OnboardingPage();
  }
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const InitialPage(),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => buildFadeTransitionPage(const ScaffoldControl()),
    ),
    GoRoute(
      path: '/home/add',
      pageBuilder: (context, state) => buildFadeTransitionPage(const AddEventPage()),
    ),
    GoRoute(
      path: '/home/edit',
      pageBuilder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        return buildFadeTransitionPage(EditEventPage(eventId: params?["eventId"] ?? ""));
      },
    )
  ],
);

CustomTransitionPage buildFadeTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}