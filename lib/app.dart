import 'package:flutter/material.dart';
import 'package:flutter_gallery_app/screens/permission_screen.dart';
import 'screens/splash_screen.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Photo Gallery',
      debugShowCheckedModeBanner: false,
      // Start with splash
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/permission': (context) => const PermissionScreen(),

      },
    );
  }
}