// ============================================================
// Experiment 5: Implementation of Navigation and Routing
// App: Student Academic Performance Calculator ("Marksheet" edition)
//
// Named routes:  '/'        -> HomeScreen   (input form)
//                '/second'  -> SecondScreen (result, receives a User)
// ============================================================

import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'second_screen.dart';

void main() {
  runApp(const MyApp());
}

// -------------------------------------------------------
// Palette – navy ink, sky paper, highlighter yellow
// -------------------------------------------------------
const Color kNavy = Color(0xFF0B2545);
const Color kSky = Color(0xFFEAF3FB);
const Color kBlue = Color(0xFF3A86FF);
const Color kHighlighter = Color(0xFFFFD60A);
const Color kMint = Color(0xFF2EC4B6);
const Color kMuted = Color(0xFF6B7A90);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Mark Calculation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kBlue),
        scaffoldBackgroundColor: kSky,
        appBarTheme: const AppBarTheme(
          backgroundColor: kNavy,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        // Same slide transition on every platform when pushing a route
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      // Route table: name -> screen builder
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
      },
    );
  }
}
