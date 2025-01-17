import 'package:flutter/material.dart';
import '../data/photo_repository.dart';
import '../models/photo.dart';

class PhotoProvider with ChangeNotifier {
  final PhotoRepository _photoRepository;

  PhotoProvider(this._photoRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Photo> _photos = [];
  List<Photo> get photos => _photos;

  Future<void> fetchPhotosForAlbum(String albumName) async {
    _isLoading = true;
    notifyListeners();

    try {
      final paths = await _photoRepository.getImagesForAlbum(albumName);
      _photos = paths.map((path) => Photo(path: path)).toList();
    } catch (e) {
      // handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}