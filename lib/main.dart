import 'package:flutter/material.dart';
import 'package:flutter_gallery_app/providers/album_provider.dart';
import 'package:flutter_gallery_app/providers/photo_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/photo_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AlbumProvider>(
          create: (_) => AlbumProvider(PhotoRepository()),
        ),
        ChangeNotifierProvider<PhotoProvider>(
          create: (_) => PhotoProvider(PhotoRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


