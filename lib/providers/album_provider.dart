// album_provider.dart
import 'package:flutter/foundation.dart';
import '../data/photo_repository.dart';
import '../models/album.dart';

class AlbumProvider with ChangeNotifier {
  final PhotoRepository _repo;
  AlbumProvider(this._repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Album> _albums = [];
  List<Album> get albums => _albums;

  Future<void> fetchAlbums() async {
    _isLoading = true;
    notifyListeners();
    try {
      final rawAlbums = await _repo.getAlbums();
      _albums = rawAlbums.map((map) => Album.fromMap(map)).toList();
    } catch (e) {
      // handle or log error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}