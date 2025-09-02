import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proto_kairos/app_routes.dart';
import 'package:proto_kairos/controllers/providers/countdown_provider.dart';
import 'package:proto_kairos/controllers/providers/onboarding_provider.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  await initializeDateFormatting('fr_FR', null);

  await Hive.initFlutter();
  Hive.registerAdapter(CountdownEntityAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => CountdownProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext _context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeApp.theme(),
          routerConfig: appRouter,
        );
      },
    );
  }
}
