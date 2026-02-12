import 'package:baroallgi/core/provider/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      locale: const Locale('ko', 'KR'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const[Locale('ko', 'KR'),],
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'BMHANNA',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
    );

    // return MaterialApp(
    //   title: 'BaroAll Demo',
    //   theme: ThemeData(
    //     // tested with just a hot reload.
    //     fontFamily: 'BMHANNA',
    //     // colorScheme: .fromSeed(seedColor: Colors.deepPurple),
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
    //   ),
    //   home: const SplashPage(),
    // );
  }
}
