import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissionAndNavigate();
  }



  Future<void> _checkPermissionAndNavigate() async {
    // Delay the execution by 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if the photos/storage permission is already granted
    final status = await Permission.photos.status;

    if (status.isGranted) {
      // If granted, navigate directly to the album screen
    //  Navigator.pushReplacementNamed(context, '/album');
    } else {
      //  Otherwise, navigate to the permission screen
      Navigator.pushReplacementNamed(context, '/permission');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Image.asset(
          'assets/splash_img.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}




