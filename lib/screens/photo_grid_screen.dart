import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class PhotoGridScreen extends StatefulWidget {
  final String albumName;

  const PhotoGridScreen({Key? key, required this.albumName}) : super(key: key);

  @override
  _PhotoGridScreenState createState() => _PhotoGridScreenState();
}

class _PhotoGridScreenState extends State<PhotoGridScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhotoProvider>().fetchPhotosForAlbum(widget.albumName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoProvider = context.watch<PhotoProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.albumName)),
      body: photoProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : photoProvider.photos.isEmpty
              ? const Center(child: Text("No photos in this album."))
              : GridView.builder(
                  padding: const EdgeInsets.all(4.0),
                  itemCount: photoProvider.photos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    final photo = photoProvider.photos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/fullPhoto',
                          arguments: photo.path,
                        );
                      },
                      child: Image.file(
                        File(photo.path),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
    );
  }
}
