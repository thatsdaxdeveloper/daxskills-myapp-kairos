import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/controllers/providers/onboarding_provider.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';
import 'package:proto_kairos/views/widgets/my_expanded_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final List<Widget> pages = [
      _onboardingContent(
        context: context,
        isFirstPage: true,
        title: "Centralisez vos attentes",
        description: [
          TextSpan(
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
            text: "Ne perdez plus de vue ",
            children: [
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
                text: "les dates clés.",
              ),
              TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                text: " Gardez tous ",
              ),
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
                text: "vos événements importants ",
              ),
              TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                text: "à portée de main.",
              ),
            ],
          ),
        ],
        imagePath: Assets.eventsCalendar,
      ),
      _onboardingContent(
        context: context,
        title: "Suivi en  temps réel",
        description: [
          TextSpan(
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
            text: "Visualisez le temps restant ",
            children: [
              TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                text: "précisément, ",
              ),
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
                text: "jusqu'à la seconde",
              ),
              TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                text: ", pour ",
              ),
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
                text: "chaque objectif",
              ),
              TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                text: ".",
              ),
            ],
          ),
        ],
        imagePath: Assets.timeManagement,
      ),
      _onboardingContent(
        context: context,
        title: "Restez focalisé",
        description: [
          TextSpan(
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
            text: "Concentrez-vous sur l'essentiel ",
            children: [
              TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                text: "en laissant ",
              ),
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
                text: "Kairos ",
              ),
              TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                text: "le compte à rebours.",
              ),
            ],
          ),
        ],
        imagePath: Assets.target,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Align(alignment: Alignment(0, -0.86), child: _buildPageIndicator(context)),

          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, index) => pages[index],
            onPageChanged: (index) {},
          ),

          // Bouton de navigation
          SafeArea(
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Bouton de navigation
                  MyExpandedButton(
                    onTap: () async {
                      context.go('/home');
                      context.read<OnboardingProvider>().putOnboardingCompleted(true);
                    },
                    text: "Continuer",
                  ),
                  SizedBox(height: 4.h),
                  // Bientot disponible
                  Text(
                    "La synchronisation des données sera bientôt disponible.",
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _onboardingContent({
    required BuildContext context,
    required String title,
    required List<TextSpan> description,
    required String imagePath,
    bool isFirstPage = false,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 10.w),
      child: Stack(
        children: [
          // Titre du onboarding
          Align(
            alignment: Alignment(-1, -0.78),
            child: Text(title, style: textTheme.displayLarge),
          ),

          // Image du onboarding
          Align(
            alignment: Alignment.center,
            child: svgImage(path: imagePath),
          ),

          // Description du onboarding
          Align(
            alignment: Alignment(-1, isFirstPage ? 0.6 : 0.55),
            child: RichText(text: TextSpan(children: description)),
          ),
        ],
      ),
    );
  }

  // Construction d'un indicateur de page
  Widget _buildPageIndicator(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SmoothPageIndicator(
      controller: _pageController,
      count: 3,
      effect: WormEffect(
        activeDotColor: primaryColor,
        dotColor: Colors.white.withValues(alpha: 0.5),
        dotWidth: 100.w,
        dotHeight: 1.h,
      ),
    );
  }
}
