import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show ColorSchemeHarmonization, DynamicColorBuilder, Firebase, FirebaseCrashlytics, GoogleFonts, LuhkuRoutes, LukhuPayRoutes, MultiProvider, NavigationController, NavigationControllers, NavigationService, ReadContext, darkColorScheme, darkCustomColors, lightColorScheme, lightCustomColors;

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool weWantFatalErrorRecording = true;
  FlutterError.onError = (errorDetails) {
    if (weWantFatalErrorRecording) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  Map<String, Widget Function(BuildContext)> guardedAppRoutes = {
    ...LuhkuRoutes.guarded,
    ...LukhuPayRoutes.guarded
  };

  Map<String, Widget Function(BuildContext)> openAppRoutes = {
    ...LukhuPayRoutes.public,
    ...LuhkuRoutes.public,
  };
  runApp(
    MultiProvider(
      providers: [
        ...NavigationControllers.providers(
            guardedAppRoutes: guardedAppRoutes, openAppRoutes: openAppRoutes),
        ...LukhuPayRoutes.providers(),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();
          lightCustomColors = lightCustomColors.harmonized(lightScheme);

          // Repeat for the dark color scheme.
          darkScheme = darkDynamic.harmonized();
          darkCustomColors = darkCustomColors.harmonized(darkScheme);
        } else {
          // Otherwise, use fallback schemes.
          lightScheme = lightColorScheme;
          darkScheme = darkColorScheme;
        }

        return MaterialApp(
          title: 'Luhku Pay',
          routes: {...context.read<NavigationController>().availableRoutes},
          navigatorKey: NavigationService.navigatorKey,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightScheme,
            extensions: [lightCustomColors],
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
          // darkTheme: ThemeData(
          //   useMaterial3: true,
          //   colorScheme: darkScheme,
          //   extensions: [darkCustomColors],
          //    fontFamily: GoogleFonts.inter().fontFamily,
          // ),
          initialRoute: '/',
          onGenerateRoute: NavigationControllers.materialpageRoute,
        );
      },
    );
  }
}
