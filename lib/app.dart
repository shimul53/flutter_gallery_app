import 'package:flutter/material.dart';
import 'package:flutter_gallery_app/screens/full_photo_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/permission_screen.dart';
import 'screens/album_screen.dart';
import 'screens/photo_grid_screen.dart';


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
        '/album': (context) => const AlbumScreen(),
        '/photos': (context) {
          final albumName = ModalRoute.of(context)!.settings.arguments as String;
          return PhotoGridScreen(albumName: albumName);
        },
        '/fullPhoto': (context) {
          final photoPath = ModalRoute.of(context)!.settings.arguments as String;
          return FullPhotoScreen(photoPath: photoPath);
        },
      },
    );
  }
}