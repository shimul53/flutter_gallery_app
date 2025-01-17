class Album {
  final String name;
  final int count;
  final String thumbnailPath;

  Album({
    required this.name,
    required this.count,
    required this.thumbnailPath,
  });

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      name: map['name'] ?? 'Unknown',
      count: map['count'] ?? 0,
      thumbnailPath: map['thumbnailPath'] ?? '',
    );
  }
}