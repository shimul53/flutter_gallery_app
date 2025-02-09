
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _isRequesting = false;
  String _statusMessage = "To show your black and white photos, we need your folder permission. We promise we don't take your photos.";

  Future<void> _requestPermission() async {
    setState(() {
      _isRequesting = true;
      _statusMessage = "Requesting permission...";
    });

    // Request permission
    final permission = (await Permission.photos.request()).isGranted ||
        (await Permission.storage.request()).isGranted;

    if (permission) {
      // If user just granted, navigate to album
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/album');
    } else {
      final status = await Permission.photos.status;
      if (status.isDenied || (await Permission.storage.status).isDenied) {
        setState(() {
          _statusMessage = "Permission denied. Please grant to continue.";
        });
      } else if (status.isPermanentlyDenied ||
          (await Permission.storage.status).isPermanentlyDenied) {
        setState(() {
          _statusMessage = "Permission permanently denied. Open settings to enable.";
        });

        await openAppSettings();
      }
    }

    setState(() => _isRequesting = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(),
            // Add the image here
            Image.asset(
              'assets/permission_img.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text("Require Permission",style: TextStyle(fontSize: 20,color: Color(0xFF212020)),),
            Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  _statusMessage,style: const TextStyle(fontSize: 14,color: Color(0xFF676767)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 280, // Makes the button take up the full width of its parent
              child: ElevatedButton(
                onPressed: _isRequesting ? null : _requestPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66FFB6), // Set button color
                  foregroundColor: Colors.black, // Set text color
                ),
                child: const Text("Grant Access"),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}