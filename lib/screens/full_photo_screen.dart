import 'dart:io';
import 'package:flutter/material.dart';

class FullPhotoScreen extends StatelessWidget {
  final String photoPath;
  const FullPhotoScreen({Key? key, required this.photoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // Display the chosen photo
        child: InteractiveViewer(
          panEnabled: true, // Allows panning
          scaleEnabled: true, // Allows zooming
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.file(
            File(photoPath),
            fit: BoxFit.contain, // Ensure the image fits within the screen
          ),
        ),

      ),
    );
  }
}