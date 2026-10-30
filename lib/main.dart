import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'second_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp holds the app theme and the named route table.
    return MaterialApp(
      title: 'Student Mark Calculation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF7F3FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black87,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      // Named routes: the app starts at '/' and moves to '/second'.
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
      },
    );
  }
}
