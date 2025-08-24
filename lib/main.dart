import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DownDatingApp());
}

class DownDatingApp extends StatelessWidget {
  const DownDatingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromARGB(255, 25, 25, 25),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    return MaterialApp(
      title: 'DownDating',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
      ),
      home: const SplashScreen(), // Direct to splash screen - no container
      debugShowCheckedModeBanner: false,
    );
  }
}