
import 'package:flutter/services.dart';

class PhotoRepository {
  static const _channel = MethodChannel("com.shimultamo.flutter_gallery_app");

  // Get all albums
  Future<List<Map<String, dynamic>>> getAlbums() async {
    final List<dynamic> rawList = await _channel.invokeMethod("getAlbums");
    return rawList.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  // Get photos for a specific album
  Future<List<String>> getImagesForAlbum(String albumName) async {
    final List<dynamic> result = await _channel.invokeMethod(
      "getImagesForAlbum",
      {"albumName": albumName},
    );
    return result.map((e) => e.toString()).toList();
  }
}